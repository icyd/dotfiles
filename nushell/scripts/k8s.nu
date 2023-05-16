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
    kcmd ctx $current $context
}

export def kns [context?: string --current (-c)] {
    kcmd ns $current $context
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
        kubectl get secret --namespace $namespace $secret -ojsonpath='{.data.ca\.crt}' | base64 -d | save --raw --append $temp
    } else {
        kubectl get secret $secret -ojsonpath='{.data.ca\.crt}' | base64 -d | save --raw --append $temp
    }

    openssl crl2pkcs7 -nocrl -certfile $temp | openssl pkcs7 -print_certs -noout -text
    rm $temp
}
