use std/config *

let carapace_completer = {|spans: list<string>|
    CARAPACE_LENIENT=1 carapace $spans.0 nushell ...$spans | from json
}

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
        | where name == $spans.0
        | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        eksctl => $fish_completer
        gopass => $fish_completer
        istioctl => $fish_completer
        stern => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "prefix"  # prefix, fuzzy
    external: {
      enable: true
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: $external_completer
    }
  }
  bracketed_paste: true # enable bracketed paste, currently useless on windows
  buffer_editor: $buf_editor
  cursor_shape: {
    emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line (line is the default)
    vi_insert: block # block, underscore, line , blink_block, blink_underscore, blink_line (block is the default)
    vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line (underscore is the default)
  }
  datetime_format: {
  }
  display_errors: {
    exit_code: false
    termination_signal: true
  }
  edit_mode: vi
  error_style: "fancy"
  footer_mode: 25 # always, never, number_of_rows, auto
  filesize: {
    unit: "binary"
    precision: 1
  }
  float_precision: 2
  history: {
    file_format: "sqlite" # "sqlite" or "plaintext"
    isolation: true
    max_size: 500_000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share the history between multiple sessions, else you have to close the session to persist history to file
  }
  ls: {
    use_ls_colors: true
    clickable_links: true # true or false to enable or disable clickable links in the ls listing. your terminal has to support links.
  }
  recursion_limit: 50
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
  rm: {
    always_trash: false
  }
  shell_integration: {
      # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
      osc2: true
      # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
      osc7: true
      # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it. show_clickable_links is deprecated in favor of osc8
      osc8: true
      # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
      osc9_9: false
      # osc133 is several escapes invented by Final Term which include the supported ones below.
      # 133;A - Mark prompt start
      # 133;B - Mark prompt end
      # 133;C - Mark pre-execution
      # 133;D;exit - Mark execution finished with exit code
      # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
      osc133: true
      # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
      # 633;A - Mark prompt start
      # 633;B - Mark prompt end
      # 633;C - Mark pre-execution
      # 633;D;exit - Mark execution finished with exit code
      # 633;E - Explicitly set the command line with an optional nonce
      # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
      # and also helps with the run recent menu in vscode
      osc633: true
      # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
      reset_application_mode: true
  }
  show_banner: false
  table: {
      mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
      index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
      show_empty: true
      trim: {
        methodology: wrapping # truncating
        wrapping_try_keep_words: true
        truncating_suffix: "..."
      }
  }
  use_ansi_coloring: true

  hooks: {
  pre_prompt: [{ null }]
  pre_execution: [{ null }]
  env_change: {
    PWD: [
      {|before, after|
          $env.PWD_STACK = if $before != null and $env.PWD_POPPING == false { ($env.PWD_STACK | append $before) } else { $env.PWD_STACK }
          $env.PWD_POPPING = false # must be here because of when the hook actually runs
        zellij_update_tabname $after
      }
      {||
          if (which direnv | is-empty) {
            return
          }

          direnv export json | from json | default {} | update cells --columns [ PATH ] {
            do (env-conversions).path.from_string $in
          } | load-env
      }
    ]
  }
  display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
  command_not_found: {|cmd|
      let pkgs = ^nix-locate --minimal --no-group --type x --type s --whole-name --at-root $"/bin/($cmd)"
          | lines
      if ($pkgs | is-empty) {
          return null
      }

      let install = {|pkgs| $pkgs | each {|p| $"   nix shell nixpkgs#($p) or ,s ($p)"}}
      let run = {|pkgs| $pkgs | each {|p| $"   nix shell nixpkgs#($p) --command '($cmd) ...' or , ($p) -- args"}}
      return ([
          $"The program `($cmd)` is currently not installed.\n"
          "You can install it in the current shell with:"
          (do $install $pkgs | str join "\n")
          "\nOr run it once with:"
          (do $run $pkgs | str join "\n")
      ] | str join "\n")
   }
  }

  menus: [
    # Configuration for default nushell menus
    # Note the lack of source parameter
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
          layout: columnar
          columns: 4
          col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
          col_padding: 2
      }
      style: $menu_style
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "? "
      type: {
          layout: list
          page_size: 10
      }
      style: $menu_style
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: "? "
      type: {
          layout: description
          columns: 4
          col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
          col_padding: 2
          selection_rows: 4
          description_rows: 10
      }
      style: $menu_style
    }
    # Example of extra menus created using a nushell source
    # Use the source field to create a list of records that populates
    # the menu
    {
      name: commands_menu
      only_buffer_difference: false
      marker: "# "
      type: {
          layout: columnar
          columns: 4
          col_width: 20
          col_padding: 2
      }
      style: $menu_style
      source: {|buffer, position|
          scope commands
              | where name =~ $buffer
              | each {|it| {value: $it.name description: $it.description}}
      }
    }
    {
      name: vars_menu
      only_buffer_difference: true
      marker: "$ "
      type: {
          layout: list
          page_size: 10
      }
      style: $menu_style
      source: {|buffer, position|
          scope variables
              | where name =~ $buffer
              | sort-by name
              | each {|it| {value: $it.name description: $it.type}}
      }
    }
    {
      name: commands_with_description
      only_buffer_difference: true
      marker: "# "
      type: {
          layout: description
          columns: 4
          col_width: 20
          col_padding: 2
          selection_rows: 4
          description_rows: 10
      }
      style: $menu_style
      source: { |buffer, position|
          scope commands
              | where name =~ $buffer
              | each {|it| {value: $it.name description: $it.description}}
      }
    }
    {
        name: zoxide_menu,
        only_buffer_difference: true
        marker: "Z "
        type: {
            layout: columnar
            page_size: 20
        }
        style: $menu_style
        source: {|buffer, position|
            zoxide query -ls $buffer
                | parse -r '(?P<description>[0-9.]+)\s+(?P<value>.+)'
        }
    }
  ]

  keybindings: [
    {
      name: clear_everything
      modifier: control
      keycode: char_l
      mode: [ emacs vi_normal vi_insert ]
      event: [
        { send: ClearScreen }
        { send: ClearScrollback }
      ]
    }
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [ emacs vi_normal vi_insert ]
      event: {
        until: [
          { send: Menu name: completion_menu }
          { send: MenuNext }
          { edit: Complete }
        ]
      }
    }
    {
      name: completion_previous_menu
      modifier: shift
      keycode: backtab
      mode: [ emacs vi_normal vi_insert ]
      event: {
        until: [
          { send: MenuPrevious }
        ]
      }
    }
    {
      name: accept_history_hint
      modifier: control
      keycode: char_y
      mode: [ emacs vi_normal vi_insert ]
      event: {
        until: [
          { send: HistoryHintComplete }
          { send: Menu name: completion_menu }
          { send: Enter }
        ]
      }
    }
    {
      name: completion_next
      modifier: control
      keycode: char_n
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: {
        until: [
          { send: MenuNext }
          { send: Down }
        ]
      }
    }
    {
      name: completion_previous
      modifier: control
      keycode: char_p
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: {
        until: [
            { send: MenuPrevious }
            { send: Up }
        ]
      }
    }
    {
    name: history_menu
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
    event: { send: Menu name: history_menu }
       }
       {
    name: help_menu
    modifier: control
    keycode: char_s
    mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
    event: { send: Menu name: help_menu }
       }
    {
      name: next_page
      modifier: control
      keycode: char_f
      mode: [ vi_normal vi_insert ]
      event: {
        until: [
            { send: MenuPageNext }
        ]
      }
    }
    {
      name: previous_page
      modifier: control
      keycode: char_b
      mode: [ vi_normal vi_insert ]
      event: {
        until: [
            { send: MenuPagePrevious }
        ]
      }
    }
    {
      name: yank
      modifier: control
      keycode: char_v
      mode: [ vi_insert vi_normal ]
      event: {
        until: [
          { edit: PasteCutBufferAfter }
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { edit: CutFromLineStart }
        ]
      }
    }
    {
      name: kill-char
      modifier: control
      keycode: char_h
      mode: [ emacs, vi_normal, vi_insert ]
      event: { edit: cutchar }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { edit: CutToLineEnd }
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: Menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: control
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: Menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: { send: Menu name: commands_with_description }
    }
    {
      name: edit_command_line
      modifier: control
      keycode: char_e
      mode: [ emacs vi_normal vi_insert ]
      event: { send: OpenEditor }
    }
    {
      name: backward_kill_word
      modifier: control
      keycode: char_w
      mode: [ emacs vi_normal vi_insert ]
      event: { edit: CutWordLeft }
    }
    {
        name: zoxide_menu
        modifier: control
        keycode: char_z
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: Menu name: zoxide_menu }
        ]
    }
  ]
}

