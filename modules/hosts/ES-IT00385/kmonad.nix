{
  config,
  withSystem,
  ...
}: {
  flake.modules.darwin."hosts/ES-IT00385" = withSystem "aarch64-darwin" ({inputs', ...}: let
    kmonad_pkg = inputs'.kmonad.packages.default;
  in {
    imports = with config.flake.modules.darwin; [
      kmonad
    ];
    environment.systemPackages = [
      kmonad_pkg
    ];
    services.kmonad = {
      enable = true;
      binOverride = "/run/current-system/sw/bin/kmonad";
      package = kmonad_pkg;
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
