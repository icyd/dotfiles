export-env {
    $env.AWS_PROFILE = "saml"
}

# Pipe yaml outputs to cat and parse it from pipeline
export def yat [] {
    $in | bat -lyaml
}

# Pipe json outputs to cat and parse it from pipeline
export def jat [] {
    $in | bat -ljson
}

# Pipe xml outputs to cat and parse it from pipeline
export def xat [] {
    $in | bat -lxml
}

export def exthc [
    app: string
    endpoint: string
] {
    if $app == "-" {
        return (curl -s $"https://($endpoint).service.easports.com/healthcheck")
    }

    let suffix = (do {
        if $app == "sg" {
            "a2007200627e6ef9bccd6ac4244a63c368bf9360"
        } else if $app == "alerts" {
            "4080fee845c1b011746013c89840a9890c69b78c"
        } else if $app == "alerts-mobile" {
            "cefdc28fa7c6f70b6bc0da46611a71dcd5ee82f4"
        } else if $app == "ch" {
            if $endpoint =~ "madden1[7-9]" {
                "e312ce3f804808ba2588610aa754f24b1454f0c1"
            } else if $endpoint == "madden20" {
                "ohjai8Iequ3oyies0chie9Xauloh2ru4po0Aighu"
            } else if $endpoint =~ "madden2[12]" {
                "c82e61d1a412a2edde1c5ad5a8664f6ca27e818f"
            } else if $endpoint == "madden23" {
                "5a457c7ce1a944f3cad593b742be61379c08880d"
            } else if $endpoint == "madden24" {
                "ZGrXriU1nmDPjHSaxJIDQsTGCZNN0zJtJPQLAUze"
            } else {
                "0a96aee93ff3a1b4d3d040da63666dcfa714f24b"
            }
        } else if $app == "xmshd-curated" {
            "333339999sdjlkslakjsfp9283ulkdjfjnaksdjf"
        } else {
            "1626e6adf06380c21e2be6d8dc70c6aef3898df7"
        }
    })
    (curl -s $"https://($endpoint).service.easports.com/health/($suffix)"
        -u health:servicecheck | from json | get check_list | reject id)
}

def k_namespace [
    namespace?: string
] {
    mut ns = $namespace
    let current_context = (kubectl config get-contexts | from ssv | where CURRENT == "*" | get 0)
    if ($ns == null) {
        $ns = ($current_context | get NAMESPACE)
    }

    if ((kubectl get ns | from ssv | where NAME == $ns | length) == 0) {
        let span = (metadata $namespace).span;
        error make {
            msg: "Error with namespace provided"
            label: {
                text: $"namespace ($namespace) doesn't exists in cluster ($current_context | get CLUSTER)",
                start: $span.start,
                end: $span.end,
            }
        }
    }

    $ns
}

export def kdepget1 [
    label: string
    --namespace (-n): string
] {

    let ns = (k_namespace $namespace)
    let pods = (kubectl get pod -n $ns -l $label | from ssv)
    let selected_row = (((random decimal) * (($pods | length) - 1)) | math round)
    $pods | get $selected_row | get NAME
}

# Helm template for ArgoCD apps
export def ea_template [
    name: string             # Release name
    --namespace (-n): string # Namepace
    --update (-u): bool      # Update helm dependencies first
] {

    if ($update and ("Chart.yaml" | path exists)) {
        helm dependency update
    }

    mut other_files = "-f ../../env.yaml -f ../gameteam.yaml"
    if ($env.PWD | str contains "non-prod") {
        $other_files = "-f ../../../env.yaml -f ../../gameteam.yaml"
    }
    echo $other_files

    let files = (ls *.yaml |
        where name !~ "(?:(?:Chart|daily)\\.yaml|templates|canary)" |
        str replace "(.*)" "-f ${1}" name | get name |
        str join (char space))

    let args = $"($other_files) ($files)"

    let ns = (k_namespace $namespace)

    $args | xargs helm template $name -n $namespace .
}

export def kdep2rs [
    deploy: string
    --namespace (-n): string
] {
    let ns = (k_namespace $namespace)
    let deploy_manifest = (kubectl get deployment $deploy -n $ns -ojson | from json)
    let deploy_name = ($deploy_manifest | get metadata.labels."app.kubernetes.io/name")
    let deploy_instance = ($deploy_manifest | get metadata.labels."app.kubernetes.io/instance")
    let deploy_revision = ($deploy_manifest | get metadata.annotations."deployment.kubernetes.io/revision")
    (kubectl get rs -n $ns -ojson
        -l $"app.kubernetes.io/name=($deploy_name),app.kubernetes.io/instance=($deploy_instance)" |
        jq -r --arg rev $deploy_revision '.items[] | select(.metadata.annotations."deployment.kubernetes.io/revision" == $rev).metadata.name'
    )
}

