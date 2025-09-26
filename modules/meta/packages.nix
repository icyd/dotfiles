{
  lib,
  inputs,
  ...
}: {
  imports = lib.optional (inputs.pkgs-by-name-for-flake-parts ? flakeModule) inputs.pkgs-by-name-for-flake-parts.flakeModule;
  perSystem = {
    inputs',
    system,
    config,
    ...
  }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: _prev: {
            bash-env-json = inputs'.bash-env-json.packages.default;
            bash-env-nushell = inputs'.bash-env-nushell.packages.default;
            local = config.packages;
            nixvim = inputs'.nixvim.packages.default;
            nixvimin = inputs'.nixvim.packages.nvimin;
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) config;
              inherit system;
            };
            zjstatus = inputs'.zjstatus.packages.default;
          })
          inputs.nur.overlays.default
        ];
      };
    }
    // (lib.optionalAttrs (inputs.pkgs-by-name-for-flake-parts ? flakeModule) {
      pkgsDirectory = ../../packages;
    });
}
