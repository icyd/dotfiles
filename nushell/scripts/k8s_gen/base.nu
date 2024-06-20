use std log
use modules/argx/argx.nu
use utils.nu

def ensure-cache-by-lines [cache path action] {
    let ls = do -i { open $path | lines | length }
    if ($ls | is-empty) { return false }
    let lc = do -i { open $cache | get lines}
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
    let cols = $i | columns
    mut t = $i
    for c in $cols {
        $t = ($t | rename -c {$c: ($c | str downcase | str replace ' ' '_')})
    }
    $t
}

def --wrapped with-flag [...flag] {
    if ($in | is-empty) { [] } else { [...$flag $in] }
}

def --wrapped as-str-flag [...flag] {
    if ($in | is-empty) { [] } else { [ $"($flag | get 0)=($in)" ] }
}

def record-to-set-json [value] {
    $value | transpose k v
    | each {|x| $"($x.k)=($x.v | to json -r)"}
    | str join ','
}

def upsert_row [table col mask id value] {
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

def "nu-complete helm list" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    kgh -n $ctx.namespace? | each {|x| {value: $x.name  description: $x.updated} }
}

def "nu-complete helm charts" [context: string, offset: int] {
    let ctx = $context | argx parse
    let path = $ctx | get _pos.chart
    let path = if ($path | is-empty) { '.' } else { $path }
    let paths = do -i { ls $"($path)*" | each {|x| if $x.type == dir { $"($x.name)/"} else { $x.name }} }
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
    let ctx = $context | argx parse
    let kind = $ctx | get _args.1
    let ns = if ($ctx.namespace? | is-empty) { [] } else { [-n $ctx.namespace] }
    kubectl get ...$ns $kind | from ssv -a | get NAME
}

export def "nu-complete kube jsonpath" [context: string] {
    let ctx = $context | argx parse
    let kind = $ctx | get _args.1
    let res = $ctx | get _args.2
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
            let m = kubectl get ...$ns $kind $res $"--output=jsonpath={($p)}" | from json
            let l = $row | last
            let c = do -i {$m | get $l}
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
    let data = ensure-cache-by-lines $cache $k.path { ||
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
    }

    $data.completion | each {|x|
        let ns = ($x.ns | fill -a l -w $data.max.ns -c ' ')
        let cl = ($x.cluster | fill -a l -w $data.max.cluster -c ' ')
        {value: $x.value, description: $"\t($ns) ($cl)"}
    }
}

export def "nu-complete kube pods" [context: string, offset: int] {
    let ctx = $context | argx parse
    let ns = $ctx.namespace? | with-flag -n
    kubectl get ...($ns | with-flag -n) pods | from ssv -a | get NAME
}

export def "nu-complete kube ctns" [context: string, offset: int] {
    let ctx = $context | argx parse
    let ns = $ctx.namespace? | with-flag -n
    let pod = $ctx | get _args.1
    kubectl get ...$ns pod $pod -o jsonpath={.spec.containers[*].name} | split row ' '
}

export def "nu-complete port forward type" [] {
    [pod svc]
}

export def "nu-complete kube port" [context: string, offset: int] {
    let ctx = $context | argx parse
    let kind = $ctx | get _args.1
    let ns = $ctx.namespace? | with-flag -n
    let res = $ctx | get _args.2
    if ($kind | str starts-with 's') {
        kubectl get ...$ns svc $res --output=jsonpath="{.spec.ports}"
        | from json
        | each {|x| {value: $x.port  description: $x.name} }
    } else {
        kubectl get ...$ns pods $res --output=jsonpath="{.spec.containers[].ports}"
        | from json
        | each {|x| {value: $x.containerPort description: $x.name?} }
    }
}

export def "nu-complete kube labels" [context: string, offset: int] {
    let ctx = ($context | parse cmd)
    let cmd = ($ctx | get _args.0 )
    let abbr = ($env.KUBERNETES_OPERATIONS_ABBR
        | filter {|op| $cmd =~ $"^k($op.abbr)"}
        | math max
    ).abbr
    let operation = ($env.KUBERNETES_OPERATIONS_ABBR | where abbr == $abbr).operation
    let ns = if ($ctx.namespace? | is-empty) { [] } else { [-n $ctx.namespace] }
    let kind = ($env.KUBERNETES_RESOURCE_ABBR
        | get ($cmd | str replace -r $'k($abbr)' '')
    )

    let labels = (kubectl get $kind $ns -ojson
        | from json
        | get items.metadata.labels
    )

    ($labels
        | columns
        | each {|col|
            $labels
            | get -i $col
            | uniq
            | default ""
            | compact -e
            | str replace -r "(.*)" $"($col)=${1}"
        }
        | flatten
    )
}

