# Nushell Config File
let base16_theme = {
    separator: $base03
    leading_trailing_space_bg: $base04
    header: $base0b
    empty: $base0d
    bool: $base08
    int: $base0b
    filesize: $base0d
    duration: $base08
    date: $base0e
    range: $base08
    float: $base08
    string: $base04
    nothing: $base08
    binary: $base08
    cellpath: $base08
    row_index: $base0c
    record: $base0d
    list: $base0d
    block: $base0d
    hints: $base02

    search_result: {bg: $base08 fg: $base04}
    shape_and: {fg: $base0e attr: b}
    shape_binary: {fg: $base0e attr: b}
    shape_block: {fg: $base0d attr: b}
    shape_bool: $base0d
    shape_closure: {fg: $base0c attr: b}
    shape_custom: {attr: b}
    shape_datetime: {fg: $base0d attr: b}
    shape_directory: $base0d
    shape_external: $base0c
    shape_externalarg: {fg: $base0b attr: b}
    shape_filepath: $base0d
    shape_flag: {fg: $base0d attr: b}
    shape_float: {fg: $base0e attr: b}

    shape_garbage: {fg: $base07 bg: $base08 attr: b}
    shape_globpattern: {fg: $base0d attr: b}
    shape_int: {fg: $base0e attr: b}
    shape_internalcall: {fg: $base0c attr: b}
    shape_list: {fg: $base0d attr: b}
    shape_literal: $base0d
    shape_match_pattern: $base0c
    shape_matching_brackets: { attr: u }
    shape_nothing: $base0d
    shape_operator: $base0a
    shape_or: {fg: $base0e attr: b}
    shape_pipe: {fg: $base0e attr: b}
    shape_range: {fg: $base0a attr: b}
    shape_record: {fg: $base0d attr: b}
    shape_redirection: {fg: $base0e attr: b}
    shape_signature: {fg: $base0b attr: b}
    shape_string: $base0b
    shape_string_interpolation: {fg: $base0d attr: b}
    shape_table: {fg: $base0d attr: b}
    shape_variable: $base0e
    shape_vardecl: $base0e
}

let menu_style = {
    text: $base06
    selected_text: {fg: $base0d attr: b}
    description_text: $base04
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
        | from json
        | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) {
            $in
        } else {
            null
        }
}

let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
        | $"value(char tab)description(char newline)" + $in
        | from tsv --flexible --no-infer
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
        | where name == $spans.0
        | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        nu => $fish_completer
        git => $fish_completer
        asdf => $fish_completer
        istioctl => $fish_completer
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
  ls: {
    use_ls_colors: true
    clickable_links: true # true or false to enable or disable clickable links in the ls listing. your terminal has to support links.
  }
  rm: {
    always_trash: false
  }
  # cd: {
  #   abbreviations: true
  # }
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
  # error_style: "fancy"
  datetime_format: {
  }
  history: {
    max_size: 100_000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share the history between multiple sessions, else you have to close the session to persist history to file
    file_format: "plaintext" # "sqlite" or "plaintext"
  }
  filesize: {
    metric: false # true => (KB, MB, GB), false => (KiB, MiB, GiB)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
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
  cursor_shape: {
    emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line (line is the default)
    vi_insert: block # block, underscore, line , blink_block, blink_underscore, blink_line (block is the default)
    vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line (underscore is the default)
  }
  color_config: $base16_theme
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  float_precision: 2
  buffer_editor: ""
  use_ansi_coloring: true
  bracketed_paste: true # enable bracketed paste, currently useless on windows
  edit_mode: vi
  shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
  show_banner: false
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.

  hooks: {
    pre_prompt: [{||
        let direnv = (direnv export json | from json | default {})
        if ($direnv | is-empty) {
            return
        }
        $direnv
            | items {|key, value|
                {
                    key: $key,
                    value: (if ($key in $env.ENV_CONVERSIONS) {
                        do ($env.ENV_CONVERSIONS | get $key | get from_string) $value
                    } else {
                        $value
                    }),
                }
            }
            | transpose -ird
            | load-env
    }]
    pre_execution: [{ null }]
    env_change: {
      PWD: [{|before, after|
        $env.PWD_STACK = if $before != null and $env.PWD_POPPING == false { ($env.PWD_STACK | append $before) } else { $env.PWD_STACK }
        $env.PWD_POPPING = false # must be here because of when the hook actually runs
      }]
    }
    display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
    command_not_found: { null } # return an error message when a command is not found
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
                | each {|it| {value: $it.name description: $it.usage}}
        }
      }
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
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
                | each {|it| {value: $it.name description: $it.usage}}
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
      modifier: control
      keycode: char_y
      mode: [ emacs vi_normal vi_insert ]
      event: {
        until: [
          { send: HistoryHintComplete }
          { send: menu name: completion_menu }
          { send: Enter }
        ]
      }
    }
    {
      name: accept_history_hint
      modifier: control
      keycode: char_y
      mode: [ vi_normal vi_insert ]
      event: {
        until: [
          { send: HistoryHintComplete }
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
          { send: menunext }
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
            { send: menuprevious }
            { send: Up }
        ]
      }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: next_page
      modifier: control
      keycode: char_f
      mode: [ vi_normal vi_insert ]
      event: {
        until: [
            # { send: menuright }
            { send: menupagenext }
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
            # { send: menuleft }
            { send: menupageprevious }
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
          {edit: pastecutbufferafter}
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
          { edit: cutfromlinestart }
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
          { edit: cuttolineend }
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: control
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
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
  ]
}

def nvim_client [...files: path] {
    if ((uname -s) == "Darwin") {
        for $f in $files {
            nvim --server $env.NVIM_SERVER --remote (greadlink -mq $f)
        }
    } else {
        for $f in $files {
            nvim --server $env.NVIM_SERVER --remote (readlink -mq $f)
        }
    }
}

def --env pop [] {
    $env.PWD_POPPING = true;
    cd ($env.PWD_STACK | last);
    $env.PWD_STACK = ($env.PWD_STACK | drop);
}

def --env mkcd [directory: string] {mkdir $directory; cd $directory}
