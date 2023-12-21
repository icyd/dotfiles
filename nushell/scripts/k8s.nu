use std log
use certs.nu
use utils.nu

def _kcmd [
    command: string
    query_text?: string
    --current: bool = false
] {
    if ($current) {
        kubectl $command --current
    } else if ($query_text != null) {
        kubectl $command (kubectl $command | fzf --preview-window=:hidden $"--query=($query_text)")
    } else {
        kubectl $command (kubectl $command | fzf --preview-window=:hidden)
    }
}

export def kcx [
    query_text?: string
    --current (-c)
] {
    let q = if ($in != null) {
        $in
    } else {
        $query_text
    }

    _kcmd ctx $q --current $current
}

export def kns [
    query_text?: string
    --current (-c)
] {
    let q = if ($in != null) {
        $in
    } else {
        $query_text
    }

    _kcmd ns $q --current $current
}

def k_namespace [
    namespace?: string
    --verify (-v): bool
] {
    let ns = if ($namespace == null) {
        let current_context = (kubectl config get-contexts
            | from ssv
            | where CURRENT == "*"
            | get 0
        )
        ($current_context | get NAMESPACE)
    } else {
        $namespace
    }

    if (($verify != null) and ((kubectl get ns | from ssv | where NAME == $ns | length) == 0)) {
        let span = (metadata $namespace).span;
        error make {
            msg: "Error with namespace provided"
            label: {
                text: $"namespace ($namespace) doesn't exists in current cluster",
                start: $span.start,
                end: $span.end,
            }
        }
    }

    $ns
}

def _k_data [
    secret: string
    --namespace (-n): bool = false
    --key
    --ca-cert
] {
    let data = if ($namespace != null) {
        (kubectl get secret --namespace $namespace $secret -ojson
            | from json
            | get data
        )
    } else {
        (kubectl get secret $secret -ojson
            | from json
            | get data
        )
    }

    if ($key) {
        if ("tls.key" in ($data | columns)) {
          return ($data."tls.key" | base64 -d)
        } else if ("key" in ($data | columns)) {
          return ($data."key" | base64 -d)
        }

        error make {msg: "no 'tls.key' nor 'key' entry in secret data"}
    } else if ($ca_cert) {
        if ("ca.crt" in ($data | columns)) {
          return ($data."ca.crt" | base64 -d)
        } else if ("cacert" in ($data | columns)) {
          return ($data."cacert" | base64 -d)
        }

        error make {msg: "no 'ca.crt' nor 'cacert' entry in secret data"}
    } else {
        if ("tls.crt" in ($data | columns)) {
            return ($data."tls.crt" | base64 -d)
        } else if ("cert" in ($data | columns)) {
            return ($data."cert" | base64 -d)
        }

        error make {msg: "no 'tls.crt' nor 'cert' entry in secret data"}
    }
}

export def k_cert_text [
    secret: string
    --namespace (-n): string
] {
    _k_data $secret --namespace $namespace | certs text
}

export def k_key_text [
    secret: string
    --namespace (-n): string
] {
    _k_data $secret --namespace $namespace --key | certs text --key
}

export def k_cert_key_verify [
    secret: string
    --namespace (-n): string
] {
    let cert_file = (mktemp)
    let key_file = (mktemp)
    let cert_data = _k_data $secret --namespace $namespace
    let key_data = _k_data $secret --namespace $namespace --key
    $cert_data | save --raw --force $cert_file
    $key_data | save --raw --force $key_file
    let result = (certs key_verify $cert_file $key_file)
    rm $cert_file $key_file
    $result
}

def _k_cert_cacert [
    secret: string
    func: closure
    --namespace (-n): string
] {
    let cert_file = (mktemp)
    let cert = _k_data $secret --namespace $namespace
    $cert | save --raw --force $cert_file

    let ca_cert = try {
        _k_data $secret --namespace $namespace --ca-cert
    } catch { null }

    let cacert_file = if ($ca_cert != null) {
        let aux_file = (mktemp)
        $ca_cert | save --raw --force $aux_file
        $aux_file
    } else {
        null
    }

    let result = do $func $cert_file $cacert_file
    rm $cert_file $cacert_file
    $result
}

