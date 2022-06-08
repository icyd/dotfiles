{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    blacklistedKernelModules = [ "nouveau" "intel" ];
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
      };
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
    fsType = "btrfs";
    options = [ "subvol=nix/@root" "noatime" "compress=zstd" ];
  };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/a1e85fe0-0d91-40c0-ba67-b784fe163998";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
    fsType = "btrfs";
    options = [ "subvol=@home" "noatime" "compress=zstd" ];
  };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
    fsType = "btrfs";
    options = [ "subvol=nix/@nix" "noatime" "compress=zstd" ];
  };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
    fsType = "btrfs";
    options = [ "subvol=nix/@persist" "noatime" "compress=zstd" ];
  };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
    fsType = "btrfs";
    options = [ "subvol=nix/@logs" "noatime" "compress=zstd" ];
    neededForBoot = true;
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/52A4-44E6";
    fsType = "vfat";
  };

  swapDevices = [ ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
