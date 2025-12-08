{
  config,
  withSystem,
  ...
}: {
  flake.modules.darwin."hosts/ES-IT00385" = withSystem "aarch64-darwin" ({...}: {
    imports = with config.flake.modules.darwin; [
      kanata
    ];
    services.kanata = {
      enable = true;
      keyboards = {
        AppleInternalKeyboard = {
          device = "Apple Internal Keyboard / Trackpad";
          defcfg = {
            enable = true;
          };
          config = builtins.readFile ../../../config/kanata/darwin_m1.kbd;
        };
      };
    };
  });
}
