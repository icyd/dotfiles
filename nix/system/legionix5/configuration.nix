{
  pkgs,
  lib,
  inputs,
  username,
  ...
}:
let
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in
{
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  # environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
  #   module: ${pkgs.opensc}/lib/opensc-pkcs11.so
  # '';
  # environment.etc."pkcs11/modules/dnie-pkcs11".text = ''
  #   module: ${
  #     (pkgs.callPackage ../../modules/dnie.nix { })
  #   }/usr/lib/libpkcs11-dnie.so
  # '';
  environment.gnome.excludePackages = (
    with pkgs;
    [
      gedit
      gnome-photos
      gnome-tour
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]
  );
  environment.systemPackages = with pkgs; [
    arc-theme
    autogen
    binutils
    breeze-icons
    capitaine-cursors
    cmake
    configure-gtk
    dive
    dnsutils
    dropbox
    evince
    ffmpegthumbnailer
    gcc
    git
    kitty
    eog
    gst_all_1.gstreamer
    gst_all_1.gst-vaapi
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    gnome-tweaks
    gnumake
    google-chrome
    nix-output-monitor
    nvd
    openssl
    okular
    papirus-icon-theme
    pavucontrol
    podman-compose
    podman-tui
    smplayer
    sqlite
    unzip
    usbutils
    vim
    xclip
    wget
    zip
  ];
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      cantarell-fonts
      eb-garamond
      fira-code
      liberation_ttf
      roboto
      (nerdfonts.override {
        fonts = [
          "SourceCodePro"
          "Meslo"
          "Noto"
        ];
      })
    ];
    fontconfig.enable = true;
  };
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = rec {
    LC_MONETARY = "en_IE.UTF-8";
    LC_TIME = LC_MONETARY;
  };
  imports = [
    ./hardware-configuration.nix
    ../../registry.nix
  ];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
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
        "@wheel"
      ];
    };
  };
  programs.adb.enable = true;
  programs.dconf.enable = true;
  programs.gamemode.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.hyprland.enable = true;
  programs.light.enable = true;
  programs.nh = {
    enable = true;
    flake = "/persist/home/${username}/.dotfiles";
  };
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      acpi
      alacritty
      brightnessctl
      dbus-sway-environment
      dracula-theme # gtk theme
      ffmpeg
      gammastep
      glib
      adwaita-icon-theme
      nautilus
      grim
      haruna
      kanshi
      mako
      mediainfo
      networkmanagerapplet
      ntfs3g
      slurp
      swayidle
      swaylock
      vimiv-qt
      waybar
      wayland
      wl-clipboard
      wlogout
      wdisplays
      wofi
      xdg-utils
      xfce.ristretto
      xwayland
    ];
    extraOptions = [ "--unsupported-gpu" ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DISABLE_RDD_SANDBOX=1
      export WLR_DRM_DEVICES="/dev/dri/card0:/dev/dri/card1"
    '';
    wrapperFeatures.gtk = true;
  };
  programs.tmux.enable = true;
  programs.virt-manager.enable = true;
  programs.xwayland.enable = true;
  programs.zsh.enable = true;
  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    pam.services.swaylock = { };
    pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never
      '';
    };
  };
  services = {
    blueman.enable = true;
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
        };
      };
    };
    # btrfs.autoScrub.enable = true;
    # btrbk = {
    #   instances."btrbk" = {
    #     onCalendar = "daily";
    #     settings = {
    #       timestamp_format = "long";
    #       snapshot_dir = "_snapshots";
    #       snapshot_preserve = "3d 1w 1m";
    #       snapshot_preserve_min = "2d";
    #       target_preserve = "1d 1w 1m";
    #       target_preserve_min = "latest";
    #       volume."/mnt/btrfs-data/" = {
    #         target = "/run/media/beto/seagate-backup/LEGION5";
    #         subvolume = {
    #           "arch/@home" = {
    #             snapshot_create = "always";
    #           };
    #         };
    #       };
    #     };
    #   };
    # };
    dbus.enable = true;
    displayManager = {
      defaultSession = "gnome";
      sddm = {
        autoLogin.relogin = true;
        enable = false;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "${username}";
      };
    };
    gvfs.enable = true;
    gnome.at-spi2-core.enable = true;
    libinput.enable = true;
    # pcscd.enable = true;
    pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      enable = true;
      pulse.enable = true;
    };
    # udev.extraRules = (builtins.readFile ./udev.rules);
    udev.packages = lib.lists.singleton (
      pkgs.writeTextFile {
        name = "qmk-rules";
        destination = "/etc/udev/rules.d/50-qmk.rules";
        text = builtins.readFile ./qmk.rules;
      }
    );
    xserver = {
      enable = true;
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };
      displayManager = {
        lightdm = {
          enable = false;
          greeter.enable = false;
        };
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      videoDrivers = [
        "displaylink"
        "nvidia"
      ];
      xkb.extraLayouts = {
        icydvorak = {
          description = "IcyDvorak";
          languages = [ "eng" ];
          symbolsFile = "${inputs.xkb.outPath}/linux/symbols/IcydDvorak.xkb";
        };
        engram = {
          description = "Engram";
          languages = [ "eng" ];
          symbolsFile = "${inputs.xkb.outPath}/linux/symbols/Engram.xkb";
        };
        icydengram = {
          description = "IcydEngram";
          languages = [ "eng" ];
          symbolsFile = "${inputs.xkb.outPath}/linux/symbols/IcydEngram.xkb";
        };
      };
    };
  };
  systemd.enableEmergencyMode = false;
  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
  systemd.services."systemd-backlight@backlight:ideapad".wantedBy = lib.mkForce [ ];
  system.stateVersion = "22.05";
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      ExecStart = "${pkgs.kanshi}/bin/kanshi -c kanshi_config_file";
      Type = "simple";
    };
  };
  time.timeZone = "Europe/Madrid";
  users = {
    extraGroups.vboxusers.members = [ "${username}" ];
    groups.${username}.gid = 1000;
    mutableUsers = false;
    users = {
      ${username} = {
        extraGroups = [
          "wheel"
          "${username}"
          "networkmanager"
          "video"
          "dialout"
          "libvirtd"
          "adbusers"
          "vboxusers"
        ];
        hashedPasswordFile = "/persist/passwords/${username}";
        isNormalUser = true;
        shell = pkgs.zsh;
        uid = 1000;
      };
      guest = {
        hashedPassword = "$y$j9T$ttfF0hwJU50Sgn5VgxD/J/$m27oLpo5xQTN/6Lzdulqj72GRFGX9ixLLN8q.I7LS25";
        isNormalUser = true;
      };
    };
  };
  virtualisation = {
    containers = {
      enable = true;
      storage.settings =
        let
          storagePath = "$HOME/.containers";
        in
        {
          storage = {
            driver = "btrfs";
            rootless_storage_path = storagePath;
          };
        };
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.unstable.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    virtualbox = {
      host = {
        enable = true;
        # addNetworkInterface = false;
        enableExtensionPack = true;
        # enableKvm = true;
      };
      # guest.enable = true;
    };
  };
}
