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
            settings = {
              configuration = ''
                [default]
                extend-ignore-re = [
                  "(?s)#\\s*typos:\\s*disabled.*?\\n\\s*#\\s*typos:\\s*enabled",
                  "(?m)^\\s*#\\s*typos:\\s*disable-next-line[^\\n]*\\n[^\\n]*$"
                ]

                [files]
                extend-exclude = [
                  "*.rules"
                ]
              '';
            };
          };
        };
      };
    };
}
