{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gnupg
    home-manager
    nix-output-monitor
    nvd
    vim
  ];
  environment.variables = rec {
    NH_FLAKE = "/Users/${username}/.dotfiles";
    LANG = "en_US.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_TIME = LC_MONETARY;
  };
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
      "wireshark"
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
  imports = [../../registry.nix];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixVersions.stable;
    settings = {
      substituters = ["https://toyvo.cachix.org"];
      trusted-public-keys = ["toyvo.cachix.org-1:s++CG1te6YaS9mjICre0Ybbya2o/S9fZIyDNGiD4UXs="];
      trusted-users = [
        "root"
        "@wheel"
        "@localaccounts"
      ];
    };
  };
  programs.nh.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