export def "nu-complete kube cp" [cmd: string, offset: int] {
    let ctx = $cmd | str substring ..$offset | argx parse
    let p = $ctx._args | get (($ctx._args | length) - 1)
    let ns = $ctx.namespace? | with-flag -n
    let c = $ctx.container? | with-flag -c
    let ctn = kubectl get pod ...$ns | from ssv -a | each {|x| {description: $x.READY value: $"($x.NAME):" }}
    let n = $p | split row ':'
    if $"($n | get 0):" in ($ctn | get value) {
        kubectl exec ...$ns ($n | get 0) ...$c -- sh -c $"ls -dp ($n | get 1)*"
        | lines
        | each {|x| $"($n | get 0):($x)"}
    } else {
        let files = do -i { ls -a $"($p)*"
            | each {|x| if $x.type == dir { $"($x.name)/"} else { $x.name }}
        }
        $files | append $ctn
    }
}

export def "nu-complete num9" [] { [0 1 2 3] }

def "kube res via name n" [context: string, offset: int, n: int] {
    let ctx = $context | argx parse
    let kind = $env.KUBERNETES_RESOURCE_ABBR | get ($ctx | get _args.0 | str substring ((-1 * $n)..))
    let ns = $ctx.namespace? | with-flag -n
    kubectl get ...$ns $kind | from ssv -a | get NAME
}

export def "nu-complete kube res via name" [context: string, offset: int] {
    kube res via name n $context $offset 1
}

export def "nu-complete kube res via name0" [context: string, offset: int] {
    kube res via name n $context $offset 0
}

export def "nu-complete kube res via name1" [context: string, offset: int] {
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

export def "nu-complete top" [] {
    [node pod]
}

export def "nu-complete kube nodes" [] {
    kubectl get nodes | from ssv -a | get NAME
}

export def `kcache flush` [] {
    rm -rf ~/.cache/nu-complete/k8s/
    nu-complete kube ctx
    rm -rf ~/.cache/nu-complete/k8s-api-resources/
}

# kubectl apply -f
export def kaf [
    filename?: path
    --namespace (-n): string
    --dry-run: string
] {
    let stdin = $in
    let ns = $namespace | with-flag -n
    let dry_run = $dry_run | as-str-flag --dry-run
    let file = if ($stdin | is-empty) and ($filename | is-empty) {
        error make {
            msg: "Missing required arguments, either filename or stdin is required",
            label: {
                text: "Missing value",
                span: (metadata $filename).span,
            }
        }
    } else if ($stdin | is-empty) {
            $filename
    } else {
            "-"
    }

    $stdin | kubectl apply -f $file ...$ns ...$dry_run
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
        let ns = if $all { [--all] } else { $namespace | with-flag -n }
        helm list ...$ns --output json
        | from json
        | update updated {|x|
            $x.updated
            | str substring ..-4
            | into datetime -f '%Y-%m-%d %H:%M:%S.%f %z'
        }
    } else {
        if $manifest {
            helm get manifest $name ...($namespace | with-flag -n)
        } else if $values {
            helm get values $name ...($namespace | with-flag -n)
        } else {
            helm get notes $name ...($namespace | with-flag -n)
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
        helm list ...($namespace | with-flag -n) --output json
        | from json | get name
    )
    let act = if $update { [upgrade] } else { [install] }
    let values = if ($values | is-empty) { [] } else { [--set-json (record-to-set-json $values)] }
    helm ...$act $name $chart -f $valuefile ...$values ...($namespace | with-flag -n)
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
        helm diff $name $chart -f $valuefile ...($namespace | with-flag -n)
    } else {
        let update = $name in (
            helm list ...($namespace | with-flag -n) --output json
            | from json | get name
        )
        if not $update {
            echo "new installation"
            return
        }

        let values = if ($values | is-empty) { [] } else { [--set-json (record-to-set-json $values)] }
        let target = $'/tmp/($chart | path basename).($name).out.yaml'
        helm template --debug $name $chart -f $valuefile ...$values ...($namespace | with-flag -n) | save -f $target
        kubectl diff -f $target
    }
}

