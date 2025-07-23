{
  flake.modules.nixos.bluetooth = {pkgs, ...}: {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    environment.systemPackages = with pkgs; [
      bluez-tools
    ];
  };
}
