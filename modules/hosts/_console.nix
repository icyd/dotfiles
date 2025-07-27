{
  flake.modules.nixos.base = {pkgs, ...}: {
    console = {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-120n.psf.gz";
      keyMap = "us";
    };
  };
}
