{
  config,
  withSystem,
  ...
}: {
  flake.modules.darwin."hosts/ES-IT00385" = withSystem "aarch64-darwin" ({pkgs, ...}: {
    imports = with config.flake.modules.darwin; [
      kanata
    ];
    services.kanata = {
      enable = true;
      package = pkgs.mv.tip.kanata;
      extraArgs = ["--nodelay"];
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
