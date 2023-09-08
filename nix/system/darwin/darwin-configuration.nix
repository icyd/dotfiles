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
    ];
    casks = [
      "gpg-suite"
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
      "pinentry-mac"
      "podman"
      "saml2aws"
      "watch"
    ];
  };
}
