# if not ("__ONESHOT_SOURCED" in ($env | columns)) {
#     $env.__ONESHOT_SOURCED = 1
    $env.PROMPT_INDICATOR =  "〉"
    $env.PROMPT_INDICATOR_VI_INSERT =  " "
    $env.PROMPT_INDICATOR_VI_NORMAL =  " "
    $env.PROMPT_MULTILINE_INDICATOR =  " "

    let paths_to_prepend = [
        $"($env.HOME)/.asdf/shims"
        "/opt/homebrew/bin"
        "/opt/homebrew/opt/coreutils/libexec/gnubin"
    ]

    let paths_to_append = [
        $"($env.CARGO_HOME)/bin"
        $"($env.GOPATH)/bin"
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.krew/bin"
        $"($env.HOME)/.ghcup/bin"
        $"($env.HOME)/.cabal/bin"
    ]

    let man_paths = [
        "/opt/homebrew/opt/coreutils/libexec/gnuman"
    ]

    $env.MANPATH = (
        try {$env.MANPATH} catch {[]} |
        append $man_paths
    )

    $env.PATH = (
        $env.PATH |
        split row (char esep) |
        prepend $paths_to_prepend |
        append $paths_to_append
    )

    $env.NU_PLUGIN_DIRS = [
        ($nu.config-path | path dirname | path join 'scripts')
    ]

    $env.NU_LIB_DIRS = [
        ($nu.config-path | path dirname | path join 'scripts')
        $"($env.HOME)/.scripts"
        $"($env.HOME)/Projects/nu_scripts"
    ]

    $env.ENV_CONVERSIONS = {}
    $env.PWD_STACK = []
    $env.PWD_POPPING = false
# }
