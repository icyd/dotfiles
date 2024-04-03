{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ gnupg home-manager vim ];
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
    casks = [ "gpg-suite" "amethyst" "wireshark" ];
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
    package = pkgs.nixFlakes;
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-substituters = [ "https://nix-community.cachix.org" ];
      trusted-users = [ "root" "@admin" ];
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