export def klabeldeppods [
    deploy: string
    labels: string
    --namespace (-n): string
] {
    let stdin = $in
    if $labels !~ "(?:\\w+=\\w+),?+" {
        error make {
            msg: "labels parameter don't follow key=value format (comma separated)"
        }
    }
    let ns = (k_namespace $namespace)
    let $deploy_manifest = (
        if ($stdin == null) {
            (kubectl get deployment $deploy -n $ns -ojson | from json)
        } else {
            $stdin
        }
    )
    let deploy_name = ($deploy_manifest | get metadata.labels."app.kubernetes.io/name")
    let deploy_instance = ($deploy_manifest | get metadata.labels."app.kubernetes.io/instance")
    (kubectl get pod -n $ns
        -l $"app.kubernetes.io/name=($deploy_name),app.kubernetes.io/instance=($deploy_instance)"
        | from ssv | par-each {|it| if ($it != null) {
            $labels | split row "," | kubectl label pod $it.NAME $in
            }
        }
    )
}

export def relabel_deploy [
    deploy: string
    labels: string
    --namespace (-n): string
] {
    if $labels !~ "(?:\\w+=\\w+),?+" {
        error make {
            msg: "labels parameter don't follow key=value format (comma separated)"
        }
    }
    let new_labels = ($labels | split row "," | split column "=" key value)
    let deploy_file = (mktemp)
    let ns = (k_namespace $namespace)
    kubectl get deployment $deploy -n $ns -oyaml | kubectl neat | save --raw -f $deploy_file
    let replica_set = (kdep2rs $deploy -n $ns)
    let rs_file = (mktemp)
    kubectl get rs $replica_set -n $ns -oyaml | kubectl neat | save --raw -f $rs_file

    open $deploy_file | from yaml | klabeldeppods -n $ns $deploy $labels

    $new_labels | each {|it|
        KEY=$it.key VALUE=$it.value yq '(.metadata.labels,.spec.selector.matchLabels,.spec.template.metadata.labels).[env(KEY)] = env(VALUE)' -i $deploy_file
        KEY=$it.key VALUE=$it.value yq '(.metadata.labels,.spec.selector.matchLabels,.spec.template.metadata.labels).[env(KEY)] = env(VALUE)' -i $rs_file
    }

    kubectl delete deploy $deploy -n $ns --cascade=orphan
    kubectl delete rs $replica_set -n $ns --cascade=orphan
    kubectl apply -f $rs_file -n $ns
    kubectl apply -f $deploy_file -n $ns
    [["deployment" "replicaset"]; [$deploy_file $rs_file]]
}

export def rs4_hc [
    pod: string
    --app (-a): string
    --namespace (-n): string
] {
    let ns = (k_namespace $namespace)

    try {
        (kubectl exec -n $ns $pod -c istio-proxy --
            curl -s $"localhost:10092/($app)/health_check?type=dependency" |
            from json | get check_list | reject id)
    } catch {
        (kubectl exec -n $ns $pod -c istio-proxy --
            curl -s $"localhost:10092/($app)/health_check?type=dependency" |
            from json | get checkList | reject id)

    }
}

export def patch_schema_strategy [
    patch_file: path
    schema_file: path
] {
    (cat $schema_file |
        jq --slurpfile patch $patch_file
        '.definitions = $patch[0].definitions | .properties.strategy.properties = $patch[0].properties' |
        sponge $schema_file)
}

export def update_chart [
    chart_yaml: path
    --name (-n): string
    --version (-v): string
] {
    (CHART=$name VERSION=$version
        yq '(.dependencies.[] | select(.name == env(CHART))).version = env(VERSION)' -I4 -i $chart_yaml)
}

export def norg_conv [
    file: path
    --type (-t): string = "pdf"
] {

    let file_data = ($file | path expand | path parse)
    let new_path = ($file_data | update extension $type | path join)
    (cat $file |
        gsed '/^@document\.meta/,/^@end/d' |
        ~/Projects/neorg-haskell-parser/release/neorg-pardoc -i |
        pandoc -f json -t $type -o $new_path)
}

export def update_here [
    --name (-n): string
    --version (-v): string
] {
    (fd Chart.yaml -x rg $"name:\\s+($name)" -l0 |
        split row (char -u "0") |
        filter {|it| $it != ""} |
        wrap file |
        par-each {|it| update_chart -n $name -v $version $it.file}
    )
}
