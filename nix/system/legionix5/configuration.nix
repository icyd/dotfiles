{ config, pkgs, lib, username, stateVersion, ... }: {
    imports = [
        ./hardware-configuration.nix
    ];
    boot = {
        blacklistedKernelModules = [ "nouveau" "intel" ];
        initrd = {
            kernelModules = [ "amdgpu" ];
            # postDeviceCommands = pkgs.lib.mkBefore ''
            #     mkdir -p /mnt
            #     mount -o subvol=/ /dev/mapper/cryptroot /mnt
            #     btrfs subvolume list -o /mnt/nix/@root |
            #     cut -f9 -d' ' |
            #     while read subvolume; do
            #     echo "deleting /$subvolume subvolume..."
            #     btrfs subvolume delete "/mnt/$subvolume"
            #     done &&
            #     echo "deleting /root subvolume..." &&
            #     btrfs subvolume delete /mnt/nix/@root
            #
            #     echo "restoring blank /root subvolume..."
            #     btrfs subvolume snapshot /mnt/nix/@root-blank /mnt/nix/@root
            #     umount /mnt
            # '';
        };
        tmpOnTmpfs = true;
    };
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };
    fonts = {
        enableDefaultFonts = true;
        fonts = with pkgs; [
            eb-garamond
            fira-code
            liberation_ttf
            noto-fonts
            roboto
            (nerdfonts.override { fonts = [ "SourceCodePro" "Meslo" ]; })
        ];
        fontconfig.enable = true;
    };
    environment.persistence."/persist" = {
        hideMounts = true;
        files = [
            "/etc/machine-id"
            "/etc/adjtime"
        ];
        directories = [
            "/etc/nixos"
            "/etc/NetworkManager/system-connections"
        ];
    };
    environment.systemPackages = with pkgs; [
        binutils
        dnsutils
        evince
        gcc
        gnumake
        google-chrome
        cmake
        autogen
        sqlite
        ffmpegthumbnailer
        git
        gst_all_1.gstreamer
        gst_all_1.gst-vaapi
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-plugins-bad
        firefox
        arc-theme
        papirus-icon-theme
        capitaine-cursors
        openssl
        breeze-icons
        nextcloud-client
        pavucontrol
        okular
        smplayer
        unzip
        usbutils
        wget
        vim
        zip
    ];
    i18n.defaultLocale = "en_US.UTF-8";
    hardware = {
        bluetooth.enable = true;
        enableAllFirmware = true;
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
            extraPackages = with pkgs; [
                vaapiVdpau
                libvdpau-va-gl
                rocm-opencl-icd
                rocm-opencl-runtime
            ];
        };
        pulseaudio.enable = true;
        # nvidia.prime = {
        #     offload.enable = true;
        #     nvidiaBusId = "PCI:1:0:0";
        #     amdgpuBusId = "PCI:6:0:0";
        # };
    };
    networking = {
        firewall.enable = true;
        hostName = "legionix5";
        interfaces.eno1.useDHCP = true;
        interfaces.wlp4s0.useDHCP = true;
        networkmanager.enable = true;
        networkmanager.dns = "none";
        resolvconf.dnsExtensionMechanism = false;
        dhcpcd.extraConfig = "nohook resolv.conf";
        nameservers = [ "192.168.1.8" ];
        # nameservers = [ "127.0.0.1" "::1" ];
        useDHCP = false;
    };
    nix = {
        package = pkgs.nixFlakes;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
        };
    };
    services = {
        blueman.enable = true;
        gvfs.enable = true;
        gnome.at-spi2-core.enable = true;
        xserver = {
            enable = true;
            videoDrivers = [ "amdgpu" ];
            displayManager = {
                defaultSession = "sway";
                lightdm = {
                    enable = true;
                    greeter.enable = false;
                    autoLogin.timeout = 0;
                    # wayland = true;
                    # autoSuspend = false;
                };
                autoLogin = {
                    enable = true;
                    user = "${username}";
                };
            };
            libinput.enable = true;
        };
        udev.extraRules = (builtins.readFile ./udev.rules);
        dnscrypt-proxy2 = {
          enable = true;
          settings = {
            ipv6_servers = true;
            require_dnssec = true;

            sources.public-resolvers = {
              urls = [
                "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
              ];
              cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            };

            # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
            # server_names = [ ... ];
          };
        };
    };

    systemd.services.dnscrypt-proxy2.serviceConfig = {
      StateDirectory = "dnscrypt-proxy";
    };

    sound.enable = true;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    users = {
        mutableUsers = false;
        groups.${username}.gid = 1000;
        users.${username} = {
            isNormalUser = true;
            uid = 1000;
            shell = pkgs.zsh;
            extraGroups = [
                "wheel"
                "${username}"
                "networkmanager"
                "video"
                "dialout"
                "adbusers"
            ];
            passwordFile = "/persist/passwords/${username}";
        };
    };
    time.timeZone = "Europe/Madrid";
    programs.adb.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };
    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
            acpi
            alacritty
            brightnessctl
            swaylock
            swayidle
            ffmpeg
            gammastep
            gnome.nautilus
            haruna
            kanshi
            mako
            mediainfo
            networkmanagerapplet
            vimiv-qt
            xfce.ristretto
            xwayland
            waybar
            wlogout
            wl-clipboard
            wofi
        ];
        extraSessionCommands = ''
            export SDL_VIDEODRIVER=wayland
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
            export _JAVA_AWT_WM_NONREPARENTING=1
            export MOZ_ENABLE_WAYLAND=1
            export MOZ_DISABLE_RDD_SANDBOX=1
        '';
    };
    programs.tmux.enable = true;
    programs.xwayland.enable = true;
    programs.zsh.enable = true;
    security = {
        sudo.extraConfig = ''
            # rollback results in sudo lectures after each reboot
            Defaults lecture = never
        '';
        pam.services.gdm.enableGnomeKeyring = true;
    };
    system.stateVersion = stateVersion;
    systemd.tmpfiles.rules = [
        "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
        "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
        "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    ];
}
