def ensure-cache-by-lines [cache path action] {
    let ls = (do -i { open $path | lines | length })
    if ($ls | is-empty) { return false }
    let lc = (do -i { open $cache | get lines})
    if not (($cache | path exists) and (not ($lc | is-empty)) and ($ls == $lc)) {
        mkdir ($cache | path dirname)
        {
            lines: $ls
            payload: (do $action)
        } | save -f $cache
    }
    (open $cache).payload
}

def normalize-column-names [ ] {
    let i = $in
    let cols = ($i | columns)
    mut t = $i
    for c in $cols {
        $t = ($t | rename -c {$c: ($c | str downcase | str replace ' ' '_')})
    }
    $t
}

def sprb [flag, args] {
    if $flag {
        $args
    } else {
        []
    }
}

def spr [args] {
    let lst = ($args | last)
    if ($lst | is-empty) {
        []
    } else {
        let init = ($args | range ..-2)
        if ($init | is-empty) {
            [ $lst ]
        } else {
            $init | append $lst
        }
    }
}

def record-to-set-json [value] {
    $value | transpose k v
    | each {|x| $"($x.k)=($x.v | to json -r)"}
    | str join ','
}

# def parse_cellpath [path] {
#     $path | split row '.' | each {|x|
#         if ($x | find --regex "^[0-9]+$" | is-empty) {
#             $x
#         } else {
#             $x | into int
#         }
#     }
# }
#
# def get_cellpath [record path] {
#     $path | reduce -f $record {|it, acc| $acc | get $it }
# }
#
# def set_cellpath [record path value] {
#     if ($path | length) > 1 {
#         $record | upsert ($path | first) {|it|
#             set_cellpath ($it | get ($path | first)) ($path | range 1..) $value
#         }
#     } else {
#         $record | upsert ($path | last) $value
#     }
# }
#

def upsert_row [table col mask id value] {
    # let value = ($mask | reduce -f $value {|it, acc|
    #     let path = (parse_cellpath $it)
    #     set_cellpath $value $path (get_cellpath $table $path)
    # })
    if $id in ($table | get $col) {
        $table | each {|x|
            if ($x | get $col) == $id {
                $value
            } else {
                $x
            }
        }
    } else {
        $table | append $value
    }
}

def get-sign [cmd] {
    let x = (scope commands | where name == $cmd).signatures?.0?.any?
    mut s = []
    mut n = {}
    mut p = []
    for it in $x {
        if $it.parameter_type in ['switch' 'named'] {
            let name = $it.parameter_name
            if not ($it.short_flag | is-empty) {
                $n = ($n | upsert $it.short_flag $name)
            }
            if $it.parameter_type == 'switch' {
                $s = ($s | append $name)
                if not ($it.short_flag | is-empty) {
                    $s = ($s | append $it.short_flag)
                }
            }
        } else if $it.parameter_type == 'positional' {
            $p = ($p | append $it.parameter_name)
        }
    }
    { switch: $s, name: $n, positional: $p }
}

def "parse cmd" [] {
    let cmd = ($in | split row ' ')
    let sign = (get-sign $cmd.0)
    mut sw = ''
    mut pos = []
    mut opt = {}
    for c in $cmd {
        if ($sw | is-empty) {
            if ($c | str starts-with '-') {
                let c = if ($c | str substring 1..2) != '-' {
                    let k = ($c | str substring 1..)
                    if $k in $sign.name {
                        $'($sign.name | get $k)'
                    } else {
                        $k
                    }
                } else {
                    $c | str substring 2..
                }
                if $c in $sign.switch {
                    $opt = ($opt | upsert $c true)
                } else {
                    $sw = $c
                }
            } else {
                $pos ++= [$c]
            }
        } else {
            $opt = ($opt | upsert $sw $c)
            $sw = ''
        }
    }
    $opt._args = $pos
    $opt._pos = ( $pos | range 1.. | enumerate | reduce -f {} {|it, acc| $acc | upsert ($sign.positional | get $it.index) $it.item } )
    $opt
}