def zellij_update_tabname [
    PWD: string
] {
    if ("ZELLIJ" in ($env | columns)) {
        let tab_name = if ((git rev-parse --is-inside-work-tree | complete).exit_code == 0) {
            $"(git rev-parse --show-toplevel | basename $in)/(git rev-parse --show-prefix)"
                | str trim -c '/'
        } else if ($PWD == $env.HOME) {
            "~"
        } else {
            $PWD | path basename
        }

        nohup zellij action rename-tab $tab_name out+err> /dev/null
    }
}

def nvim_get_server [] : nothing -> list<string> {
    let socket = if (not ($env | get -o NVIM | is-empty)) {
        $env.NVIM
    } else if (not ($env | get -o NVIM_SERVER | is-empty)) {
        $env.NVIM_SERVER
    } else if ("/tmp/nvim-server" | path exists) {
        open /tmp/nvim-server
    } else {
        "/tmp/nvimsocket"
    }

    if ($socket | path exists) {
        return [--server $socket --remote-silent]
    }

    return [--listen $socket]
}

def --wrapped nvim_server [
    --remote (-r)
    ...args
] {
    let address = nvim_get_server
    if $remote {
        return (nvim --server $address --remote-ui ...$args)
    }

    return (nvim --listen $address ...$args)
}

