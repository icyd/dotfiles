{config, ...}: {
  flake.modules.nixos."hosts/legionix5" = {pkgs, ...}: let
    inherit (config.flake.meta.users.beto) username;
  in {
    imports = [config.flake.modules.nixos.virtualisation];
    boot.initrd.kernelModules = ["kvm-amd"];
    environment.systemPackages = with pkgs; [
      dive
      docker-compose
      podman-tui
      podman-compose
    ];
    users.groups.libvirtd.members = [username];
    virtualisation.containers.storage.settings = {
      driver = "btrfs";
      rootless_storage_path = "$HOME/.containers";
    };
  };
}
