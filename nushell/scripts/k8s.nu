def kcmd [
    command: string
    current: bool
    context?: string
] {
    if ($current) {
        kubectl $command --current
    } else if ($context != null) {
        try {
            kubectl $command $context
        } catch {
            kubectl $command (kubectl $command | fzf --preview-window=:hidden)
        }
    } else {
        kubectl $command (kubectl $command | fzf --preview-window=:hidden)
    }
}

export def kcx [context?: string --current (-c)] {
    if ($in != null) {
        kcmd ns $in
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
    key: string
    pod: string = ""
    user: string = "ec2-user"
    --labels (-l): string
    --namespace (-n): string
] {
  mut ns = $namespace
  if ($ns == null) {
    $ns = (kns -c | str replace (char newline) "")
  }
  mut selected_pod = $pod
  if ($labels != null) {
    $selected_pod = (kubectl get pod -n $ns -l $labels -ojson | from json | get items.0.metadata.name)
  }
  echo $"Pod: ($selected_pod).($ns) - Node SSH user: ($user)"
  let link = (kubectl exec -t -n $ns $selected_pod -- sh -c "cat /sys/class/net/eth0/iflink 2>/dev/null" | tr -dc '[:print:]')
  echo $link
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
