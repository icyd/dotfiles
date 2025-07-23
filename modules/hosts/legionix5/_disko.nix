{
  disko.devices = {
    disk = {
      samsungEvo = {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S58SNM0R512937X";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "2G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              size = "16G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            cryptroot = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                additionalKeyFiles = ["/dev/mapper/cryptkey"];
                preCreateHook = "mount --mkdir -t tmpfs -o noswap tmpfs /root/mytmpfs && dd if=/dev/urandom of=/root/mytmpfs/cryptroot.key bs=512 count=4 iflag=fullblock";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "zfs";
                  pool = "rpool";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          atime = "off";
          canmount = "off";
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
          xattr = "sa";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          reserved = {
            options = {
              canmount = "off";
              mountpoint = "none";
              reservation = "50G";
            };
            type = "zfs_fs";
          };
          local = {
            options.mountpoint = "none";
            type = "zfs_fs";
          };
          "local/home" = {
            mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
            type = "zfs_fs";
          };
          "local/nix" = {
            mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
            type = "zfs_fs";
          };
          "local/persist" = {
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "false";
            type = "zfs_fs";
          };
          "local/root" = {
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/local/root@blank$' || zfs snapshot rpool/local/root@blank";
            type = "zfs_fs";
          };
          "local/var" = {
            options = {
              "com.sun:auto-snapshot" = "false";
              mountpoint = "none";
            };
            type = "zfs_fs";
          };
          "local/var/lib" = {
            mountpoint = "/var/lib";
            options."com.sun:auto-snapshot" = "false";
            type = "zfs_fs";
          };
          "local/var/log" = {
            mountpoint = "/var/log";
            options."com.sun:auto-snapshot" = "false";
            type = "zfs_fs";
          };
        };
      };
    };
  };
}
