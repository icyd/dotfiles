{
  lib,
  inputs,
  withSystem,
  ...
}: {
  flake.overlays.default = _final: prev: {
    local = withSystem prev.stdenv.hostPlatform.system ({config, ...}: config.packages);
  };
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
            mv = let
              cleanConfig = builtins.removeAttrs final.config ["replaceStdenv"];
            in
              inputs.multiverse.lib.mkMultiverse {
                inherit system;
                config = cleanConfig;
              };
            inherit (inputs'.multiverse.packages) mvs;
            nixvim = inputs'.nixvim.packages.default;
            nixvimin = inputs'.nixvim.packages.nvimin;
            zjstatus = inputs'.zjstatus.packages.default;
          })
          inputs.nur.overlays.default
          inputs.mcp-companion.overlays.default
          inputs.sharedserver.overlays.default
        ];
      };
    }
    // (lib.optionalAttrs (inputs.pkgs-by-name-for-flake-parts ? flakeModule) {
      pkgsDirectory = ../../packages;
    });
}
