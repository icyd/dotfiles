{config, ...}: {
  flake.modules.darwin."hosts/ES-IT00385" = {
    imports = with config.flake.modules.darwin; [
      kmonad
    ];
    services.kmonad = {
      enable = true;
      binOverride = "/usr/local/bin/kmonad";
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
  };
}