def "nu-complete helm list" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    kgh -n $ctx.namespace? | each {|x| {value: $x.name  description: $x.updated} }
}

def "nu-complete helm charts" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    let path = ($ctx | get _pos.chart)
    let path = if ($path | is-empty) { '.' } else { $path }
    let paths = (do -i { ls $"($path)*" | each {|x| if $x.type == dir { $"($x.name)/"} else { $x.name }} })
    helm repo list | from ssv -a | rename value description
    | append $paths
}

def "nu-complete kube ns" [] {
    kubectl get namespaces
    | from ssv -a
    | each {|x|
        {value: $x.NAME, description: $"($x.AGE)\t($x.STATUS)"}
    }
}

export def "nu-complete kube kind without cache" [] {
    kubectl api-resources | from ssv -a | get NAME
    | append (kubectl get crd | from ssv -a | get NAME)
}

export def "nu-complete kube kind" [] {
    let ctx = (kube-config)
    let cache = $'($env.HOME)/.cache/nu-complete/k8s-api-resources/($ctx.data.current-context).json'
    ensure-cache-by-lines $cache $ctx.path {||
        kubectl api-resources | from ssv -a
        | each {|x| {value: $x.NAME description: $x.SHORTNAMES} }
        | append (kubectl get crd | from ssv -a | each {|x| {$x.NAME} })
    }
}

def "nu-complete kube res" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    let kind = ($ctx | get _args.1)
    let ns = if ($ctx.namespace? | is-empty) { [] } else { [-n $ctx.namespace] }
    kubectl get $ns $kind | from ssv -a | get NAME
}

export def "nu-complete kube jsonpath" [context: string] {
    let ctx = ($context | parse cmd)
    let kind = ($ctx | get _args.1)
    let res = ($ctx | get _args.2)
    let path = $ctx.jsonpath?
    let ns = if ($ctx.namespace? | is-empty) { [] } else { [-n $ctx.namespace] }
    mut r = []
    if ($path | is-empty) {
        if ($context | str ends-with '-p ') {
            $r = ['.']
        } else {
            $r = ['']
        }
    } else if ($path | str starts-with '.') {
        let row = ($path | split row '.')
        let p = ($row  | range ..-2 | str join '.')
        if ($p | is-empty) {
            $r = ( kubectl get $ns -o json $kind $res
                 | from json
                 | columns
                 | each {|x| $'($p).($x)'}
                 )
        } else {
            let m = (kubectl get $ns $kind $res $"--output=jsonpath={($p)}" | from json)
            let l = ($row | last)
            let c = (do -i {$m | get $l})
            if (not ($c | is-empty)) and ($c | describe | str substring 0..5) == 'table' {
                $r = (0..(($c | length) - 1) | each {|x| $'($p).($l)[($x)]'})
            } else {
                $r = ($m | columns | each {|x| $'($p).($x)'})
            }
        }
    } else {
        $r = ['']
    }
    $r
}

export def "nu-complete kube ctx" [] {
    let k = (kube-config)
    let cache = $'($env.HOME)/.cache/nu-complete/k8s/($k.path | path basename).json'
    let data = (ensure-cache-by-lines $cache $k.path { ||
        let clusters = ($k.data | get clusters | select name cluster.server)
        let data = ($k.data
            | get contexts
            | reduce -f {completion:[], mx_ns: 0, mx_cl: 0} {|x, a|
                let ns = (if ($x.context.namespace? | is-empty) { '' } else { $x.context.namespace })
                let max_ns = ($ns | str length)
                let cluster = ($"($x.context.user)@($clusters | where name == $x.context.cluster | get cluster_server.0)")
                let max_cl = ($cluster | str length)
                $a
                | upsert mx_ns (if $max_ns > $a.mx_ns { $max_ns } else $a.mx_ns)
                | upsert mx_cl (if $max_cl > $a.mx_cl { $max_cl } else $a.mx_cl)
                | upsert completion ($a.completion | append {value: $x.name, ns: $ns, cluster: $cluster})
            })
        {completion: $data.completion, max: {ns: $data.mx_ns, cluster: $data.mx_cl}}
    })

    $data.completion | each {|x|
        let ns = ($x.ns | fill -a l -w $data.max.ns -c ' ')
        let cl = ($x.cluster | fill -a l -w $data.max.cluster -c ' ')
        {value: $x.value, description: $"\t($ns) ($cl)"}
    }
}

