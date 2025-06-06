{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gnupg
    home-manager
    nix-output-monitor
    nh
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
  imports = [../../registry.nix ../../modules/kmonad_launchd.nix];
  services.kmonad = {
    enable = true;
    keyboards = {
      AppleInternalKeyboard = {
        device = "Apple Internal Keyboard / Trackpad";
        defcfg = {
          enable = true;
          fallthrough = true;
        };
        config = builtins.readFile ../../../kmonad/darwin_m1.kbd;
      };
    };
  };
  nix = {
    enable = true;
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
      download-buffer-size = 536870912;
      substituters = ["https://toyvo.cachix.org"];
      trusted-public-keys = ["toyvo.cachix.org-1:s++CG1te6YaS9mjICre0Ybbya2o/S9fZIyDNGiD4UXs="];
      trusted-users = [
        "root"
        "@wheel"
        "@localaccounts"
      ];
    };
  };
  programs.gnupg.agent = {
    enable = true;
  };
  programs.zsh.enable = true;
  system.stateVersion = 4;
  system.primaryUser = username;
}
