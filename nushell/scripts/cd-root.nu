# Change directory to current git repository root directory.
# If `path` is specidied, change to it instead.
#
export def-env cd-gitroot [
    path?: string # Relative path from git root directory
] {
    let is_inside_worktree = (do -i { git rev-parse --is-inside-work-tree | complete })
    if $is_inside_worktree.exit_code != 0 or ($is_inside_worktree.stdout | str trim) != "true" {
        echo $env.PWD
        let span = (metadata $env.PWD).span
        echo $span
        error make {
            msg: "Not in git repository",
            label: {
                text: "This isn't a git repo",
                start: $span.start,
                end: $span.end,
            },
        }
    }

    let root_path = (git rev-parse --show-toplevel)
    cd $"($root_path)/($path)"
}

export alias cdr = cd-gitroot