export def "nu-complete kube pods" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    let ns = (do -i { $ctx | get namespace })
    let ns = if ($ns != null) { (spr [-n $ns]) } else { [] }
    kubectl get $ns pods | from ssv -a | get NAME
}

export def "nu-complete kube ctns" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    let ns = (do -i { $ctx | get namespace })
    let ns = if ($ns != null) { (spr [-n $ns]) } else { [] }
    let ctn = (do -i { $ctx | get container })
    let ctn = if ($ctn != null) { (spr [-c $ctn]) } else { [] }
    let pod = ($ctx | get _args.1)
    kubectl get $ns pod $pod -o jsonpath={.spec.containers[*].name} | split row ' '
}

export def "nu-complete port forward type" [] {
    [pod svc]
}

export def "nu-complete kube port" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    let kind = ($ctx | get _args.1)
    let ns = if ($ctx.namespace? | is-empty) { [] } else { [-n $ctx.namespace] }
    let res = ($ctx | get _args.2)
    if ($kind | str starts-with 's') {
        kubectl get $ns svc $res --output=jsonpath="{.spec.ports}"
        | from json
        | each {|x| {value: $x.port  description: $x.name} }
    } else {
        kubectl get $ns pods $res --output=jsonpath="{.spec.containers[].ports}"
        | from json
        | each {|x| {value: $x.containerPort description: $x.name?} }
    }
}

export def "nu-complete kube cp" [cmd: string, offset: int] {
    let ctx = ($cmd | str substring ..$offset | parse cmd)
    let p = ($ctx._args | get (($ctx._args | length) - 1))
    let ns = (do -i { $ctx | get namespace })
    let ns = (spr [-n $ns])
    let c = (do -i { $ctx | get container })
    let c = (spr [-c $c])
    let ctn = (kubectl get pod $ns | from ssv -a | each {|x| {description: $x.READY value: $"($x.NAME):" }})
    let n = ($p | split row ':')
    if $"($n | get 0):" in ($ctn | get value) {
        kubectl exec $ns ($n | get 0) $c -- sh -c $"ls -dp ($n | get 1)*"
        | lines
        | each {|x| $"($n | get 0):($x)"}
    } else {
        let files = (do -i { ls -a $"($p)*"
            | each {|x| if $x.type == dir { $"($x.name)/"} else { $x.name }}
        })
        $files | append $ctn
    }
}

export def "nu-complete num9" [] { [0 1 2 3] }

def "kube res via name n" [context: string, offset: int, n: int] {
    let ctx = ($context | parse cmd)
    let kind = ($env.KUBERNETES_RESOURCE_ABBR | get ($ctx | get _args.0 | str substring ((-1 * $n)..)))
    let ns = if ($ctx.namespace? | is-empty) { [] } else { [-n $ctx.namespace] }
    kubectl get $ns $kind | from ssv -a | get NAME
}

export def "nu-complete kube res via name" [context: string, offset: int] {
    kube res via name n $context $offset 1
}

export def "nu-complete kube res via name2" [context: string, offset: int] {
    kube res via name n $context $offset 2
}

export def "nu-complete kube res via name3" [context: string, offset: int] {
    kube res via name n $context $offset 3
}

export def "nu-complete dry-run" [] {
    [none client server]
}

export def "nu-complete cascade" [] {
    [background orphan foreground]
}

export def `kcache flush` [] {
    rm -rf ~/.cache/nu-complete/k8s/
    nu-complete kube ctx
    rm -rf ~/.cache/nu-complete/k8s-api-resources/
}


# kubectl apply -f
export def kaf [p: path] {
    kubectl apply -f $p
}

