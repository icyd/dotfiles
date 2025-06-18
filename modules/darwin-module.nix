{
  lib,
  flake-parts-lib,
  moduleLocation,
  ...
}: {
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      darwinConfigurations = lib.mkOption {
        type = with lib; types.lazyAttrsOf types.raw;
        default = {};
        description = ''
          Instantiated Darwin configurations.
        '';
      };
      darwinModules = lib.mkOption {
        type = with lib; types.lazyAttrsOf types.deferredModule;
        default = {};
        apply = lib.mapAttrs (
          k: v: {
            _class = "darwin";
            _file = "${toString moduleLocation}#darwinModules.${k}";
            imports = [v];
          }
        );
        description = ''
          Darwin modules.

          You may use this for reusable pieces of configuration, service modules, etc.
        '';
      };
    };
  };
}
