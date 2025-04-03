{
  lib,
  config,
  ...
}: let
  cfg = config.my.gpg;
in {
  options.my = {
    gpg.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable module";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 10800;
    };
  };
}
