use std log

def kcmd [
    command: string
    current: bool
    context?: string
] {
    if ($current) {
        kubectl $command --current
    } else if ($context != null) {
        kubectl $command (kubectl $command | fzf --preview-window=:hidden $"--query=($context)")
    } else {
        kubectl $command (kubectl $command | fzf --preview-window=:hidden)
    }
}

export def kcx [context?: string --current (-c)] {
    if ($in != null) {
        kcmd ctx $in
    } else {
        kcmd ctx $current $context
    }
}

export def kns [context?: string --current (-c)] {
    if ($in != null) {
        kcmd ns $in
    } else {
        kcmd ns $current $context
    }
}

def _k_cert_key_verify [] {
  let data = ($in | from json | get data)
  let cert = ($data | get "tls.crt" | base64 -d | openssl x509 -noout -modulus | openssl md5)
  let key = ($data | get "tls.key" | base64 -d | openssl rsa -noout -modulus | openssl md5)
  if ($cert == $key) {
    echo "OK\n"
  } else {
    echo "ERROR\n"
  }
}

def _k_text [is_cert: bool = false] {
  if ($is_cert) {
      let data = ($in | from json | get data | get "tls.crt" | base64 -d)
      $data | openssl x509 -noout -text
  } else {
      let data = ($in | from json | get data | get "tls.key" | base64 -d)
      $data | openssl rsa -noout -text
  }
}

def _k_verify [] {
      let data = ($in | from json | get data)
      let cert = (mktemp)
      let bundle = (mktemp)
      $data | get "tls.crt" | base64 -d | save --raw --append $cert
      $data | get "ca.crt" | base64 -d | save --raw --append $bundle
      if ((openssl verify -CAfile $bundle $cert | complete).exit_code == 0) {
        echo "OK"
      } else {
        echo "ERROR"
      }
      rm $bundle $cert
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

    if ($verify and ((kubectl get ns | from ssv | where NAME == $ns | length) == 0)) {
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

export def k_cert_key_verify [
    secret: string
    --namespace (-n): string
] {
    if ($namespace != null) {
        kubectl get secret --namespace $namespace $secret -ojson | _k_cert_key_verify
    } else {
        kubectl get secret $secret -ojson | _k_cert_key_verify
    }
}

export def k_cert_text [
    secret: string
    --namespace (-n): string
] {
    if ($namespace != null) {
        kubectl get secret --namespace $namespace $secret -ojson | _k_text true
    } else {
        kubectl get secret $secret -ojson | _k_text true
    }
}

export def k_key_text [
    secret: string
    --namespace (-n): string
] {
    if ($namespace != null) {
        kubectl get secret --namespace $namespace $secret -ojson | _k_text
    } else {
        kubectl get secret $secret -ojson | _k_text
    }
}

export def k_cert_verify [
    secret: string
    --namespace (-n): string
] {
    if ($namespace != null) {
        kubectl get secret --namespace $namespace $secret -ojson | _k_verify
    } else {
        kubectl get secret $secret -ojson | _k_verify
    }
}

export def k_chain_text [
    secret: string
    --namespace (-n): string
] {
    let temp = (mktemp)
    if ($namespace != null) {
        kubectl get secret --namespace $namespace $secret -ojsonpath='{.data.tls\.crt}' | base64 -d | save --raw --force $temp
        echo "\n" | save --raw --append $temp
        kubectl get secret --namespace $namespace $secret -ojsonpath='{.data.ca\.crt}' | base64 -d | save --raw --append $temp
    } else {
        kubectl get secret $secret -ojsonpath='{.data.tls\.crt}' | base64 -d | save --raw --force $temp
        echo "\n" | save --raw --append $temp
        kubectl get secret $secret -ojsonpath='{.data.ca\.crt}' | base64 -d | save --raw --append $temp
    }

    openssl crl2pkcs7 -nocrl -certfile $temp | openssl pkcs7 -print_certs -noout -text
    rm $temp
}

export def kgpodep [
    deployment: string
    --namespace (-n): string
] {
    mut ns = $namespace
    if ($ns == null) {
      $ns = (kns -c | str replace (char newline) "")
    }
    let labels = (kubectl get deploy -n $ns $deployment -oyaml |
        from yaml |
        get spec.selector.matchLabels |
        transpose |
        each {|r| $"($r.column0)=($r.column1)"} | str join ","
    )
    kubectl get pods -n $ns -l $labels -ojson | from json | get items
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

# Get a random pod with a given label
export def kgpofl [
    label: string
    --namespace (-n): string
] {

    let ns = (k_namespace $namespace)
    let pods = (kubectl get pod -n $ns -l $label | from ssv)
    let selected_row = (((random float) * (($pods | length) - 1)) | math round)
    $pods | get $selected_row | get NAME
}

# Get current / active ReplicaSet of a given Deployment
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

# Label all the pods of a given deployment
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

    let svc = if ($all_namespaces) {
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

export def force_update_external_secret [
    name: string
    --namespace (-n): string
] {
    let ns = k_namespace $namespace
    (kubectl annotate externalsecret -n $ns $name
        $"force-sync=(date now | format date "%s")" --overwrite)
}
