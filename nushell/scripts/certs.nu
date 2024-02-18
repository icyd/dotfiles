def _text [
    data: string
    --key (-k) = false
] {
  if ($key) {
      return ($data | openssl rsa -noout -text)
  }

  ($data | openssl x509 -noout -text)
}

export def key_verify [
    cert: path
    key: path
] {
  let cert_md5 = (openssl x509 -noout -modulus -in $cert | openssl md5)
  let key_md5 = (openssl rsa -noout -modulus -in $key | openssl md5)
  if ($cert_md5 == $key_md5) {
    return "OK"
  }

  "ERROR"
}

export def text [
    file?: path
    --key
] {
    if ($in != null) {
        return (_text $in --key $key)
    } else if ($file != null) {
        return (_text (open $file) --key $key)
    }

    error make {
        msg: "Missing file or pipeline input"
    }
}

export def verify [
    cert_file: path
    ca_file?: path
] {
    let result = if ($ca_file != null) {
        do {openssl verify -CAfile $ca_file $cert_file} | complete
    } else {
        do {openssl verify $cert_file} | complete
    }

    if ($result.exit_code == 0) {
        return "OK"
    }

    "ERROR"
}

export def chain_text [
    cert_file: path
    ca_file?: path
] {
    let temp = (mktemp)
    if ($ca_file != null) {
        cat $cert_file | save --raw --force $temp
        echo "\n" | save --raw --append $temp
        cat $ca_file | save --raw --append $temp
    } else {
        cat $cert_file | save --raw --force $temp
    }

    let result = (openssl crl2pkcs7 -nocrl -certfile $temp
        | openssl pkcs7 -print_certs -noout -text
    )
    rm $temp
    $result
}

# Unencrypt key file
export def key_unencrypt [
    key_file: path,
    pass_file?: path # If omitted, will look for key_file path suffixed with '_passphrase'
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
                    start: $span.start,
                    end: $span.end,
                }
            }
        }
    }
    (openssl rsa -in $key_file -out $"($key_file)_unencrypted"
        -passin $"pass:($pass)"
    )
}
