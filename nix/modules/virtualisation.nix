{
  config,
  pkgs,
  username,
  ...
}:
{
  boot.initrd.kernelModules = config.boot.kernelModules ++ [
    "kvm-amd"
  ];
  environment.systemPackages = with pkgs; [
    qemu
  ];
  users.extraGroups.vboxusers.members = [ username ];
  users.groups.libvirtd.members = [ username ];
  programs.virt-manager.enable = true;
  virtualisation = {
    containers = {
      enable = true;
      storage.settings =
        let
          storagePath = "$HOME/.containers";
        in
        {
          storage = {
            driver = "btrfs";
            rootless_storage_path = storagePath;
          };
        };
    };
    libvirtd.enable = true;
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    spiceUSBRedirection.enable = true;
    virtualbox = {
      host = {
        enable = true;
        # addNetworkInterface = false;
        enableExtensionPack = true;
        # enableKvm = true;
      };
      # guest.enable = true;
    };
  };
}
