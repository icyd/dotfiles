{
  flake.modules.nixos."hosts/legionix5" = {pkgs, ...}: {
    boot.initrd.systemd = {
      enable = true;
      services.initrd-rollback-root = {
        after = ["zfs-import-rpool.service"];
        before = ["sysroot.mount"];
        description = "Rollback root FS";
        path = [pkgs.zfs];
        script = "zfs rollback -r rpool/local/root@blank";
        serviceConfig.Type = "oneshot";
        unitConfig.DefaultDependencies = "no";
        wantedBy = ["initrd.target"];
      };
    };
  };
}
