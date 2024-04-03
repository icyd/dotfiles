$env.PROMPT_INDICATOR =  "〉"
$env.PROMPT_INDICATOR_VI_INSERT =  " "
$env.PROMPT_INDICATOR_VI_NORMAL =  " "
$env.PROMPT_MULTILINE_INDICATOR =  " "

$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
    $"($env.HOME)/.scripts"
    $"($env.HOME)/.scripts.local"
    $"($env.HOME)/Projects/nu_scripts"
    ($env.NUPM_HOME | path join "modules")
]

$env.PATH = ($env.PATH
    | split row (char esep)
    | prepend ($env.NUPM_HOME | path join "scripts")
    | uniq
)

$env.ENV_CONVERSIONS = {}
$env.PWD_STACK = []
$env.PWD_POPPING = false
