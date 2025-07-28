{
  config,
  withSystem,
  ...
}: {
  flake.modules.darwin."hosts/ES-IT00385" = withSystem "aarch64-darwin" ({inputs', ...}: {
    imports = with config.flake.modules.darwin; [
      kmonad
    ];
    environment.systemPackages = [
      inputs'.kmonad.packages.default
    ];
    services.kmonad = {
      enable = true;
      binOverride = "/run/current-system/sw/bin/kmonad";
      keyboards = {
        AppleInternalKeyboard = {
          device = "Apple Internal Keyboard / Trackpad";
          defcfg = {
            enable = true;
            fallthrough = true;
          };
          config = builtins.readFile ../../../config/kmonad/darwin_m1.kbd;
        };
      };
    };
  });
}
