{
  stdenv,
  fetchurl,
  pkgs,
  libassuan,
  ...
}:
with pkgs; let
  name = "DNIe";
  version = "1.6.8";
  system = "x86_64-linux";
in
  stdenv.mkDerivation {
    inherit name system;
    src = fetchurl {
      url = "https://www.dnielectronico.es/descargas/distribuciones_linux/libpkcs11-dnie_${version}_amd64.deb";
      hash = "sha256-hR10OLLAymAeSS5psrvSecDqKRqoiB2TK44KVvYmGwk=";
    };
    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
    ];
    buildInputs =
      [libassuan]
      ++ (with pkgs; [
        libgcc
        gcc-unwrapped
        libgpg-error
        pcsclite
      ]);
    unpackPhase = "true";
    installPhase = ''
      mkdir -p staging
      dpkg -x $src staging

      mkdir -p $out/bin
      mkdir -p $out/lib/mozilla/pkcs11-modules
      mkdir -p $out/shared

      [ -d staging/usr/lib ] &&  mv staging/usr/lib/* $out/lib/mozilla/pkcs11-modules/ || true
      [ -d staging/usr/bin ] && mv staging/usr/bin/* $out/bin/ || true
      [ -d staging/usr/share ] && mv staging/usr/share/* $out/share/ || true
    '';

    meta = {
      description = "DNIe - PKCS#11 para Sistemas Linux - Unix ";
      homepage = "https://www.dnielectronico.es/PortalDNIe/PRF1_Cons02.action?pag=REF_1112";
      # maintainers = with stdenv.lib.maintainers; [ ];
      platforms = [system];
    };
  }
