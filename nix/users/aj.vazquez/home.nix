args@{ pkgs, lib, config, stateVersion, username, email, homeDirectory
, nix-colors, ... }:
let
  brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then
    "/opt/homebrew"
  else
    "/usr/local";
  alacrittyFont = let fontname = "AnonymicePro Nerd Font";
  in {
    normal = { family = fontname; };
    size = 15;
  };
in {
  imports = [
    (import ../../modules/home-common.nix (args // { inherit alacrittyFont; }))
  ];
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MANPATH = "${brewPrefix}/opt/coreutils/libexec/gnuman:$MANPATH";
    PATH = "${brewPrefix}/bin:${brewPrefix}/opt/coreutils/libexec/gnubin:$PATH";
  };
  home.packages = with pkgs; [
    awscli2
    crane
    dive
    faas-cli
    helmfile
    istioctl
    krew
    kubectl
    kubernetes-helm
    nodejs
    reattach-to-user-namespace
    regclient
    rustup
    saml2aws
    skopeo
    stern
    unstable.pueue
  ];
  xdg.configFile = { amethyst.source = ../../../amethyst; };
}