# helm delete
export def kdelh [
    name: string@"nu-complete helm list"
    --namespace (-n): string@"nu-complete kube ns"
] {
    helm uninstall $name ...($namespace | with-flag -n)
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
    helm template --debug $app $chart -f $valuefile ...$values ...($namespace | with-flag -n)
    | save -f $target
}

### ctx
def _kfzf [
    command: string
    query_text?: string
    --current (-c)
] {
    if ($current) {
        kubectl $command --current
    } else if ($query_text | is-empty) {
        kubectl $command (kubectl $command | fzf --preview-window=:hidden)
    } else {
        kubectl $command (kubectl $command | fzf --preview-window=:hidden $"--query=($query_text)")
    }
}

# kubectl change context with fzf
export def kcx [
    query_text?: string
    --current (-c)
] {
    let q = if (not ($in | is-empty)) {
        $in
    } else {
        $query_text
    }

    _kfzf ctx $q --current=$current
}

# kubectl change namespace with fzf
export def kns [
    query_text?: string
    --current (-c)
] {
    let q = if (not ($in | is-empty)) {
        $in
    } else {
        $query_text
    }

    _kfzf ns $q --current=$current
}

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
    let k = kube-config
    mut d = $k.data
    let i = cat $path | from yaml
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
    let ctx = $d | get contexts | where name == $name | get 0
    let user = $d | get users | where name == $ctx.context.user
    let cluster = $d | get clusters | where name == $ctx.context.cluster
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
    --show-labels (-S)
    --all (-A)
    --as-str
] {
    let namespace = if ($all) {
        [-A]
    } else {
        $namespace | with-flag -n
    }
    let selector = $selector | with-flag -l
    let show_labels = $show_labels | as-str-flag --show-labels
    let name = $name | with-flag

    if ($as_str) {
        return $"kubectl get ($kind) ([...$name ...$namespace ...$selector ...$show_labels] | str join (char space))"
    }

    kubectl get $kind ...$name ...$namespace ...$selector ...($output | with-flag -o) ...$show_labels
}

def _kg [
    kind: string
    name?: string
    --namespace (-n): string
    --selector (-l): string
    --verbose (-v)
    --wide (-W)
    --watch (-w)
    --jsonpath (-p): string
    --json (-j)
    --yaml (-y)
    --neat (-N)
    --show-labels
    --all (-A)
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

    let items = (_kg_cmd $kind $name
        --namespace $namespace
        --selector $selector
        --output $output
        --show-labels=$show_labels
        --all=$all
        --as-str=$watch
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

    let items = $items | from ssv -a | normalize-column-names
    let items = if ($watch or ($namespace | is-empty)) {
        $items
    } else {
        $items | insert "ns" $namespace
    }

    $items
}

# kubectl create
export def kc [
    kind: string@"nu-complete kube kind"
    name: string
    --namespace (-n): string@"nu-complete kube ns"
] {
    kubectl create $kind $name ...($namespace | with-flag -n)
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
    let items = (_kg $kind $name
        --namespace $namespace
        --selector $selector
        --all=$all
        --yaml
    )

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
    let items = (_kg $kind $name
        --namespace $namespace
        --selector $selector
        --all=$all
        --json
    )

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
        let res = (_kg_cmd $kind
            --namespace $namespace
            --selector $selector
            | from ssv -a
            | get NAME
        )

        match ($res | length) {
            0 => return
            1 => $res.0
            _ => ($res | input list $"select ($kind): ")
        }
    }

    kubectl edit $kind $name ...($namespace | with-flag -n)
}

def _kd [
    kind: string
    name: string
    --namespace (-n): string
] {
    kubectl describe $kind $name ...($namespace | with-flag -n)
}

def _kdel [
    kind: string
    name?: string
    --namespace (-n): string
    --selector(-l): string
    --cascade: string = "foreground"
    --dry-run: string
    --force (-f)
    --no-wait (-N)
] {
    let selector = $selector | with-flag -l
    let namespace = $namespace | with-flag -n
    let name = $name | with-flag
    let force = if ($force) { [ '--grace-period=0' '--force' ] } else { [] }
    let no_wait = if ($no_wait) { [ '--wait=false' ] } else { [] }
    let dry_run = $dry_run | as-str-flag --dry-run
    let cascade = $"--cascade=($cascade)"

    (kubectl delete $kind ...$name ...$namespace ...$selector ...$dry_run $cascade
        ...$no_wait ...$force
    )
}

