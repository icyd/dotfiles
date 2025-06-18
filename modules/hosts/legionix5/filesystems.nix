{
  lib,
  config,
  ...
}: let
  host = "legionix5";
in {
  flake.modules.nixos."hosts/${host}" = let
    bootDrive = "12D2-6261";
    cryptroot = "62abb064-54c0-4c02-b5f0-5ca57ee8004a";
    nvme0n1p2 = "a1e85fe0-0d91-40c0-ba67-b784fe163998";
    veracryptdata = "3251-F49B";
    inherit (config.flake.meta.users.${config.flake.meta.hosts.${host}.user}) username;
  in {
    boot.initrd = {
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
    };
    environment.etc.crypttab.text = ''
      cryptdata /dev/nvme1n1p5 /legionix5_veracrypt.pwd discard,tcrypt-veracrypt,tcrypt-keyfile=/legionix5_veracrypt.key
    '';
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
  };
}
