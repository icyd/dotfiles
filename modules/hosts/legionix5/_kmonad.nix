{
  flake.modules.nixos."hosts/legionix5" = {
    services.kmonad = {
      enable = true;
      keyboards = {
        myKMonadOutput = {
          device = "/dev/input/by-id/usb-ITE_Tech._Inc._ITE_Device_8910_-event-kbd";
          defcfg = {
            enable = true;
            fallthrough = true;
          };
          config = builtins.readFile ../../../config/kmonad/legion5.kbd;
        };
      };
    };
  };
}