# kubectl diff -f
export def kdf [p: path] {
    kubectl diff -f $p
}

# kubectl delete -f
export def kdelf [p: path] {
    kubectl delete -f $p
}

# kubectl apply -k (kustomize)
export def kak [p: path] {
    kubectl apply -k $p
}

# kubectl diff -k (kustomize)
export def kdk [p: path] {
    kubectl diff -k $p
}

# kubectl delete -k (kustomize)
export def kdelk [p: path] {
    kubectl delete -k $p
}

# kubectl kustomize (template)
export def kk [p: path] {
    kubectl kustomize $p
}

# helm list and get
export def kgh [
    name?: string@"nu-complete helm list"
    --namespace (-n): string@"nu-complete kube ns"
    --manifest (-m)
    --values(-v)
    --all (-A)
] {
    if ($name | is-empty) {
        let ns = if $all { [--all] } else { (spr [-n $namespace]) }
        helm list $ns --output json
        | from json
        | update updated {|x|
            $x.updated
            | str substring ..-4
            | into datetime -f '%Y-%m-%d %H:%M:%S.%f %z'
        }
    } else {
        if $manifest {
            helm get manifest $name (spr [-n $namespace])
        } else if $values {
            helm get values $name (spr [-n $namespace])
        } else {
            helm get notes $name (spr [-n $namespace])
        }
    }
}

# helm install or upgrade via values file
export def kah [
    name: string@"nu-complete helm list"
    chart: string@"nu-complete helm charts"
    valuefile: path
    --values (-v): any
    --namespace (-n): string@"nu-complete kube ns"
] {
    let update = $name in (
        helm list (spr [-n $namespace]) --output json
        | from json | get name
    )
    let act = if $update { [upgrade] } else { [install] }
    let values = if ($values | is-empty) { [] } else { [--set-json (record-to-set-json $values)] }
    helm $act $name $chart -f $valuefile $values (spr [-n $namespace])
}

# helm diff
export def kdh [
    name: string@"nu-complete helm list"
    chart: string@"nu-complete helm charts"
    valuefile: path
    --values (-v): any
    --namespace (-n): string@"nu-complete kube ns"
    --has-plugin (-h)
] {
    if $has_plugin {
        helm diff $name $chart -f $valuefile (spr [-n $namespace])
    } else {
        let update = $name in (
            helm list (spr [-n $namespace]) --output json
            | from json | get name
        )
        if not $update {
            echo "new installation"
            return
        }

        let values = if ($values | is-empty) { [] } else { [--set-json (record-to-set-json $values)] }
        let target = $'/tmp/($chart | path basename).($name).out.yaml'
        helm template --debug $name $chart -f $valuefile $values (spr [-n $namespace]) | save -f $target
        kubectl diff -f $target
    }
}

# helm delete
export def kdelh [
    name: string@"nu-complete helm list"
    --namespace (-n): string@"nu-complete kube ns"
] {
    helm uninstall $name (spr [-n $namespace])
}

# helm template
export def kh [
    chart: string@"nu-complete helm charts"
    valuefile: path
    --values (-v): any
    --namespace (-n): string@"nu-complete kube ns"='test'
    --app (-a): string='test'
] {
    let values = if ($values | is-empty) { [] } else { [--set-json (record-to-set-json $values)] }
    let target = ($valuefile | split row '.' | range ..-2 | append [out yaml] | str join '.')
    if (not ($target | path exists)) and (([yes no] | input list $'create ($target)?') in [no]) { return }
    helm template --debug $app $chart -f $valuefile $values (spr [-n $namespace])
    | save -f $target
}

### ctx
export def "kube-config" [] {
    let file = if ($env.KUBECONFIG? | is-empty) { $"($env.HOME)/.kube/config" } else { $env.KUBECONFIG }
    { path: $file, data: (cat $file | from yaml) }
}

# kubectl change context
export def kcc [ctx: string@"nu-complete kube ctx"] {
    kubectl config use-context $ctx
}

