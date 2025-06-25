{
  lib,
  inputs,
  ...
}: {
  imports = lib.optional (inputs.pkgs-by-name-for-flake-parts ? flakeModule) inputs.pkgs-by-name-for-flake-parts.flakeModule;
  perSystem = {system, ...}:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: _prev: {
            bash-env-json = inputs.bash-env-json.packages.${system}.default;
            bash-env-nushell = inputs.bash-env-nushell.packages.${system}.default;
            nixvim = inputs.nixvim.packages.${system}.default;
            nixvimin = inputs.nixvim.packages.${system}.nvimin;
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) config;
              inherit system;
            };
            zjstatus = inputs.zjstatus.packages.${system}.default;
          })
          inputs.nur.overlays.default
        ];
      };
    }
    // (lib.optionalAttrs (inputs.pkgs-by-name-for-flake-parts ? flakeModule) {
      pkgsDirectory = ../../packages;
    });
}
