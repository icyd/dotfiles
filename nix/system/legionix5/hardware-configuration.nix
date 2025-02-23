{
  config,
  lib,
  pkgs,
  username,
  modulesPath,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  nvme0n1p2 = "a1e85fe0-0d91-40c0-ba67-b784fe163998";
  cryptroot = "62abb064-54c0-4c02-b5f0-5ca57ee8004a";
  # nvme1n1p2 = "c432588b-cfa3-448a-86ff-546936cc6eff";
  # cryptdata = "a0330967-771a-4303-9750-172d571dee0c";
  veracryptdata = "3251-F49B";
  # bootDrive = "5610-7908";
  bootDrive = "12D2-6261";
in {
  boot = {
    blacklistedKernelModules = [
      "nouveau"
      "intel"
    ];
    extraModulePackages = with config.boot.kernelPackages; [evdi];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "ahci"
        "usbhid"
      ];
      kernelModules = [
        "amdgpu"
      ];
      luks.devices."cryptroot" = {
        device = "/dev/disk/by-uuid/${nvme0n1p2}";
        allowDiscards = true;
      };
      postDeviceCommands = lib.mkAfter ''
        mkdir -p /mnt
        mount /dev/disk/by-uuid/"${cryptroot}" /mnt
        if [ -e "/mnt/@root_tmp" ]; then
          mkdir -p /mnt/old_roots
          timestamp=$(date --date="@$(stat -c %Y /mnt/@root_tmp)" "+%Y-%m-%-d_%H:%M:%S")
          mv /mnt/@root_tmp "/mnt/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/mnt/$i"
            done
            printf "Deleting subvolume %s\n" "$1"
            btrfs subvolume delete "$1"
        }

        TMP="$(mktemp)"
        trap  'rm "$TMP"' EXIT
        find /mnt/old_roots -maxdepth 1 -mtime +30 > "$TMP"
        while IFS= read -r i; do
            printf "Deleting old root %s\n" "$i"
            delete_subvolume_recursively "$i"
        done < "$TMP"

        btrfs subvolume create /mnt/@root_tmp
        umount /mnt
      '';
      # systemd.enable = false;
      supportedFilesystems = {
        ntfs = true;
      };
    };
    kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
    kernelParams = [
      "acpi_backlight=native"
      "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1"
    ];
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        configurationLimit = 12;
        # default = "5";
        device = "nodev";
        efiSupport = true;
        enable = true;
        # extraEntries = ''
        #   menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os {
        #       load_video
        #       set gfxpayload=keep
        #       insmod gzio
        #       insmod part_gpt
        #       insmod fat
        #       search --no-floppy --fs-uuid --set=root 4ECB-CF02
        #       echo    'Loading Linux linux-lts ...'
        #       linux   /vmlinuz-linux-lts root=UUID=${cryptroot} rw rootflags=subvol=arch/@ nvidia-drm.modeset=1 luks.name=${nvme0n1p2}=cryptroot luks.options=discard root=/dev/mapper/cryptroot quiet loglevel=4
        #       echo    'Loading initial ramdisk ...'
        #       initrd  /amd-ucode.img /initramfs-linux-lts.img
        #   }
        # '';
        memtest86.enable = true;
        useOSProber = true;
      };
    };
    tmp.useTmpfs = true;
  };
  environment.systemPackages = [nvidia-offload];
  # environment.etc.crypttab.text = ''
  #   cryptdata UUID=${nvme1n1p2} /legion5_skhynix.key discard
  # '';
  environment.etc.crypttab.text = ''
    cryptdata /dev/nvme1n1p5 /legionix5_veracrypt.pwd discard,tcrypt-veracrypt,tcrypt-keyfile=/legionix5_veracrypt.key
  '';
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/var/lib/libvirt/"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/adjtime"
      "/legion5_skhynix.key"
      "/legionix5_veracrypt.key"
      "/legionix5_veracrypt.pwd"
    ];
    hideMounts = true;
  };

  hardware = {
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      prime = {
        reverseSync.enable = true;
        allowExternalGpu = false;
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
        rocmPackages.clr.icd
      ];
    };
    pulseaudio.enable = false;
  };
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=@root_tmp"
        "ssd"
        "noatime"
        "compress=zstd"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/${bootDrive}";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd"
      ];
    };
    "/mnt/btrfs-pool" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "ssd"
        "noatime"
        "compress=zstd"
      ];
    };
    # "/mnt/btrfs-data" = {
    #   device = "/dev/disk/by-uuid/${cryptdata}";
    #   fsType = "btrfs";
    #   options = [
    #     "ssd"
    #     "noatime"
    #     "compress=zstd"
    #   ];
    # };
    "/mnt/nodatacow" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=@nodatacow"
        "noatime"
        "compress=zstd"
        "nodatacow"
      ];
    };
    # "/mnt/win10" = {
    #   device = "/dev/disk/by-uuid/D096A4B796A49F88";
    #   fsType = "ntfs";
    #   options =
    #     [ "defaults" "users" "uid=1000" "gid=1000" "fmask=0022" "dmask=0022" ];
    # };
    "/nix" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=nix/@nix"
        "noatime"
        "compress=zstd"
      ];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=nix/@persist"
        "noatime"
        "compress=zstd"
      ];
      neededForBoot = true;
    };
    "/home/${username}/.containers" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=@containers"
        "noatime"
        "compress=zstd"
        "nodatacow"
      ];
    };
    "/persist/home" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=@data"
        "noatime"
        "compress=zstd"
      ];
    };
    "/persist/data" = {
      device = "/dev/disk/by-uuid/${veracryptdata}";
      fsType = "exfat";
      options = [
        "defaults"
        "users"
        "uid=1000"
        "gid=1000"
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/${cryptroot}";
      fsType = "btrfs";
      options = [
        "subvol=nix/@logs"
        "noatime"
        "compress=zstd"
      ];
      neededForBoot = true;
    };
  };
  networking = {
    bridges.br0.interfaces = ["eno1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    enableIPv6 = true;
    firewall = {
      enable = false;
      checkReversePath = "loose";
    };
    hostName = "legionix5";
    interfaces.eno1.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;
    nameservers = [
      "208.67.222.222"
      "208.67.220.220"
    ];
    nat.enable = true;
    nat.enableIPv6 = true;
    nftables.enable = true;
    networkmanager.enable = true;
    networkmanager.dns = "none";
    resolvconf.dnsExtensionMechanism = false;
    useDHCP = false;
  };
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  specialisation = {
    nvidia-sync-mode.configuration = {
      environment.etc."specialisation".text = "nvidia-sync-mode";
      hardware.nvidia.prime = {
        allowExternalGpu = lib.mkForce false;
        reverseSync.enable = lib.mkForce false;
        sync.enable = lib.mkForce true;
        offload.enable = lib.mkForce false;
      };
      system.nixos.tags = ["nvidia-sync-mode"];
    };
  };
  swapDevices = [];
}
