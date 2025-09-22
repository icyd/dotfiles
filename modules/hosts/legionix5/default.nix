{
  lib,
  inputs,
  ...
} @ flakeAttrs: let
  users =
    flakeAttrs.config.flake.modules.nixos
    |> lib.getAttrs ["users/beto" "users/guest"]
    |> lib.attrValues;
  inherit (flakeAttrs.config.flake.meta.users.${flakeAttrs.config.flake.meta.hosts.legionix5.user}) username;
in {
  nixpkgs.allowedUnfreePackages = [
    "displaylink"
  ];
  flake.meta.hosts.legionix5 = {
    user = "beto";
    system = "x86_64-linux";
  };
  flake.modules.nixos."hosts/legionix5" = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs;
      [
        autogen
        binutils
        cmake
        dnsutils
        eog
        evince
        ffmpeg
        ffmpegthumbnailer
        gcc
        glib
        gnumake
        home-manager
        kitty
        mediainfo
        ntfs3g
        openssl
        pinentry-gnome3
        smplayer
        sqlite
        usbutils
        vimiv-qt
      ]
      ++ (with pkgs.gst_all_1; [
        gstreamer
        gst-vaapi
        gst-plugins-base
        gst-plugins-good
        gst-plugins-ugly
        gst-plugins-bad
      ]);
    # home.packages = with pkgs; [
    #     dropbox
    # ];
    networking.hostId = "e4521109";
    system.stateVersion = "22.05";
    facter.reportPath = ./facter.json;
    fileSystems = {
      "/home/${username}/win11shared" = {
        device = "/dev/disk/by-label/data";
        fsType = "exfat";
        options = ["rw" "nofail" "uid=${builtins.toString config.users.users.${username}.uid}"];
      };
      "/home/${username}/.local/share/containers" = {
        fsType = "zfs";
        device = "rpool/local/containers";
      };
      "/home/${username}/.virtualmachines" = {
        fsType = "zfs";
        device = "rpool/local/virtualmachines";
      };
    };
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
        rocmPackages.clr.icd
      ];
    };
    nix.settings.trusted-users = [username];
    programs = {
      adb.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = false;
      };
      seahorse.enable = true;
    };
    services = {
      displayManager.autoLogin = {
        enable = true;
        user = username;
      };
      gnome = {
        gnome-keyring.enable = true;
      };
      logind = {
        lidSwitch = "suspend-then-hibernate";
        powerKey = "hibernate";
        powerKeyLongPress = "poweroff";
      };
      pcscd.enable = true;
      power-profiles-daemon.enable = true;
      udev.packages =
        {
          name = "qmk-rules";
          destination = "/etc/udev/rules.d/50-qmk.rules";
          text = builtins.readFile ./qmk.rules;
        }
        |> pkgs.writeTextFile
        |> lib.singleton;
      xserver = {
        # videoDrivers = [
        #   "displaylink"
        # ];
        xkb = {
          layout = "us";
          variant = "altgr-intl";
          options = "lv3:ralt_switch,shift:breaks_caps,grp:alt_space_toggle";
        };
      };
      zfs = {
        autoScrub.enable = true;
        autoSnapshot = {
          enable = true;
          flags = "-k -p -u";
        };
        trim.enable = true;
      };
    };
    security.pam.services.ssdm.enableGnomeKeyring = true;
    sops = {
      age.keyFile = "/persist/legionix5_age_key.txt";
      age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
      defaultSopsFile = "${inputs.nix-secrets.outPath}/personal/legionix5.yaml";
      secrets = {
        "passwords/beto" = {
          neededForUsers = true;
        };
        "passwords/guest" = {
          neededForUsers = true;
        };
      };
    };
    systemd = {
      enableEmergencyMode = false;
      services."systemd-backlight@backlight:ideapad".wantedBy = lib.mkForce [];
      sleep.extraConfig = ''
        HibernateDelaySec=30m
        SuspendState=mem
      '';
    };
    imports = with flakeAttrs.config.flake.modules.nixos;
      [
        audio
        base
        bluetooth
        desktop
        disko
        dnscrypt-proxy2
        efi
        facter
        hyprland
        # lanzaboote
        nvidia
        sops
        steam
        systemd-boot
        virtualisation
        ./_disko.nix
      ]
      ++ users;
  };
}
