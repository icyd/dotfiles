# Convert table<key, value> to key1=value1,key2=value2,...
export def table_2_string [
    table: table<key: string, value: string>
] {
    $table | each {|it| $"($it.key)=($it.value)"} | str join ','
}

# Convert table<string, string> to record, using col0 as key and col1 as value
export def to_record [
    table?: table
] {
    let stdin = $in
    let table = if ($stdin | is-empty) {
        $table
    } else {
        $stdin
    }
    let cols = $table | columns
    $table | reduce -f {} {|it, acc|
        $acc | upsert ($it | get $cols.0) ($it | get $cols.1)
    }
}

# Split text separated by null character into rows
export def split_0 [
] {
    ($in
        | str replace -r '\x00$' ''
        | split row (char -u "0")
    )
}

# Trim and copy
export def trimcopy [
    file?: path
] {
    if ($in != null) {
        $in | str trim | pbcopy
    } else {
        open $file | str trim | pbcopy
    }
}

# Pick random_row of table
export def random_row [
    table: table<any>
] {
    let picked_row = random int ..(($table | length) - 1)
    $table | get $picked_row
}

# Get template from gitignore.io
export def gitignore_template [
    input?: string
    --output (-o): string = ".gitignore" # output file
    --save (-s) # save result to output file
    --force (-f) # overwrite file (is ignored if --save is not used)
    --append (-a) # append to file instead (is ignored if --save is not used)
] {
    const url = "https://www.toptal.com/developers/gitignore/api"
    let filetype = if ($input | is-empty) {
        http get --raw $"($url)/list?format=lines" | lines | input list -f
    } else {
        $input
    }

    let body = http get --raw $"($url)/($filetype)"

    if (not $save) {
        return $body
    }

    if ($append) {
        $body | save --append $output
    } else if ($force) {
        $body | save --force $output
    } else {
        $body | save $output
    }
}

export def check_command_cache_hit [
    command: string
] {
    let path = which $command | get 0.path
    let target = $path | ls -l $in | get 0.target
    let path = if ($target | is-empty) {
        $path
    } else {
        $target
    }
    if not (($path | str starts-with '/nix/store')
        or ($path | str starts-with '/run/current-system/')) {
        return "Not a nix package"
    }

    $path | str replace -r '/nix/store/([^-]+)-.*' '$1' | try {
        http get $"https://nix-community.cachix.org/($in).narinfo" | ignore
        "HIT"
    } catch { "MISS" }
}
