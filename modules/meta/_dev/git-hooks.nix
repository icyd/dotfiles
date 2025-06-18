{
  lib,
  inputs,
  ...
}: {
  imports = lib.optional (inputs.git-hooks ? flakeModule) inputs.git-hooks.flakeModule;

  perSystem = {lib, ...}:
    lib.optionalAttrs (inputs.git-hooks ? flakeModule) {
      pre-commit = {
        check.enable = false;
        settings.hooks = {
          deadnix.enable = true;
          # luacheck.enable = true;
          # statix.enable = true;
          treefmt.enable = true;
          typos = {
            enable = true;
            settings.exclude = "*.rules";
          };
        };
      };
    };
}
