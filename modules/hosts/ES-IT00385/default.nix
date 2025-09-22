{config, ...}: {
  flake.meta.hosts.ES-IT00385 = {
    user = "aj.vazquez";
    system = "aarch64-darwin";
  };
  flake.modules.darwin."hosts/ES-IT00385" = let
    inherit (config.flake.meta.users.${config.flake.meta.hosts.ES-IT00385.user}) username;
    inherit (config.flake.meta.hosts.ES-IT00385) system;
  in {
    nixpkgs.hostPlatform = {inherit system;};
    nix.settings.trusted-users = [username];
    homebrew = {
      brews = [
        "binutils"
        "coreutils"
        "findutils"
        "moreutils"
        "gnu-sed"
        "gnu-tar"
        "gpgme"
        "pinentry-mac"
        "theseal/ssh-askpass/ssh-askpass"
      ];
      casks = [
        "gpg-suite"
        "karabiner-elements"
        "wireshark-app"
      ];
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
      };
      taps = [
        "theseal/ssh-askpass"
      ];
    };
    imports = with config.flake.modules.darwin;
      [
        base
        gpg
      ]
      ++ [config.flake.modules.darwin."users/aj.vazquez"];
  };
}