# kubectl (change) namespace
export def kn [ns: string@"nu-complete kube ns"] {
    if not ($ns in (kubectl get namespace | from ssv -a | get NAME)) {
        if ([no yes] | input list $"namespace '($ns)' doesn't exist, create it?") in [yes] {
            kubectl create namespace $ns
        } else {
            return
        }
    }
    kubectl config set-context --current $"--namespace=($ns)"
}

export def 'kconf import' [name: string, path: string] {
    let k = (kube-config)
    mut d = $k.data
    let i = (cat $path | from yaml)
    let c = {
        context: {
            cluster: $name,
            namespace: default,
            user: $name
        }
        name: $name,
    }
    $d.clusters = (upsert_row $d.clusters name [] $name ($i.clusters.0 | upsert name $name))
    $d.users = (upsert_row $d.users name [] $name ($i.users.0 | upsert name $name))
    $d.contexts = (upsert_row $d.contexts name [] $name $c)
    $d | to yaml
}

export def "kconf export" [
    name: string@"nu-complete kube ctx"
] {
    let d = (kube-config).data
    let ctx = ($d | get contexts | where name == $name | get 0)
    let user = ($d | get users | where name == $ctx.context.user)
    let cluster = ($d | get clusters | where name == $ctx.context.cluster)
    {
        apiVersion: 'v1',
        current-context: $ctx.name,
        kind: Config,
        clusters: $cluster,
        preferences: {},
        contexts: [$ctx],
        users: $user,
    } | to yaml
}

export def --env kcconf [name: string@"nu-complete kube ctx"] {
    let dist = $"($env.HOME)/.kube/config.d"
    mkdir $dist
    kconf export $name | save -fr $"($dist)/($name)"
    $env.KUBECONFIG = $"($dist)/($name)"
}

def _kg_cmd [
    kind: string
    name?: string
    --namespace (-n): string
    --selector (-l): string
    --output (-o): string
    --all (-A): bool = false
    --as-str: bool = false
] {
    let namespace = if ($all) {
        [-A]
    } else {
        spr [-n $namespace]
    }
    let name = spr [$name]
    let selector = spr [-l $"\'($selector)\'"]

    if ($as_str) {
        let args = ([$namespace $kind $name $selector]
            | each {|it|
                if not ($it | is-empty) {
                    $it | str join (char space)
                }
            }
            | str join (char space)
        )
        return $"kubectl get ($args)"
    }

    let output = spr [-o $output]

    (kubectl get $namespace $kind $name $selector $output)
}

def _kg [
    kind: string
    name?: string
    --namespace (-n): string
    --selector (-l): string
    --verbose (-v): bool = false
    --wide (-W): bool = false
    --watch (-w): bool = false
    --jsonpath (-p): string
    --json (-j): bool = false
    --yaml (-y): bool = false
    --neat (-N): bool = false
    --all (-A): bool = false
] {
    let output = if ($verbose) {
        "json"
    } else if ($wide) {
        "wide"
    } else if not ($jsonpath | is-empty) {
        $"jsonpath={($jsonpath)}"
    } else if ($json) {
        "json"
    } else if ($yaml) {
        "yaml"
    } else {
        ""
    }

    let items = (_kg_cmd $kind $name -n $namespace -l $selector -o $output
        -A $all --as-str $watch
    )

    if ($wide) {
        return ($items | from ssv -a | normalize-column-names)
    }

    if ($verbose) {
        let items = $items | from json
        let items = if ($name | is-empty) {
            $items | get items
        } else {
            [$items]
        }

        return ($items
            | each {|it|
                {
                    name: $it.metadata.name
                    kind: $it.kind
                    ns: $it.metadata.namespace
                    created: ($it.metadata.creationTimestamp | into datetime)
                    metadata: $it.metadata
                    status: $it.status
                    spec: $it.spec
                }
            }
            | normalize-column-names
        )
    }

    if not ($jsonpath | is-empty) {
        return ($items | from json)
    }

    if ($neat and ($json or $yaml)) {
        return ($items | kubectl neat)
    } else if ($json or $yaml or $watch) {
        return $items
    }

    $items | from ssv -a
}