# kubectl get all pods with node version
export def kgpo_with_node_version [
    version: string
    --namespace (-n): string@"nu-complete kube ns"
    --all (-A)
] {
    let ns = if $all { [--all-namespaces] } else { ...($namespace | with-flag -n) }
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

# kubectl drain nodes with given version
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

# Get all pods from a deployment
export def kgpo_from_deploy [
    deployment: string
    --namespace (-n): string
] {
    let ns = $namespace | with-flag -n
    let labels = (kubectl get deploy ...$ns $deployment -oyaml |
        from yaml |
        get spec.selector.matchLabels |
        transpose key value |
        utils table_2_string $in
    )
    kubectl get pods ...$ns -l $labels -ojson | from json | get items | normalize-column-names
}

# Get random pod from given labels
export def kgpo_from_labels [
    labels: string
    --namespace (-n): string
] {

    let ns = $namespace | with-flag -n
    let pods = (kubectl get pod ...$ns -l $labels | from ssv | normalize-column-names)
    utils random_row $pods | get name
}

# Get current / active ReplicaSet of a given Deployment
export def kg_active_rs [
    deployment: string
    --namespace (-n): string
] {
    let ns = $namespace | with-flag -n
    let deploy_manifest = kubectl get deployment $deployment ...$ns -ojson | from json
    let deploy_name = $deploy_manifest | get metadata.labels."app.kubernetes.io/name"
    let deploy_instance = $deploy_manifest | get metadata.labels."app.kubernetes.io/instance"
    let deploy_revision = $deploy_manifest | get metadata.annotations."deployment.kubernetes.io/revision"
    (kubectl get rs ...$ns -ojson
        -l $"app.kubernetes.io/name=($deploy_name),app.kubernetes.io/instance=($deploy_instance)"
        | from json
        | get items
        | where metadata.annotations."deployment.kubernetes.io/revision" == $deploy_revision
        | get 0.metadata.name
    )
}

# Label all the pods of a given deployment
export def k_label_pods_from_deploy [
    deployment: string
    labels: string
    --namespace (-n): string
] {
    if $labels !~ "(?:\\w+=\\w+),?+" {
        error make {
            msg: "labels parameter don't follow key=value format (comma separated)",
            label: {
                text: "wrong format",
                span: (metadata $labels).span
            }
        }
    }
    let ns = $namespace | with-flag -n
    let labels = $labels | split row ","

    kgpo_from_deploy $deployment -n $namespace
        | from ssv
        | par-each {|it|
            if ($it | is-empty) {
                return
            }

            kubectl label pod ...$ns $it.name $labels
        }
}

# Relabel deployments, active replica set and their pods
export def k_relabel_deploy [
    deployment: string
    labels: string
    --namespace (-n): string
] {
    if $labels !~ "(?:\\w+=\\w+),?+" {
        error make {
            msg: "labels parameter don't follow key=value format (comma separated)"
            label: {
                text: "wrong format",
                span: (metadata $labels).span
            }
        }
    }

    let ns = $namespace | with-flag -n
    let new_labels = ($labels
        | split row ","
        | split column "=" key value
        | reduce -f {} {|it, acc| $acc | upsert $it.key $it.value}
    )
    let deploy_manifest = kubectl get deployment $deployment ...$ns -oyaml | kubectl neat | from yaml
    let active_rs = kg_active_rs $deployment -n $namespace
    let rs_manifest = kubectl get rs $active_rs ...$ns -oyaml | kubectl neat | from yaml
    let manifests = [$deploy_manifest $rs_manifest]

    let manifests = $manifests | each {|manifest|
        $manifest
            | upsert metadata.labels {|m| $m.metadata.labels | merge $new_labels}
            | upsert spec.selector.matchLabels {|m| $m.spec.selector.matchLabels | merge $new_labels}
            | upsert spec.template.metadata.labels {|m| $m.spec.template.metadata.labels | merge $new_labels}
    }

    k_label_pods_from_deploy $deployment -n $namespace $labels
    kubectl delete deploy $deployment ...$ns --cascade=orphan
    kubectl delete rs $active_rs ...$ns --cascade=orphan
    $manifests | each {|m| $m | kubectl apply ...$ns -f-}
}

# Connect to node where pod is running with wireshark
export def kshark [
    pod?: string
    --user (-u): string = "ec2-user"
    --key (-k): path
    --labels (-l): string
    --namespace (-n): string
] {

  if ($key | is-empty) {
      error make {
        msg: "Missing ssh key"
        label: {
            text: "SSH key required",
            span: (metadata $key).span
        }
      }
  }

  let ns = $namespace | with-flag -n
  let selected_pod = if ($labels | is-empty) {
    $pod
  } else {
    kubectl get pod ...$ns -l $labels -ojson | from json | get items.0.metadata.name
  }

  log info $"Pod: ($selected_pod).($ns) - Node SSH user: ($user)"
  let link = (kubectl exec -t ...$ns $selected_pod -- sh -c "cat /sys/class/net/eth0/iflink 2>/dev/null" | tr -dc '[:print:]')

  if ($link | is-empty) {
    error make {msg: "Error extracting link"}
  }
  log debug $"Link: ($link)"

  let ip = (kubectl get pod ...$ns $selected_pod -ojsonpath='{.status.hostIP}')
  if ($ip | is-empty) {
    error make {msg: "Error getting host ip from pod"}
  }
  log debug $"Node IP: ($ip)"

  let eni = (ssh -i $key $"($user)@($ip)" "/usr/sbin/ip link"
      | from ssv -n -m 1
      | where column1 =~ $"^($link)"
      | get column2.0
      | str replace --regex "(.*)@.*" "$1"
  )
  if ($eni | is-empty) {
    error make {msg: "Error getting pod's ENI."}
  }
  log debug $"ENI: ($eni)"

  log info "Installing tcpdump if not installed..."
  ssh -i $key $"($user)@($ip)" "if ! rpm -qa | grep -qw tcpdump; then sudo yum install tcpdump -y; fi"

  log info "Executing command..."
  if ((^uname -o) == "Darwin") {
      ssh -i $key $"($user)@($ip)" $"sudo tcpdump -i ($eni) -U -s0 -w - 'not port 22'" | /Applications/Wireshark.app/Contents/MacOS/Wireshark -k -i -
  } else {
      ssh -i $key $"($user)@($ip)" $"sudo tcpdump -i ($eni) -U -s0 -w - 'not port 22'" | wireshark -k -i -
  }
}

# Connect to node where deployment's pod is running with wireshark
export def ksharkdep [
    deployment: string
    --namespace (-n): string
    --user (-u): string = "ec2-user"
    --key (-k): path
] {
  let pods = kgpo_from_deploy $deployment -n $namespace
  let selected_pod = utils random_row $pods | get name
  kshark $selected_pod -n $namespace -u $user -k $key
}

# kubectl attach (exec -it)
export def --wrapped kex [
    pod: string@"nu-complete kube pods"
    --namespace (-n): string@"nu-complete kube ns"
    --container(-c): string@"nu-complete kube ctns"
    --selector(-l): string
    ...args
] {
    let n = $namespace | with-flag -n
    let pod = if ($selector | is-empty) { $pod } else {
        let pods = (
            kubectl get pods ...$n -o wide -l $selector
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
            let cs = (kubectl get pod ...$n $pod -ojsonpath='{.spec.containers[*].name}' | split row ' ')
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
    kubectl exec ...$n -it $pod ...$c -- ...(if ($args|is-empty) { ['bash'] } else { $args })
}

# kubectl logs
export def klo [
    pod: string@"nu-complete kube pods"
    --namespace(-n): string@"nu-complete kube ns"
    --container(-c): string@"nu-complete kube ctns"
    --follow(-f)
    --previous(-p)
] {
    let n = $namespace | with-flag -n
    let c = $container | with-flag -c
    let f = if ($follow) {[-f]} else {[]}
    let p = if ($previous) {[-p]} else {[]}
    kubectl logs ...$n ...$f ...$p $pod ...$c
}

# kubectl port-forward
export def kpf [
    kind: string@"nu-complete port forward type"
    target: string@"nu-complete kube res"
    port: string@"nu-complete kube port"
    --local (-l): string
    --namespace (-n): string@"nu-complete kube ns"
] {
    let ns = $namespace | with-flag -n
    let port = if ($local | is-empty) { $port } else { $"($local):($port)" }
    kubectl port-forward ...$ns $"($kind)/($target)" $port
}

# kubectl cp
export def kcp [
    lhs: string@"nu-complete kube cp"
    rhs: string@"nu-complete kube cp"
    --container (-c): string@"nu-complete kube ctns"
    --namespace (-n): string@"nu-complete kube ns"
] {
    kubectl cp ...($namespace | with-flag -n) $lhs (spr [-c $container]) $rhs
}

# kubectl rollout history
export def krhd [
    --namespace (-n): string@"nu-complete kube ns"
    --revision (-v): int
    dpl: string@"nu-complete kube res via name"
] {
    let ns = $namespace | with-flag -n
    let v = if ($revision|is-empty) { [] } else { [ $"--revision=($revision)" ] }
    kubectl ...$ns rollout history $"deployment/($dpl)" $v
}

# kubectl rollout undo
export def krud [
    --namespace (-n): string@"nu-complete kube ns"
    --revision (-v): int
    deploy: string@"nu-complete kube res via name"
] {
    let ns = $namespace | with-flag -n
    let ver = if ($revision|is-empty) { [] } else { [ $"--to-revision=($revision)" ] }
    kubectl ...$ns rollout undo $"deployment/($deploy)" $ver
}

export alias ksdep = kubectl scale deployment
export alias krsdep = kubectl rollout status deployment
export alias krrdep = kubectl rollout restart deployment
export alias kssts = kubectl scale statefulset
export alias krrsts = kubectl rollout restart statefulset

# kubectl top pod
def ktp [
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
        let ns = $namespace | with-flag -n
        kubectl top pod ...$ns | from ssv -a | rename name cpu mem
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

# kubectl top
export def ktop [
    kind: string@"nu-complete top"
    --namespace (-n): string@"nu-complete kube ns"
    --all(-A)
] {
    if ($kind == "pod") {
        ktp --namespace $namespace --all=$all
    } else if ($kind == "node") {
        ktno
    }
}

###
export def "kclean evicted" [] {
    kubectl get pods -A
    | from ssv -a
    | where STATUS == Evicted
    | each { |x| kdel pod -n $x.NAMESPACE $x.NAME }
}

### FIXME:
export def "kclean stuck ns" [ns: string] {
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
    kind?: string@"nu-complete kube res via name2"
    --namespace (-n): string@"nu-complete kube ns"
] {
    let ns = $namespace | with-flag -n
    (kubectl annotate externalsecret ...$ns $kind
        $"force-sync=(date now | format date "%s")" --overwrite
    )
}

# kubectl zombify container
export def k_zombify_container [
    pod: string
    --namespace (-n): string
    --container-name (-c): string
] {
    let ns = $namespace | with-flag -n

    if ($container_name | is-empty) {
        error make {
            msg: "--container-name (-c) required",
            label: {
                text: "missing value",
                span: (metadata $container_name).span,
            }
        }
    }

    let pod_manifest = kubectl get pod $pod ...$ns -oyaml | kubectl neat
    ($pod_manifest
        | reject metadata.labels metadata.annotations
        | upsert metadata.name {|pod| $"($pod.metadata.name)-zombie"}
        | upsert spec.containers {|pod|
            $pod.spec.containers | each {|c|
                $c | reject -i livenessProbe readinessProbe startupProbe
                | if ($c.name == $container_name) {
                    $in | upsert command [sleep 1d]
                }
            }
        }
        | kubectl apply ...$ns -f-
    )
}

export def --wrapped kwatch [
    command: string
    --use (-u): string = "use kubernetes.nu *" # command to use / include library
    --additional-libraries (-l): string # comma separated list of libraries to include
    ...$args
] {
    let lib_dirs = (if ($additional_libraries | is-empty) {
        $env.NU_LIB_DIRS
    } else {
        ($env.NU_LIB_DIRS
            | append ($additional_libraries
                | split row ","
                | each {|it| $it | path expand}
              )
        )
    }) | str join (char record_sep)
    hwatch ...$args -c -t -s $"nu -n -I ($lib_dirs) -c" $"($use); ($command)"
}

# kubectl api-resources
export def k_api_res [] {
    kubectl api-resources | from ssv -a | normalize-column-names
}

# kubectl api-versions
export def k_api_vers [] {
    kubectl api-versions | from ssv -n | rename version
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
    let ns = $namespace | with-flag -n
    let pod = if ($pod | is-empty) {[]} else {[$pod]}
    let cont = $container | with-flag -c
    let exc_cont = $exclude_container | with-flag -e
    let inc = $include | with-flag -i
    let exc = $exclude | with-flag -E
    let exc_pod = $exclude_pod | with-flag --exclude-pod
    stern ...$pod ...$ns ...$cont ...$exc_cont ...$inc ...$exc ...$exc_pod
}

# Get all pods running in a given node
export def kgpo_on_node [
    node: string@"nu-complete kube nodes"
] {
    (kubectl get pod -A -owide
        | from ssv -a
        | normalize-column-names
        | where node == $node
        | select namespace name
    )
}
