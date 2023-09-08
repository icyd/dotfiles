{ config, lib, pkgs, modulesPath, ... }: let
    nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
    '';
in {
    environment.systemPackages = [ nvidia-offload ];

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
                configurationLimit = 12;
                memtest86.enable = true;
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
            };
        };
        supportedFilesystems = [ "ntfs" ];
    };

    boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/a1e85fe0-0d91-40c0-ba67-b784fe163998";

    fileSystems."/" = {
        device = "none";
        fsType = "tmpfs";
        options = [
            "defaults"
            "size=1G"
            "mode=775"
        ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
        fsType = "btrfs";
        options = [ "subvol=nix/@home" "noatime" "compress=zstd" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
        fsType = "btrfs";
        options = [ "subvol=nix/@nix" "noatime" "compress=zstd" ];
    };

    fileSystems."/persist" = {
        device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
        fsType = "btrfs";
        options = [ "subvol=nix/@persist" "noatime" "compress=zstd" ];
        neededForBoot = true;
    };

    fileSystems."/persist/home" = {
        device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
        fsType = "btrfs";
        options = [ "subvol=@home" "noatime" "compress=zstd" ];
    };

    fileSystems."/var/log" = {
        device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
        fsType = "btrfs";
        options = [ "subvol=nix/@logs" "noatime" "compress=zstd" ];
        neededForBoot = true;
    };

    fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/4ECB-CF02";
            fsType = "vfat";
        };

        fileSystems."/mnt/btrfs-pool" = {
            device = "/dev/disk/by-uuid/62abb064-54c0-4c02-b5f0-5ca57ee8004a";
            fsType = "btrfs";
            options = [ "ssd" "noatime" "compress=zstd" ];
        };

        fileSystems."/mnt/win10" = {
            device = "/dev/disk/by-uuid/D096A4B796A49F88";
            fsType = "ntfs";
            options = [ "defaults" "users" "uid=1000" "gid=1000" "fmask=0022" "dmask=0022"];
        };

        swapDevices = [];

        powerManagement = {
            enable = true;
            cpuFreqGovernor = lib.mkDefault "powersave";
        };

        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        # hardware.nvidia.modesetting.enable = true;

        # specialisation = {
        #     external-display.configuration = {
        #         system.nixos.tags = [ "external-display" ];
        #         hardware.nvidia.prime.offload.enable = lib.mkForce false;
        #         hardware.nvidia.powerManagement.enable = lib.mkForce false;
        #     };
        # };
}