# kubernetes get
export def kg [
    kind: string@"nu-complete kube kind"
    name?: string@"nu-complete kube res"
    --namespace (-n): string@"nu-complete kube ns"
    --selector (-l): string
    --verbose (-v)
    --wide (-W)
    --watch (-w)
    --jsonpath (-p): string@"nu-complete kube jsonpath"
    --json (-j)
    --yaml (-y)
    --neat (-N) # only with `--yaml` or `--json`
    --all (-A)
] {
    (_kg $kind $name -n $namespace -l $selector -v $verbose -W $wide -w $watch
        -p $jsonpath -j $json -y $yaml -N $neat -A $all)
}

# kubectl describe
export def kd [
    kind: string@"nu-complete kube kind"
    name: string@"nu-complete kube res"
    --namespace (-n): string@"nu-complete kube ns"
] {
    kubectl describe (spr [-n $namespace]) $kind $name
}

# kubectl create
export def kc [
    kind: string@"nu-complete kube kind"
    name: string
    --namespace (-n): string@"nu-complete kube ns"
] {
    kubectl create (spr [-n $namespace]) $kind $name
}

# kubectl get -o yaml
export def ky [
    kind: string@"nu-complete kube kind"
    name?: string@"nu-complete kube res"
    --selector (-l): string
    --namespace (-n): string@"nu-complete kube ns"
    --neat (-N)
    --all (-A)
] {
    let items = (_kg $kind $name -n $namespace -l $selector -A $all -y true)

    if ($neat) {
        return ($items | kubectl neat)
    }

    $items
}

# kubectl get -o json
export def kj [
    kind: string@"nu-complete kube kind"
    name?: string@"nu-complete kube res"
    --selector (-l): string
    --namespace (-n): string@"nu-complete kube ns"
    --neat (-N)
    --all (-A)
] {
    let items = (_kg $kind $name -n $namespace -l $selector -A $all -j true)

    if ($neat) {
        return ($items | kubectl neat)
    }

    $items
}

# kubectl edit
export def ke [
    kind: string@"nu-complete kube kind"
    name?: string@"nu-complete kube res"
    --namespace (-n): string@"nu-complete kube ns"
    --selector(-l): string
] {
    let name = if ($selector | is-empty) {
        $name
    } else {
        let res = (_kg_cmd $kind -n $namespace -l $selector
            | from ssv -a
            | get NAME
        )


        match ($res | length) {
            0 => return
            1 => $res.0
            _ => ($res | input list $"select ($kind): ")
        }
    }

    let namespace = (spr [-n $namespace])
    kubectl edit $namespace $kind $name
}

def _kdel [
    kind: string
    name?: string
    --namespace (-n): string
    --selector(-l): string
    --cascade: string
    --dry-run: string
    --force (-f): bool = false
    --no-wait (-N): bool = false
] {
    let selector = spr [-l $selector]
    let namespace = spr [-n $namespace]
    let name = spr [$name]
    let force = sprb $force [--grace-period=0 --force]
    let no_wait = sprb $no_wait ['--wait=false']
    let dry_run = $"--dry-run=($dry_run)"
    let cascade = $"--cascade=($cascade)"

    (kubectl delete $namespace $kind $name $selector $dry_run $cascade
        $no_wait $force
    )
}

# kubectl delete
export def kdel [
    kind: string@"nu-complete kube kind"
    name?: string@"nu-complete kube res"
    --namespace (-n): string@"nu-complete kube ns"
    --selector(-l): string
    --cascade: string@"nu-complete cascade" = "background"
    --dry-run: string@"nu-complete dry-run" = "none"
    --force (-f)
    --no-wait (-N)
] {
    (_kdel $kind $name -n $namespace -l $selector --cascade $cascade
        --dry-run $dry_run --no-wait $no_wait -f $force
    )
}

# kubectl get nodes
export def kgno [
    --version (-v): string
] {
    let items = (_kg nodes -W true
        | rename name status roles age version internal-ip external-ip os kernel runtime
    )

    if ($version | is-empty) {
        return $items
    }

    $items | where version =~ $version
}