export def k_cert_verify [
    secret: string
    --namespace (-n): string
] {
    _k_cert_cacert $secret --namespace $namespace  {|cert_file, cacert_file| certs verify $cert_file $cacert_file}
}

export def k_chain_text [
    secret: string
    --namespace (-n): string
] {
    _k_cert_cacert $secret --namespace $namespace  {|cert_file, cacert_file| certs chain_text $cert_file $cacert_file}
}

export def kshark [
    pod: string = ""
    --user (-u): string = "ec2-user"
    --key (-k): path
    --labels (-l): string
    --namespace (-n): string
] {
  mut ns = $namespace
  if ($key == null) {
      error make {msg: "Missing ssh key"}
  }

  if ($ns == null) {
    $ns = (kns -c | str replace (char newline) "")
  }

  mut selected_pod = $pod
  if ($labels != null) {
    $selected_pod = (kubectl get pod -n $ns -l $labels -ojson | from json | get items.0.metadata.name)
  }

  log info $"Pod: ($selected_pod).($ns) - Node SSH user: ($user)"
  let link = (kubectl exec -t -n $ns $selected_pod -- sh -c "cat /sys/class/net/eth0/iflink 2>/dev/null" | tr -dc '[:print:]')

  log debug $"Link #($link)"
  if ($link == "") {
    error make {msg: "Error extracting link"}
  }

  log debug $"Link: ($link)"
  let ip = (kubectl get pod -n $ns -owide $selected_pod -ojsonpath='{.status.hostIP}')
  if ($ip == "") {
    error make {msg: "Error getting host ip from pod"}
  }

  log debug $"Node IP: ($ip)"
  let eni = (ssh -i $key $"($user)@($ip)" "/usr/sbin/ip link" | from ssv -n -m 1 | where column1 =~ $"^($link)" | get column2.0 | str replace --regex "(.*)@.*" "$1")
  if ($eni == "") {
    error make {msg: "Error getting pod's ENI."}
  }

  log debug $"ENI: ($eni)"
  log info "Installing tcpdump if not installed..."
  ssh -i $key $"($user)@($ip)" "if ! rpm -qa | grep -qw tcpdump; then sudo yum install tcpdump -y; fi"

  log info "Executing command..."
  if ((uname -o) == "Darwin") {
      ssh -i $key $"($user)@($ip)" $"sudo tcpdump -i ($eni) -U -s0 -w - 'not port 22'" | /Applications/Wireshark.app/Contents/MacOS/Wireshark -k -i -
  } else {
      ssh -i $key $"($user)@($ip)" $"sudo tcpdump -i ($eni) -U -s0 -w - 'not port 22'" | wireshark -k -i -
  }
}

export def ksharkdep [
    key: string
    deployment: string
    user: string = "ec2-user"
    --namespace (-n): string
] {
  mut ns = $namespace
  if ($ns == null) {
    $ns = (kns -c | str replace (char newline) "")
  }
  let selected_pod = (kgpodep -n $ns $deployment).0.metadata.name
  echo $"Pod: ($selected_pod).($ns) - Node SSH user: ($user)"
  let link = (kubectl exec -t -n $ns $selected_pod -- sh -c "cat /sys/class/net/eth0/iflink 2>/dev/null" | tr -dc '[:print:]')
  if ($link == "") {
    error make {msg: "Error extracting link"}
  }
  echo $"Link: ($link)"
  let ip = (kubectl get pod -n $ns -owide $selected_pod -ojsonpath='{.status.hostIP}')
  if ($ip == "") {
    error make {msg: "Error getting host ip from pod"}
  }
  echo $"Node IP: ($ip)"
  let eni = (ssh -i $key $"($user)@($ip)" "/usr/sbin/ip link" | from ssv -n -m 1 | where column1 =~ $"^($link)" | get column2.0 | str replace "(.*)@.*" "$1")
  if ($eni == "") {
    error make {msg: "Error getting pod's ENI."}
  }
  echo $"ENI: ($eni)"
  echo "Installing tcpdump if not installed..."
  ssh -i $key $"($user)@($ip)" "if ! rpm -qa | grep -qw tcpdump; then sudo yum install tcpdump -y; fi"
  echo "Executing command..."
  if ((uname -o) == "Darwin") {
      ssh -i $key $"($user)@($ip)" $"sudo tcpdump -i ($eni) -U -s0 -w - 'not port 22'" | /Applications/Wireshark.app/Contents/MacOS/Wireshark -k -i -
  } else {
      ssh -i $key $"($user)@($ip)" $"sudo tcpdump -i ($eni) -U -s0 -w - 'not port 22'" | wireshark -k -i -
  }
}

