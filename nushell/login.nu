def nvim_get_server [] {
    if (("NVIM_SERVER" in ($env | columns)) and (not ($env.NVIM_SERVER | is-empty))) {
        $env.NVIM_SERVER
    } else if ("/tmp/nvim-server" | path exists) {
        open /tmp/nvim-server
    } else {
        "/tmp/nvimsocket"
    }
}

def nvim_server [] {
    nvim --listen (nvim_get_server)
}

def nvim_client [...files: path] {
    let readlink = if ((^uname -s) == "Darwin") {
        {|it| greadlink -mq $it}
    } else {
        {|it| readlink -mq $it}
    }

    for $f in ($files | each $readlink) {
        nvim --server (nvim_get_server) --remote-silent $f
    }
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