def --wrapped nvim_client [
    --remote (-r)
    ...args: string
] {
    let remote_args: list<string> = if $remote {
        [--remote-ui]
    } else {
        []
    }
    let server_args = (nvim_get_server) ++ $remote_args
    let split_args = $args | split list "--"
    let cmd_args = $server_args ++ (if ($split_args | length) > 1 {
        $split_args | get 0
    } else {
        $split_args | get 0 | where $in starts-with '-'
    }) | uniq
    let files = if ($split_args | length) > 1 {
        $split_args | get 1
    } else {
        $split_args | get 0 | where {not ($in starts-with '-')}
    } | path expand

    nvim ...$cmd_args ...$files
}

def _rotate [
    array: list<any>
    idx: int
] {
    let len = $array | length
    let idx = $idx mod $len
    let first = $array | first $idx
    let remain = $array | last ($len - $idx)
    $remain | append $first
}

def dirs [] {
    $env.PWD_STACK | reverse
}

def --env pop [] {
    if (($env.PWD_STACK | length) > 0) {
        $env.PWD_POPPING = true;
        cd ($env.PWD_STACK | last);
        $env.PWD_STACK = ($env.PWD_STACK | drop);
    }
}

def --env dirup [idx: int = 1] {
    let len = $env.PWD_STACK | length
   if (($len > 0) and ($idx > 0)) {
        let idx = $len - ($idx mod $len)
        $env.PWD_POPPING = true;
        $env.PWD_STACK = (_rotate $env.PWD_STACK $idx)
        cd ($env.PWD_STACK | last)
   }
}

def --env mkcd [directory: string] {mkdir $directory; cd $directory}

def --wrapped lg [...args] {with-env { SHELL: "nu" } { lazygit ...$args }}

export def pw [
    query?: string
    --show (-s)
] {
    use std/log
    let fzf_query = $query | default ""

    let raw_selection = gopass list --flat
        | (fzf --keep-right --ansi --prompt="Select secret :: "
            --print-query --preview="" --query $fzf_query)
        | complete
    log debug $"Raw selection: ($raw_selection)"
    let fzf_stdout =  $raw_selection.stdout | lines

    if (($raw_selection.exit_code != 0) or (($fzf_stdout | length) == 1)) {
        error make {
            msg: $"No password selected with query: ($fzf_stdout | first)",
            label: {
                text: "this query",
                span: (metadata $query).span
            }
        }
    }
    let selection = $fzf_stdout | get 1
    log debug $"Selection: ($selection)"

    if ($show) {
        let record = gopass show $selection err> /dev/null
            | lines
        log debug $"Record: ($record)"

        if not ($record | is-empty) {
            let record = $record
            | parse "{key}:{value}"
            | str trim
            | compact --empty
            | transpose --header-row
            | into record

            print $record
        }
    }

    gopass show -c $selection
}

def --wrapped _run_in_nu [
    command: string
    ...args
] {
    let nu_path = which nu | get -o path.0
    let nu_bin = if not ($nu_path | is-empty) {
        $nu_path
    } else {
        "nu"
    }
    with-env { SHELL: $nu_bin } {
        run-external (which $"^($command)" | get path.0) ...$args
    }
}

def "nu-complete zoxide path" [context: string] {
    let parts = $context | split row " " | skip 1
    {
        options: {
            sort: false,
            completion_algorithm: substring,
            case_sensitive: false,
        },
        completions: (^zoxide query --list --exclude $env.PWD -- ...$parts | lines)
    }
}

def --env --wrapped __zoxide_z [...args: string@"nu-complete zoxide path"] {
  let path = match $args {
    [] => {'~'},
    [ '-' ] => {'-'},
    [ $arg ] if ($arg | path expand | path type) == 'dir' => {$arg}
    _ => {
      ^zoxide query --exclude $env.PWD -- ...$args | str trim -r -c "\n"
    }
  }
  cd $path
}

# Jump to a directory using interactive search.
def --env --wrapped __zoxide_zi [...rest:string] {
  cd $'(^zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
}

alias z = __zoxide_z
alias zi = __zoxide_zi
