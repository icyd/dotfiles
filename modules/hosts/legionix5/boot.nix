{lib, ...}: {
  flake.modules.nixos."hosts/legionix5" = _: {
    boot = {
      blacklistedKernelModules = [
        "nouveau"
        "intel"
      ];
      # extraModulePackages = with config.boot.kernelPackages; [evdi];
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
        supportedFilesystems = {
          ntfs = true;
          exfat = true;
          zfs = true;
        };
      };
      kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = lib.mkForce true;
        "net.ipv6.conf.all.forwarding" = lib.mkForce true;
      };
      kernelParams = [
        "acpi_backlight=native"
        "mem_sleep_default=deep"
        "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1"
      ];
      loader.systemd-boot.windows = {
        win = {
          title = "Windows11";
          efiDeviceHandle = "HD1b";
        };
      };
      resumeDevice = "/dev/disk/by-partlabel/disk-samsungEvo-swap";
      tmp.useTmpfs = true;
    };
  };
}
