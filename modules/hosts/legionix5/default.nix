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
  flake.modules.nixos."hosts/legionix5" = {pkgs, ...}: {
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
        mediainfo
        ntfs3g
        openssl
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
    # networking.hostId = "042f252a";
    system.stateVersion = "22.05";
    facter.reportPath = ./facter.json;
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
        enableSSHSupport = true;
      };
    };
    services = {
      displayManager.autoLogin = {
        enable = true;
        user = username;
      };
      pcscd.enable = true;
      udev.packages =
        {
          name = "qmk-rules";
          destination = "/etc/udev/rules.d/50-qmk.rules";
          text = builtins.readFile ./qmk.rules;
        }
        |> pkgs.writeTextFile
        |> lib.singleton;
      xserver = {
        videoDrivers = [
          "displaylink"
        ];
        xkb = {
          layout = "us";
          variant = "altgr-intl";
          options = "lv3:ralt_switch,shift:breaks_caps,grp:alt_space_toggle";
        };
      };
      # zfs = {
      #   autoScrub.enable = true;
      #   trim.enable = true;
      # };
    };
    sops = {
      defaultSopsFile = "${inputs.nix-secrets.outPath}/legionix5.yaml";
      age.keyFile = "/persist/home/${username}/.config/sops/age/keys.txt";
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
    };
    imports = with flakeAttrs.config.flake.modules.nixos;
      [
        audio
        base
        bluetooth
        desktop
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
      ]
      ++ users;
  };
}
