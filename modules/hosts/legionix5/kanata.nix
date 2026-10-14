{
  flake.modules.nixos."hosts/legionix5" = {
    services.kanata = {
      enable = true;
      keyboards = {
        myKMonadOutput = {
          devices = ["/dev/input/by-id/usb-ITE_Tech._Inc._ITE_Device_8910_-event-kbd"];
          extraDefCfg = ''
            process-unmapped-keys yes
          '';
          config = builtins.readFile ../../../config/kanata/legion5.kbd;
        };
      };
    };
  };
}
