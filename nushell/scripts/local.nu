export def exthc [
    app: string
    endpoint: string
] {
    let suffix = do {
        if $app == "sg" {
            "a2007200627e6ef9bccd6ac4244a63c368bf9360"
        } else if $app == "alerts" {
            "4080fee845c1b011746013c89840a9890c69b78c"
        } else if $app == "alerts-mobile" {
            "cefdc28fa7c6f70b6bc0da46611a71dcd5ee82f4"
        } else if $app == "channels" {
            "0a96aee93ff3a1b4d3d040da63666dcfa714f24b"
        } else if $app == "channels-split" {
            "e312ce3f804808ba2588610aa754f24b1454f0c1"
        } else if $app == "channels20" {
            "ohjai8Iequ3oyies0chie9Xauloh2ru4po0Aighu"
        } else if $app == "channels21" {
            "c82e61d1a412a2edde1c5ad5a8664f6ca27e818f"
        } else if $app == "channels23" {
            "5a457c7ce1a944f3cad593b742be61379c08880d"
        } else if $app == "xmshd-curated" {
            "333339999sdjlkslakjsfp9283ulkdjfjnaksdjf"
        } else {
            "1626e6adf06380c21e2be6d8dc70c6aef3898df7"
        }
    }
    curl -s $"https://($endpoint).service.easports.com/health/($suffix)" -u health:servicecheck | from json | get check_list | reject id
}
