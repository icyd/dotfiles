{ lib, config, ... }:
let
  cfg = config.my.gpg;
in
{
  options.my = {
    gpg.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable module";
    };
    gpg.sshKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "B7CDB0F8E860D6FE32986A446E986DE7FF13D8A2" ];
      description = "List of SSH keys";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 10800;
      sshKeys = cfg.sshKeys;
    };
  };
}
