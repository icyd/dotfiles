{
  config,
  pkgs,
  ...
}: let
  brewPrefix =
    if pkgs.stdenv.hostPlatform.isAarch64
    then "/opt/homebrew"
    else "/usr/local";
  nixvim = pkgs.nixvim.extend {
    plugins.luasnip.fromLua = [
      {
        paths = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.lua_snippets.local";
      }
    ];
  };
in {
  imports = [../../hm-modules/home.nix];
  home.sessionVariables = {
    MANPATH = "${brewPrefix}/opt/coreutils/libexec/gnuman:$MANPATH";
    PATH = "${brewPrefix}/opt/coreutils/libexec/gnubin:$PATH";
  };
  programs.git.aliases.p4 = "/usr/local/bin/git-p4";
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    awscli2
    buildah
    crane
    checkov
    conftest
    dive
    helm-docs
    helmfile
    reattach-to-user-namespace
    regclient
    podman
    saml2aws
    skopeo
    stern
    pueue
    trivy
    yubikey-manager
  ] ++ [ nixvim ];
}
