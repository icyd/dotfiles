{ config, pkgs, lib, username, stateVersion, ... }:
let
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
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
in {
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  environment.persistence."/persist" = {
    directories = [ "/etc/nixos" "/etc/NetworkManager/system-connections" ];
    files = [ "/etc/machine-id" "/etc/adjtime" ];
    hideMounts = true;
  };
  environment.systemPackages = with pkgs; [
    arc-theme
    autogen
    binutils
    breeze-icons
    capitaine-cursors
    cmake
    configure-gtk
    dnsutils
    dropbox
    evince
    firefox
    ffmpegthumbnailer
    gcc
    git
    gst_all_1.gstreamer
    gst_all_1.gst-vaapi
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    gnumake
    google-chrome
    openssl
    okular
    papirus-icon-theme
    pavucontrol
    smplayer
    sqlite
    unzip
    usbutils
    vim
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
      (nerdfonts.override { fonts = [ "SourceCodePro" "Meslo" "Noto" ]; })
    ];
    fontconfig.enable = true;
  };
  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      enable = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        rocm-opencl-icd
        rocm-opencl-runtime
        vaapiVdpau
      ];
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
  imports = [ ./hardware-configuration.nix ];
  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    firewall.enable = true;
    hostName = "legionix5";
    interfaces.eno1.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;
    nameservers = [ "208.67.222.222" "208.67.220.220" ];
    networkmanager.enable = true;
    networkmanager.dns = "none";
    resolvconf.dnsExtensionMechanism = false;
    useDHCP = false;
  };
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixFlakes;
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  programs.adb.enable = true;
  programs.gamemode.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.light.enable = true;
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
      gnome3.adwaita-icon-theme
      gnome.nautilus
      grim
      haruna
      kanshi
      mako
      mediainfo
      networkmanagerapplet
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
  programs.xwayland.enable = true;
  programs.zsh.enable = true;
  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    pam.services.swaylock = { };
    pam.loginLimits = [{
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }];
    sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';
  };
  services = {
    blueman.enable = true;
    # dnscrypt-proxy2 = {
    #   enable = true;
    #   settings = {
    #     ipv6_servers = true;
    #     require_dnssec = true;
    #     sources.public-resolvers = {
    #       cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
    #       minisign_key =
    #         "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
    #       urls = [
    #         "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
    #         "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
    #       ];
    #     };
    #   };
    # };
    btrbk = {
      instances."btrbk" = {
        onCalendar = "daily";
        settings = {
          timestamp_format = "long";
          snapshot_dir = "_snapshots";
          snapshot_preserve = "3d 1w 1m";
          snapshot_preserve_min = "2d";
          target_preserve = "1d 1w 1m";
          target_preserve_min = "latest";
          volume."/mnt/btrfs-pool/" = {
            target = "/run/media/beto/seagate-backup/LEGION5";
            subvolume = { "@home" = { snapshot_create = "always"; }; };
          };
        };
      };
    };
    dbus.enable = true;
    gvfs.enable = true;
    gnome.at-spi2-core.enable = true;
    pipewire = {
      alsa.enable = true;
      enable = true;
      pulse.enable = true;
    };
    udev.extraRules = (builtins.readFile ./udev.rules);
    xserver = {
      enable = true;
      desktopManager = { xterm.enable = false; };
      displayManager = {
        defaultSession = "sway";
        lightdm = {
          enable = false;
          greeter.enable = false;
        };
        sddm = {
          autoLogin.relogin = true;
          enable = true;
          wayland.enable = true;
        };
        autoLogin = {
          enable = true;
          user = "${username}";
        };
      };
      libinput.enable = true;
      videoDrivers = [ "displaylink" "nvidia" ];
    };
  };
  sound.enable = true;
  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
  system.stateVersion = stateVersion;
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
    groups.${username}.gid = 1000;
    mutableUsers = false;
    users.${username} = {
      extraGroups = [
        "wheel"
        "${username}"
        "networkmanager"
        "video"
        "dialout"
        "plugdev"
        "adbusers"
      ];
      hashedPasswordFile = "/persist/passwords/${username}";
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1000;
    };
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