export def kgpo_from_deploy_with_labels [
    deployment: string
    --namespace (-n): string
] {
    let ns = (k_namespace $namespace)
    let labels = (kubectl get deploy -n $ns $deployment -oyaml |
        from yaml |
        get spec.selector.matchLabels |
        transpose key value |
        utils table_2_string $in
    )
    kubectl get pods -n $ns -l $labels -ojson | from json | get items
}

# Get a random pod with a given label
export def kgpo1_from_labels [
    labels: string
    --namespace (-n): string
] {

    let ns = (k_namespace $namespace)
    let pods = (kubectl get pod -n $ns -l $labels | from ssv)
    utils random_row $pods | get NAME
}

# Get current / active ReplicaSet of a given Deployment
export def kg_active_rs [
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

# Label all the pods of a given deployment
export def k_label_pods_from_deploy [
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

export def kpfsvc [
    name: string
    ports: string
    --namespace (-n): string
    --all-namespaces (-A): bool
] {
    let service_name = if ($name =~ '-\d+$') {
       $name | str replace --regex '-\d+$' ''
    } else {
        $name
    }

    let svc = if ($all_namespaces != null) {
        (kubectl get svc --all-namespaces
            | from ssv
            | where NAME == $service_name
            | get 0
        )
    } else {
        let ns = k_namespace $namespace
        (kubectl get svc -n $ns
            | from ssv
            | where NAME == $service_name
            | insert NAMESPACE $ns
            | get 0
        )
    }

    if ($name == $service_name) {
        $svc | kubectl port-forward -n $in.NAMESPACE $"svc/($in.NAME)" $ports
    } else {
        $svc | kubectl port-forward -n $in.NAMESPACE $name $ports
    }
}

export def k_relabel_deploy [
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

# export def k_force_update_external_secret [
#     name: string
#     --namespace (-n): string
# ] {
#     let ns = k_namespace $namespace
#     (kubectl annotate externalsecret -n $ns $name
#         $"force-sync=(date now | format date "%s")" --overwrite)
# }

# export def k_zombify_container [
#     pod_name: string
#     --namespace (-n): string
#     --container-name (-c): string
# ] {
#     let ns = k_namespace $namespace
#     let pod_manifest = (mktemp)
#     log info $"Storing pod manifest in: ($pod_manifest)"
#     kubectl get pod $pod_name -n $ns -oyaml | kubectl neat | save --raw -f $pod_manifest
#     (cat $pod_manifest
#         | CONTAINER_NAME=$container_name yq 'with(.spec.containers[] | select(.name == env(CONTAINER_NAME)); del(.readinessProbe), del(.startupProbe), del(.livenessProbe), .command = ["sleep", "1d"]) | with(.metadata; .name += "-zombie", del(.annotations), del(.labels))'
#         | kubectl apply -n $ns -f-
#     )
# }

# export def k_gpo_in_node_version [
#     version: string
# ] {
#     let nodes = kgno_version $version
#
#     (kubectl get pods --all-namespaces -ojson
#         | from json
#         | get items
#         | filter {|it| $it.spec.nodeName in ($nodes | get NAME)}
#         | each {|it|
#             {
#                 name: $it.metadata.name,
#                 namespace: $it.metadata.namespace,
#                 node: $it.spec.nodeName,
#             }
#         }
#     )
# }

# export def k_drain_nodes_version [
#     version: string
#     --timeout (-T): duration = 5min
#     --sleep-duration (-s): duration = 30sec
# ] {
#     let timeout_secs = $"($timeout / 1sec)s"
#     (kgno_version $version
#         | each {|it|
#             kubectl drain $it.NAME --ignore-daemonsets --delete-emptydir-data $"--timeout=($timeout_secs)"
#             sleep $sleep_duration
#         }
#         | ignore
#     )
# }
