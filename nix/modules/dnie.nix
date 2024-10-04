{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  name = "DNIe";
  version = "1.6.8";
  system = "x86_64-linux";
in stdenv.mkDerivation {
  inherit name system;
  src = fetchurl {
    url =
      "https://www.dnielectronico.es/descargas/distribuciones_linux/libpkcs11-dnie_${version}_amd64.deb";
    hash = "sha256-hR10OLLAymAeSS5psrvSecDqKRqoiB2TK44KVvYmGwk=";
  };
  nativeBuildInputs = [ autoPatchelfHook dpkg ];
  buildInputs = [ libgcc gcc-unwrapped libassuan libgpgerror pcsclite ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
  '';

  meta = {
    description = "DNIe - PKCS#11 para Sistemas Linux - Unix ";
    homepage =
      "https://www.dnielectronico.es/PortalDNIe/PRF1_Cons02.action?pag=REF_1112";
    # maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ system ];
  };
}
