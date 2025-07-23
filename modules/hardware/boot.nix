{
  lib,
  config,
  inputs,
  ...
}: let
  configurationLimit = 10;
in {
  flake.modules.nixos = {
    efi = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        efivar
        efitools
        efibootmgr
      ];
      boot.loader = {
        efi.canTouchEfiVariables = true;
        grub.efiSupport = config.boot.loader.grub.enable or false;
      };
    };
    grub = {
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.grub = {
        inherit configurationLimit;
        enable = true;
        device = "nodev";
        memtest86.enable = true;
        useOSProber = true;
      };
    };
    systemd-boot = {
      boot.loader.grub.enable = lib.mkForce false;
      boot.loader.systemd-boot = {
        inherit configurationLimit;
        enable = true;
        # edk2-uefi-shell.enable = true;
        memtest86.enable = true;
      };
    };
    lanzaboote = {pkgs, ...}: {
      imports = lib.optional (inputs.lanzaboote.nixosModules ? lanzaboote) inputs.lanzaboote.nixosModules.lanzaboote;
      boot.loader.grub.enable = lib.mkForce false;
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
      environment.systemPackages = with pkgs; [
        sbctl
      ];
    };
  };
}
