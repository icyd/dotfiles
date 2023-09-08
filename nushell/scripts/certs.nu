def _text [is_cert: bool = false] {
  if ($is_cert) {
      $in | openssl x509 -noout -text
  } else {
      $in | openssl rsa -noout -text
  }
}

export def cert_key_verify [
    cert: path
    key: path
] {
  let cert = (openssl x509 -noout -modulus -in $cert | openssl md5)
  let key = (openssl rsa -noout -modulus -in $key | openssl md5)
  if ($cert == $key) {
    echo "OK\n"
  } else {
    echo "ERROR\n"
  }
}

export def cert_text [
    cert: path
] {
    open $cert | _text true
}

export def key_text [
    key: path
] {
    open $key | _text
}

export def verify [
    cert: path
    ca?: path
] {
    mut result = {openssl verify $cert | complete}
    if ($ca != null) {
        $result = {openssl verify -CAfile $ca $cert | complete}
    }

    if ((do $result).exit_code == 0) {
        echo "OK"
    } else {
        echo "ERROR"
    }
}

export def chain_text [
    cert: path
    ca?: path
] {
    let temp = (mktemp)
    if ($ca != null) {
        cat $cert | save --raw --force $temp
        echo "\n" | save --raw --append $temp
        cat $ca | save --raw --append $temp
    } else {
        cat $cert | save --raw --force $temp
    }

    openssl crl2pkcs7 -nocrl -certfile $temp | openssl pkcs7 -print_certs -noout -text
    rm $temp
}
