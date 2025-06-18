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
        };
      };
      kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = lib.mkForce true;
        "net.ipv6.conf.all.forwarding" = lib.mkForce true;
      };
      kernelParams = [
        "acpi_backlight=native"
        "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1"
      ];
      loader = {
        grub = {
          enable = true;
          configurationLimit = 12;
          device = "nodev";
          memtest86.enable = true;
          useOSProber = true;
        };
      };
      tmp.useTmpfs = true;
    };
  };
}
