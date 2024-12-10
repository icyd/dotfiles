{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg
    home-manager
    nh
    nix-output-monitor
    nvd
    vim
  ];
  environment.variables = rec {
    FLAKE = "/Users/${username}/.dotfiles";
    LANG = "en_US.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_TIME = LC_MONETARY;
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
    ];
    casks = [
      "gpg-suite"
      "wireshark"
    ];
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };
  imports = [ ../../registry.nix ];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixVersions.stable;
    settings = {
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
