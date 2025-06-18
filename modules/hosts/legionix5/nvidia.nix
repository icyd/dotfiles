{lib, ...}: {
  flake.modules.nixos."hosts/legionix5" = {config, ...}: {
    boot = {
      blacklistedKernelModules = ["nouveau"];
      kernelParams = [
        "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1"
      ];
    };
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      prime = {
        reverseSync.enable = true;
        allowExternalGpu = false;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
      };
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
  };
}
