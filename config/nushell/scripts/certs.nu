use std log

def _openssl [
    data: string
    cmd: closure
    --no-trim
] {
    let result = $data | do $cmd | complete
    log debug $"($result)"
    if ($result.exit_code == 0) {
        return $result.stdout
    }

    if ($no_trim) {
        return $result.stderr
    }

    $result.stderr | tail -n+2
}

def --wrapped _cert [
    data: string
    ...args
] {
  _openssl $data { openssl x509 -noout ...$args }
}

def --wrapped _key [
    data: string
    ...args
] {
  _openssl $data { openssl rsa -noout ...$args }
}

def --wrapped _base [
    data: string
    --key (-k)
    ...args
] {
  if ($key) {
    return (_key $data ...$args)
  }

  _cert $data ...$args
}

def _text [
    data: string
    --key (-k)
] {
  _base $data --key=$key -text
}

def _chain [ data: string ] {
    let temp = (mktemp -t)

    $data | save --raw --force $temp

    let result = (openssl crl2pkcs7 -nocrl -certfile $temp
        | openssl pkcs7 -print_certs -noout -text
    )
    rm $temp
    $result
}

def _key_verify [
    cert: string
    key: string
] {
  let cert_md5 = (_base $cert -noout -modulus | openssl md5)
  let cert_md52 = (_base $cert -noout -modulus | openssl md5)
  let key_md5 = (_base $key --key -noout -modulus | openssl md5)
  if ($cert_md5 == $key_md5) {
    return "OK"
  }

  log debug $"cert modulus: ($cert_md5), key modulus: ($key_md5)"
  "ERROR"
}

def _k_data [
    secret: string
    --namespace (-n): string
] {
    let ns = if ($namespace | is-empty) {
        []
    } else {
        [--namespace $namespace]
    }

    kubectl get secret ...$ns $secret -ojson
        | from json
        | get data
        | transpose key value
        | upsert value {|it| $it.value | base64 -d}
}

def _k_extract_data [
    data: table<key: string, value: string>
    --cert-name: string = "tls.crt"
    --key-name: string = "tls.key"
    --cacert-name: string = "ca.crt"
] {

    let entries = [[key name value]; [cert $cert_name ""] [key $key_name ""] [cacert $cacert_name ""]]
    $entries | upsert value {|row|
        $data | where key == $row.name | get -o value.0
    } | reduce -f {} {|it, acc|
        if ($it.value | is-empty) {
            $acc
        } else {
            $acc | upsert $it.key $it.value
        }
    }
}

def _check_entry [
    data: record
    entry: string
    msg: string
    span: record
] {
    if ($data | get -o $entry | is-empty) {
        error make {
            msg: $msg,
            label: {
                text: "check entry name on secret",
                span: $span
            }
        }
    }
}

def _check_cert [
    data: record
    span: record
] {
    _check_entry $data cert "Missing certificate on secret" $span
}

def _check_key [
    data: record
    span: record
] {
    _check_entry $data key "Missing key on secret" $span
}

def _check_cacert [
    data: record
    span: record
] {
    _check_entry $data cacert "Missing CA certificate on secret" $span
}

def --wrapped _cmd [
    stdin?: string
    file?: path
    --key (-k)
    ...args
] {
    if (not ($stdin | is-empty)) {
        return (_base $stdin --key=$key ...$args)
    } else if (not ($file | is-empty)) {
        return (_base (open $file) --key=$key ...$args)
    }

    error make {
        msg: "Missing file or pipeline input"
    }
}

export def --wrapped cmd [
    file?: path
    --key (-k)
    ...args
] {
    _cmd $in $file --key=$key ...$args
}

export def text [
    file?: path
    --key (-k)
] {
    _cmd $in $file --key=$key -text
}

export def k_text [
    secret: string
    --namespace (-n): string
    --cert-name: string = "tls.crt"
    --key-name: string = "tls.key"
    --key (-k)
] {
    let data = (_k_extract_data (_k_data --namespace $namespace $secret)
        --cert-name $cert_name --key-name $key_name
    )

    if ($key) {
        _check_key $data (metadata $key_name).span
        return ($data.key | text --key)
    }

    _check_cert $data (metadata $cert_name).span
    $data.cert | text
}

export def k_cacert [
    secret: string
    --namespace (-n): string
    --cacert-name: string = "ca.crt"
] {
    k_text $secret --namespace $namespace --cert-name $cacert_name
}

export def key_verify [
    cert: path
    key: path
] {
    let cert_data = if ($cert | path exists) {
        cat $cert
    } else {
        $cert
    }
    log debug $"($cert_data)"
    let key_data = if ($key | path exists) {
        cat $key
    } else {
        $key
    }
    log debug $"($key_data)"
    _key_verify $cert_data $key_data
}