export def kgpo_with_node_version [
    version: string
    --namespace (-n): string@"nu-complete kube ns"
    --all (-A)
] {
    let ns = if $all { [--all-namespaces] } else { (spr [-n $namespace]) }
    let nodes = kgno -v $version | get NAME

    (kubectl get pods $ns -ojson
        | from json
        | get items
        | filter {|pod| $pod.spec.nodeName in $nodes}
        | each {|pod|
            {
                name: $pod.metadata.name,
                namespace: $pod.metadata.namespace,
                node: $pod.spec.nodeName,
            }
        }
    )
}

export def k_drain_nodes_version [
    version: string
    --timeout (-T): duration = 5min
    --sleep-duration (-s): duration = 30sec
] {
    let timeout_secs = $"($timeout / 1sec)s"
    (kgno_with_version $version
        | each {|it|
            kubectl drain $it.NAME --ignore-daemonsets --delete-emptydir-data $"--timeout=($timeout_secs)"
            sleep $sleep_duration
        }
        | ignore
    )
}

# kubectl attach (exec -it)
export def kex [
    pod: string@"nu-complete kube pods"
    --namespace (-n): string@"nu-complete kube ns"
    --container(-c): string@"nu-complete kube ctns"
    --selector(-l): string
    ...args
] {
    let n = (spr [-n $namespace])
    let pod = if ($selector | is-empty) { $pod } else {
        let pods = (
            kubectl get pods $n -o wide -l $selector
            | from ssv -a
            | where STATUS == Running
            | select NAME IP NODE
            | rename name ip node
        )
        if ($pods | length) == 1 {
            ($pods.0).name
        } else if ($pods | length) == 0 {
            return
        } else {
            ($pods | input list 'select pod ').name
        }
    }
    let c = if ($container | is-empty) {
        if ($selector | is-empty)  { [] } else {
            let cs = (kgp -n $n $pod -p '.spec.containers[*].name' | split row ' ')
            let ctn = if ($cs | length) == 1 {
                $cs.0
            } else {
                $cs | input list 'select container '
            }
            [-c $ctn]
        }
    } else {
        [-c $container]
    }
    kubectl exec $n -it $pod $c -- (if ($args|is-empty) { 'bash' } else { $args })
}

# kubectl logs
export def kl [
    pod: string@"nu-complete kube pods"
    --namespace(-n): string@"nu-complete kube ns"
    --container(-c): string@"nu-complete kube ctns"
    --follow(-f)
    --previous(-p)
] {
    let n = (spr [-n $namespace])
    let c = (spr [-c $container])
    let f = (sprb $follow [-f])
    let p = (sprb $previous [-p])
    kubectl logs $n $f $p $pod $c
}

# kubectl port-forward
export def kpf [
    res: string@"nu-complete port forward type"
    target: string@"nu-complete kube res"
    port: string@"nu-complete kube port"
    --local (-l): string
    --namespace (-n): string@"nu-complete kube ns"
] {
    let n = (spr [-n $namespace])
    let port = if ($local | is-empty) { $port } else { $"($local):($port)" }
    kubectl port-forward $n $"($res)/($target)" $port
}

# kubectl cp
export def kcp [
    lhs: string@"nu-complete kube cp"
    rhs: string@"nu-complete kube cp"
    --container (-c): string@"nu-complete kube ctns"
    --namespace (-n): string@"nu-complete kube ns"
] {
    kubectl cp (spr [-n $namespace]) $lhs (spr [-c $container]) $rhs
}

# kubectl rollout history
export def krhd [
    --namespace (-n): string@"nu-complete kube ns"
    --revision (-v): int
    dpl: string@"nu-complete kube res via name"
] {
    let n = (spr [-n $namespace])
    let v = if ($revision|is-empty) { [] } else { [ $"--revision=($revision)" ] }
    kubectl $n rollout history $"deployment/($dpl)" $v
}

