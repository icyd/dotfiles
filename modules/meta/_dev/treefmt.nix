{
  lib,
  inputs,
  ...
}: {
  imports = lib.optional (inputs.treefmt-nix ? flakeModule) inputs.treefmt-nix.flakeModule;

  perSystem = {
    lib,
    pkgs,
    ...
  }:
    lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
      treefmt = {
        # BUG: https://github.com/numtide/treefmt-nix/issues/156
        flakeCheck = false;
        flakeFormatter = true;
        projectRootFile = "flake.nix";
        programs = {
          deadnix.enable = true;
          nixf-diagnose.enable = true;
          nixfmt = {
            enable = true;
            package = pkgs.alejandra;
          };
          statix.enable = true;
          stylua.enable = true;
          typos.enable = true;
        };
        settings.formatter.typos.excludes = ["*.rules"];
        settings.global.excludes = [
          ".envrc"
          "README.md"
          "config/*"
          "_to_migrate/*"
        ];
      };
    };
}
