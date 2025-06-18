{
  lib,
  config,
  ...
}: let
  users =
    config.flake.modules.nixos
    |> lib.getAttrs ["users/beto" "users/guest"]
    |> lib.attrValues;
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
        kdePackages.okular
        mediainfo
        nautilus
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
        user = config.flake.meta.users.beto.username;
      };
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
    };
    systemd = {
      enableEmergencyMode = false;
      services."systemd-backlight@backlight:ideapad".wantedBy = lib.mkForce [];
    };
    imports = with config.flake.modules.nixos;
      [
        base
        bluetooth
        desktop
        dnscrypt-proxy2
        efi
        facter
        hyprland
        nvidia
        steam
      ]
      ++ users;
  };
}
