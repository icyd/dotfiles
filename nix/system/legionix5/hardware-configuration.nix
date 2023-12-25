{ config, lib, pkgs, modulesPath, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  boot = {
    blacklistedKernelModules = [ "nouveau" "intel" ];
    extraModulePackages = with config.boot.kernelPackages; [ evdi ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" ];
      kernelModules = [ "amdgpu" ];
      luks.devices."cryptroot".device =
        "/dev/disk/by-uuid/a1e85fe0-0d91-40c0-ba67-b784fe163998";
    };
    kernelParams = [ "ipv6.disable=1" ];
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        configurationLimit = 6;
        default = "5";
        device = "nodev";
        efiSupport = true;
        enable = true;
        extraEntries = ''
          menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os {
              load_video
              set gfxpayload=keep
              insmod gzio
              insmod part_gpt
              insmod fat
              search --no-floppy --fs-uuid --set=root 4ECB-CF02
              echo    'Loading Linux linux-lts ...'
              linux   /vmlinuz-linux-lts root=UUID=62abb064-54c0-4c02-b5f0-5ca57ee8004a rw rootflags=subvol=@ nvidia-drm.modeset=1 luks.name=a1e85fe0-0d91-40c0-ba67-b784fe163998=cryptroot luks.options=discard root=/dev/mapper/cryptroot quiet loglevel=4
              echo    'Loading initial ramdisk ...'
              initrd  /amd-ucode.img /initramfs-linux-lts.img
          }
        '';
        memtest86.enable = true;
        useOSProber = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
    tmp.useTmpfs = true;
  };
  environment.systemPackages = [ nvidia-offload ];
  hardware = {
    cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      prime = {
        reverseSync.enable = true;
        allowExternalGpu = false;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
      };
    };
  };
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=1G" "mode=775" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4ECB-CF02";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
      fsType = "btrfs";
      options = [ "subvol=nix/@home" "noatime" "compress=zstd" ];
    };
    "/mnt/btrfs-pool" = {
      device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
      fsType = "btrfs";
      options = [ "ssd" "noatime" "compress=zstd" ];
    };
    "/mnt/lutris" = {
      device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
      fsType = "btrfs";
      options = [ "subvol=@lutris" "noatime" "compress=zstd" "nodatacow" ];
    };
    "/mnt/win10" = {
      device = "/dev/disk/by-uuid/D096A4B796A49F88";
      fsType = "ntfs";
      options =
        [ "defaults" "users" "uid=1000" "gid=1000" "fmask=0022" "dmask=0022" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
      fsType = "btrfs";
      options = [ "subvol=nix/@nix" "noatime" "compress=zstd" ];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
      fsType = "btrfs";
      options = [ "subvol=nix/@persist" "noatime" "compress=zstd" ];
      neededForBoot = true;
    };
    "/persist/home" = {
      device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
      fsType = "btrfs";
      options = [ "subvol=@home" "noatime" "compress=zstd" ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
      fsType = "btrfs";
      options = [ "subvol=nix/@logs" "noatime" "compress=zstd" ];
      neededForBoot = true;
    };
  };
  networking.enableIPv6 = false;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  specialisation = {
    nvidia-sync-mode.configuration = {
      system.nixos.tags = [ "nvidia-sync-mode" ];
      hardware.nvidia.prime = {
        allowExternalGpu = lib.mkForce false;
        reverseSync.enable = lib.mkForce false;
        sync.enable = lib.mkForce true;
      };
    };
  };
  swapDevices = [ ];
}
