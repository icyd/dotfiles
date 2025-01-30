{ pkgs, ... }:
let
  brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then "/opt/homebrew" else "/usr/local";
in
{
  imports = [ ../../hm-modules/home.nix ];
  home.sessionVariables = {
    MANPATH = "${brewPrefix}/opt/coreutils/libexec/gnuman:$MANPATH";
    PATH = "$ASDF_DATA_DIR/shims:${brewPrefix}/bin:${brewPrefix}/opt/coreutils/libexec/gnubin:$PATH";
  };
  programs.git.aliases.p4 = "/usr/local/bin/git-p4";
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    awscli2
    crane
    dive
    hclfmt
    helmfile
    reattach-to-user-namespace
    regclient
    saml2aws
    skopeo
    stern
    terraform-ls
    unstable.devenv
    unstable.pueue
  ];
}
