{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    gnupg
    vim
  ];
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  # Binary Cache for Haskell.nix
  nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-users = [
          "root"
          "@admin"
      ];
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    onActivation = {
        autoUpdate = true;
        upgrade = true;
    };
    taps = [
      "homebrew/cask"
      "koekeishiya/formulae"
    ];
    casks = [
      "gpg-suite"
      "amethyst"
      "wireshark"
      "wezterm"
    ];
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
      "skhd"
      "saml2aws"
      "yabai"
      "watch"
    ];
  };
}
