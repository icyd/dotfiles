args@{
  pkgs,
  lib,
  config,
  stateVersion,
  username,
  email,
  homeDirectory,
  nix-colors,
  ...
}:
let
  brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then "/opt/homebrew" else "/usr/local";
  alacrittyFont =
    let
      fontname = "AnonymicePro Nerd Font";
    in
    {
      normal = {
        family = fontname;
      };
      size = 15;
    };
in
{
  imports = [
    (import ../../modules/home-common.nix (args // { inherit alacrittyFont; }))
  ];
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    MANPATH = "${brewPrefix}/opt/coreutils/libexec/gnuman:$MANPATH";
    PATH = "$ASDF_DATA_DIR/shims:${brewPrefix}/bin:${brewPrefix}/opt/coreutils/libexec/gnubin:$PATH";
  };
  home.packages = with pkgs; [
    awscli2
    black
    crane
    codespell
    commitlint
    dive
    faas-cli
    hadolint
    hclfmt
    helmfile
    golangci-lint
    gotools
    istioctl
    isort
    krew
    kubectl
    kubernetes-helm
    lemminx
    luajitPackages.luacheck
    mypy
    nil
    nodejs
    nodePackages.bash-language-server
    nodePackages.jsonlint
    nodePackages.vscode-json-languageserver-bin
    pylint
    pyright
    reattach-to-user-namespace
    regclient
    saml2aws
    shellcheck
    skopeo
    stern
    stylua
    terraform-ls
    yamllint
    yaml-language-server
    unstable.devenv
    unstable.pueue
    vale
  ];
  xdg.configFile = {
    amethyst.source = ../../../amethyst;
  };
}
