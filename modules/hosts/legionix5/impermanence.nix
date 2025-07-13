{
  lib,
  inputs,
  ...
}: {
  flake.modules.nixos."hosts/legionix5" = {config, ...}: let
    regularSecrets =
      config.sops.secrets
      |> lib.filterAttrs (_name: value: !value.neededForUsers);
  in {
    environment.persistence."/persist" = {
      directories = [
        "/etc/nixos"
        "/var/lib/bluetooth"
        "/var/lib/systemd/coredump"
        "/var/lib/libvirt/"
        "/var/lib/nixos"
        "/var/lib/sbctl"
        "/var/lib/iwd"
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
    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];
    systemd.tmpfiles.rules = [
      "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    ];
    system.activationScripts.setupSecrets = lib.mkIf (regularSecrets != {}) {
      deps = ["persist-files"];
    };
  };
}
