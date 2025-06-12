{
  pkgs,
  lib,
  username,
  ...
}: let
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      /* gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
in {
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  documentation.man.generateCaches = true;
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${username}/.steam/root/compatibilitytools.d";
  };
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    arc-theme
    autogen
    binutils
    capitaine-cursors
    cmake
    configure-gtk
    dive
    dnsutils
    dropbox
    evince
    ffmpeg
    ffmpegthumbnailer
    gcc
    git
    eog
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-vaapi
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    kdePackages.breeze-icons
    kdePackages.okular
    gnumake
    google-chrome
    mangohud
    mediainfo
    networkmanagerapplet
    nautilus
    nix-output-monitor
    ntfs3g
    nvd
    openssl
    papirus-icon-theme
    pavucontrol
    podman-compose
    podman-tui
    protonup
    sddm-astronaut
    smplayer
    sqlite
    unzip
    usbutils
    vim
    vimiv-qt
    xclip
    xdg-utils
    xfce.ristretto
    wget
    zip
  ];
  fonts = {
    enableDefaultPackages = true;
    packages =
      (with pkgs; [
        cantarell-fonts
        eb-garamond
        fira-code
        liberation_ttf
        roboto
      ])
      ++ (with pkgs.nerd-fonts; [
        anonymice
        meslo-lg
        noto
        sauce-code-pro
      ]);
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
    ../../modules/gnome.nix
    ../../modules/hyprland.nix
    ../../modules/stylix.nix
    # ../../modules/sway.nix
    ../../modules/virtualisation.nix
  ];
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes pipe-operators
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixVersions.stable;
    settings = {
      download-buffer-size = 536870912;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  programs.adb.enable = true;
  programs.gamemode.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nh = {
    enable = true;
    flake = "/persist/home/${username}/.dotfiles";
  };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.xwayland.enable = true;
  programs.zsh.enable = true;
  security = {
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
      enable = false;
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never
      '';
    };
    sudo-rs.enable = true;
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
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        extraPackages = [pkgs.sddm-astronaut];
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
      };
      autoLogin = {
        enable = true;
        user = username;
      };
    };
    gvfs.enable = true;
    kmonad = {
      enable = true;
      keyboards = {
        myKMonadOutput = {
          device = "/dev/input/by-id/usb-ITE_Tech._Inc._ITE_Device_8910_-event-kbd";
          defcfg = {
            enable = true;
            fallthrough = true;
          };
          config = builtins.readFile ../../../kmonad/legion5.kbd;
        };
      };
    };
    libinput.enable = true;
    # pcscd.enable = true;
    pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      enable = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false;
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
          greeter.enable = true;
        };
        gdm = {
          enable = false;
          wayland = true;
        };
      };
      videoDrivers = [
        "displaylink"
        "nvidia"
      ];
      xkb = {
        layout = "us";
        variant = "altgr-intl";
        options = "lv3:ralt_switch,shift:breaks_caps,grp:alt_space_toggle";
      };
    };
  };
  systemd.enableEmergencyMode = false;
  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
  systemd.services."systemd-backlight@backlight:ideapad".wantedBy = lib.mkForce [];
  system.stateVersion = "22.05";
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
  time.timeZone = "Europe/Madrid";
  users = {
    groups.${username}.gid = 1000;
    mutableUsers = false;
    users = {
      ${username} = {
        extraGroups = [
          "wheel"
          "${username}"
          "input"
          "uinput"
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
}
