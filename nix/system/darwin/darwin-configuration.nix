{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  attrsKeys = lib.mapAttrsToList (k: _: k);
  attrsVals = lib.mapAttrsToList (_: v: v);
in
{
  environment = {
    systemPackages = with pkgs; [
      gnupg
      home-manager
      vim
    ];
  };
  homebrew = {
    brews = [
      "asdf"
      "binutils"
      "coreutils"
      "findutils"
      "moreutils"
      "gnu-sed"
      "gnu-tar"
      "gpgme"
      "pinentry-mac"
      "podman"
      "saml2aws"
      "watch"
    ];
    casks = [
      "gpg-suite"
      "amethyst"
      "wireshark"
    ];
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    package = pkgs.nixFlakes;
    # registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
    settings =
      let
        cache = {
          "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          "https://cache.iog.io" = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=";
          "https://devenv.cachix.org" = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
        };
        substituters = attrsKeys cache;
        trusted-public-keys = attrsVals cache;
      in
      {
        inherit substituters trusted-public-keys;
        trusted-substituters = substituters;
        trusted-users = [
          "root"
          "@admin"
          "@staff"
          "@localaccounts"
        ];
      };
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