export def k_key_verify [
    secret: string
    --namespace (-n): string
    --cert-name: string = "tls.crt"
    --key-name: string = "tls.key"
] {
    let data = (_k_extract_data (_k_data --namespace $namespace $secret)
        --cert-name $cert_name --key-name $key_name
    )
    _check_cert $data (metadata $cert_name).span
    _check_key $data (metadata $key_name).span
    _key_verify $data.cert $data.key
}

export def verify [
    cert: path
    --cacert: path
] {
    log debug $"certificate file: ($cert)"
    log debug $"CA certificate file: ($cacert)"

    let ca = if (not ($cacert | is-empty)) {
        [-CAfile $cacert]
    } else {
        []
    }

    _openssl "" { openssl verify ...$ca $cert } --no-trim | str replace -r '^.*:\s+' ''
}

export def k_verify [
    secret: string
    --namespace (-n): string
    --cert-name: string = "tls.crt"
    --cacert-name: string = "ca.crt"
] {
    let data = (_k_extract_data (_k_data --namespace $namespace $secret)
        --cert-name $cert_name --cacert-name $cacert_name
    )
    _check_cert $data (metadata $cert_name).span

    let cacert_file = (mktemp -t)
    let ca = if (not ($cacert_name | is-empty)) {
        _check_cacert $data (metadata $cacert_name).span
        $data.cacert | save --raw --force $cacert_file
        $cacert_file
    } else {
        ""
    }

    let cert_file = (mktemp -t)
    $data.cert | save --raw --force $cert_file
    let result = verify $cert_file --cacert=$ca

    rm -f $cert_file $cacert_file

    $result
}

export def chain_text [
    cert?: path
    --cacert: path
] {
    let stdin = $in
    log debug $"certificate file: ($cert)"
    log debug $"CA certificate file: ($cacert)"

    let tmpfile = (mktemp -t)
    if ($stdin | is-empty) {
        open $cert | save --raw --force $tmpfile
        if (not ($cacert | is-empty)) {
            char newline | save --append $tmpfile
            open $cacert | save --raw --append $tmpfile
        }
    } else {
        $stdin | save --raw --force $tmpfile
    }

    let result = (openssl crl2pkcs7 -nocrl -certfile $tmpfile
        | openssl pkcs7 -print_certs -noout -text
    )

    rm $tmpfile

    $result
}

export def k_chain_text [
    secret: string
    --namespace (-n): string
    --cert-name: string = "tls.crt"
    --cacert-name: string = "ca.crt"
] {
    let data = (_k_extract_data (_k_data --namespace $namespace $secret)
        --cert-name $cert_name --cacert-name $cacert_name
    )
    _check_cert $data (metadata $cert_name).span
    let cert_file = (mktemp -t)
    $data.cert | save --raw --force $cert_file

    if (not ($cacert_name | is-empty)) {
        _check_cacert $data (metadata $cacert_name).span
        char newline | save --append $cert_file
        $data.cacert | save --raw --append $cert_file
    }

    let result = (openssl crl2pkcs7 -nocrl -certfile $cert_file
        | openssl pkcs7 -print_certs -noout -text
    )

    rm -f $cert_file

    $result
}

export def --wrapped k_cmd [
    secret: string
    --namespace (-n): string
    --secret-key (-k): string = "tls.crt"
    ...args
] {
    let key = $secret_key == "tls.key"
    let data = _k_data --namespace $namespace $secret
        | where key == $secret_key
        | get value
        | first
    _cmd $data --key=$key ...$args
}

# Unencrypt key file
export def key_unencrypt [
    key_file: path,
    --pass-file (-p): path # If omitted, will look for key_file path suffixed with '_passphrase'
    --output (-o): path # If omitted, will create key_file suffixed with '_unencrypted'
] {

    let pass = if ($pass_file != null) {
        open $pass_file | str trim
    } else {
        let default_pass_file = $"($key_file)_passphrase"
        if ($default_pass_file | path exists) {
            open $default_pass_file | str trim
        } else {
            let span = (metadata $pass_file).span
            error make {
                msg: $"'pass_file' or ($default_pass_file) required",
                label: {
                    text: "Passphrase file not found",
                    span: $span,
                }
            }
        }
    }

    let output_file = if ($output | is-empty) {
        $"($key_file)_unencrypted"
    } else {
        $output
    }

    # typos: disable-next-line
    openssl rsa -in $key_file -out $output_file -passin $"pass:($pass)"
}

# Split chain in separated certificates
export def split_chain [
    chain?: string
] {
   let chain = if ($chain | is-empty) { $in } else { $chain }

   $chain
       | split row "-----END CERTIFICATE-----"
       | compact --empty
       | each {|i| $"($i)-----END CERTIFICATE-----"}
}
