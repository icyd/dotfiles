{ config, pkgs, lib, username, stateVersion, ... }: {
    imports = [
        ./hardware-configuration.nix
    ];
    boot = {
        blacklistedKernelModules = [ "nouveau" "intel" ];
        initrd = {
            kernelModules = [ "amdgpu" ];
            postDeviceCommands = pkgs.lib.mkBefore ''
                mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
                mount -o subvol=/ /dev/mapper/cryptroot /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines
        #
        # I suspect these are related to systemd-nspawn, but
        # since I don't use it I'm not 100% sure.
        # Anyhow, deleting these subvolumes hasn't resulted
        # in any issues so far, except for fairly
        # benign-looking errors from systemd-tmpfiles.
                btrfs subvolume list -o /mnt/nix/@root |
                cut -f9 -d' ' |
                while read subvolume; do
                echo "deleting /$subvolume subvolume..."
                btrfs subvolume delete "/mnt/$subvolume"
                done &&
                echo "deleting /root subvolume..." &&
                btrfs subvolume delete /mnt/nix/@root

                echo "restoring blank /root subvolume..."
                btrfs subvolume snapshot /mnt/nix/@root-blank /mnt/nix/@root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
                umount /mnt
            '';
        };
        loader = {
            systemd-boot.enable = false;
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };
            grub = {
                enable = true;
                version = 2;
                device = "nodev";
                efiSupport = true;
                useOSProber = true;
                configurationLimit = 20;
            };
        };
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
    environment.etc = {
        nixos.source = "/persist/etc/nixos";
        "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
        adjtime.source = "/persist/etc/adjtime";
        NIXOS.source = "/persist/etc/NIXOS";
        machine-id.source = "/persist/etc/machine-id";
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
    };
    networking = {
        firewall.enable = true;
        hostName = "legionix5";
        interfaces.eno1.useDHCP = true;
        interfaces.wlp4s0.useDHCP = true;
        networkmanager.enable = true;
        # dhcpcd.extraConfig = "nohook resolv.conf";
        # networkmanager.dns = "none";
        # nameservers = [ "192.168.1.8" ];
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
        xserver = {
            enable = true;
            videoDrivers = [ "amdgpu" ];
            displayManager = {
                defaultSession = "sway";
                gdm = {
                    enable = true;
                    wayland = true;
                    autoSuspend = false;
                };
                autoLogin = {
                    enable = true;
                    user = "${username}";
                };
            };
            libinput.enable = true;
        };
        udev.extraRules = (builtins.readFile ./udev.rules);
    };
    sound.enable = true;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    users = {
        mutableUsers = true;
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
            ]; # Enable ‘sudo’ for the user.
            initialHashedPassword = "$6$wxp/3sRBcMHx3fsm$vWVUshizSk1XaZS7gHPKy2NF.LHd.iMZ/o3Ipx0aKWs4Q3GiiPPAf1Abe9Flt7TAdcsTvDlbn5eTYhIzxOa/5/";
            # passwordFile = "/persist/beto.pass";
        };
    };
    time.timeZone = "Europe/Madrid";
    programs.adb.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };
    # programs.qt5ct.enable = true;
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
