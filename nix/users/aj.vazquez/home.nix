{
  lib,
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
    PATH = "${brewPrefix}/opt/coreutils/libexec/gnubin:${brewPrefix}/bin:$PATH";
  };
  programs.git = {
    aliases.p4 = "/usr/local/bin/git-p4";
    extraConfig = {
      user.signingkey = lib.mkForce "${config.home.homeDirectory}/id_ed25519_sk.pub";
    };
    userEmail = "aj.vazquez@globant.com";
  };
  # programs.ssh.enable = true;
  home.stateVersion = "22.05";
  home.packages = with pkgs;
    [
      age-plugin-yubikey
      awscli2
      crane
      checkov
      conftest
      helm-docs
      helmfile
      keychain
      krew
      reattach-to-user-namespace
      regclient
      p4v
      podman
      skopeo
      stern
      openssh
      pueue
      trivy
      yubikey-manager
    ]
    ++ [nixvim];
  programs.nushell.extraEnv = ''
    $env.SSH_ASKPASS = "${brewPrefix}/bin/ssh-askpass"
    $env.SSH_ASKPASS_REQUIRE = "prefer"
    ${lib.getExe pkgs.keychain} --agents ssh --eval --quiet id_ed25519_sk
      | lines
      | where not ($it | is-empty)
      | parse "{name}={value}; export {name2};"
      | reject name2
      | transpose --header-row
      | into record
      | load-env
  '';
  xdg.configFile = {
    kmonad = {
      source = ../../../kmonad/darwin_m1.kbd;
      target = "config.kbd";
    };
  };
}