# kubectl rollout undo
export def krud [
    --namespace (-n): string@"nu-complete kube ns"
    --revision (-v): int
    dpl: string@"nu-complete kube res via name"
] {
    let n = (spr [-n $namespace])
    let v = if ($revision|is-empty) { [] } else { [ $"--to-revision=($revision)" ] }
    kubectl $n rollout undo $"deployment/($dpl)" $v
}

export alias ksdep = kubectl scale deployment
export alias krsdep = kubectl rollout status deployment
export alias krrdep = kubectl rollout restart deployment
export alias kssts = kubectl scale statefulset
export alias krrsts = kubectl rollout restart statefulset

# kubectl top pod
export def ktp [
    --namespace (-n): string@"nu-complete kube ns"
    --all(-A)
] {
    if $all {
        kubectl top pod -A | from ssv -a | rename namespace name cpu mem
        | each {|x|
            {
                namespace: $x.namespace
                name: $x.name
                cpu: ($x.cpu| str substring ..-1 | into float)
                mem: ($x.mem | str substring ..-2 | into float)
            }
        }
    } else {
        let n = (spr [-n $namespace])
        kubectl top pod $n | from ssv -a | rename name cpu mem
        | each {|x|
            {
                name: $x.name
                cpu: ($x.cpu| str substring ..-1 | into float)
                mem: ($x.mem | str substring ..-2 | into float)
            }
        }
    }
}

# kubectl top node
export def ktno [] {
    kubectl top node | from ssv -a | rename name cpu pcpu mem pmem
    | each {|x| {
        name: $x.name
        cpu: ($x.cpu| str substring ..-1 | into float)
        cpu%: (($x.pcpu| str substring ..-1 | into float) / 100)
        mem: ($x.mem | str substring ..-2 | into float)
        mem%: (($x.pmem | str substring ..-1 | into float) / 100)
    } }
}

###
export def "kclean evicted" [] {
    kubectl get pods -A
    | from ssv -a
    | where STATUS == Evicted
    | each { |x| kdel pod -n $x.NAMESPACE $x.NAME }
}

### FIXME:
export def "kclean stucked ns" [ns: string] {
    kubectl get namespace $ns -o json \
    | tr -d "\n"
    | sed 's/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/' \
    | kubectl replace --raw /api/v1/namespaces/$1/finalize -f -
}

export alias "kclean finalizer" = kubectl patch -p '{\"metadata\":{\"finalizers\":null}}'

export alias "kadm renew" = kubeadm alpha certs renew all

### cert-manager
export def kgcert [] {
    kubectl get certificates -o wide | from ssv | rename certificates
    kubectl get certificaterequests -o wide | from ssv | rename certificaterequests
    kubectl get order.acme -o wide | from ssv | rename order.acme
    kubectl get challenges.acme -o wide | from ssv | rename challenges.acme
}

# kubectl update externalsecret
export def kupdes [
    r?: string@"nu-complete kube res via name2"
    --namespace (-n): string@"nu-complete kube ns"
] {
    let ns = spr [-n $namespace]
    (kubectl annotate externalsecret $ns $r
        $"force-sync=(date now | format date "%s")" --overwrite
    )
}

export def kwatch [
    command: string
] {
    hwatch -c -t -s "nu -c" $"use ($env.CURRENT_FILE) *; ($command)"
}

# watch logs with stern
export def slog [
    pod?: string@"nu-complete kube pods"
    --namespace (-n): string@"nu-complete kube ns"
    --exclude-container(-e): string@"nu-complete kube ctns"
    --container(-c): string@"nu-complete kube ctns"
    --include (-i): string
    --exclude (-E): string
    --exclude-pod: string
] {
    let ns = spr [-n $namespace]
    let cont = spr [-c $container]
    let exc_cont = spr [-e $exclude_container]
    let inc = spr [-i $include]
    let exc = spr [-E $exclude]
    let exc_pod = spr [--exclude-pod $exclude_pod]
    stern $pod $ns $cont $exc_cont $inc $exc $exc_pod
}
