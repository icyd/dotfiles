{
  flake.modules.nixos.virtualisation = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      qemu
    ];
    programs.virt-manager.enable = true;
    virtualisation = {
      containers.enable = true;
      libvirtd.enable = true;
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      spiceUSBRedirection.enable = true;
    };
  };
  flake.modules.homeManager.virtualisation = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
