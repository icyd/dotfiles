{
  flake.modules.nixos.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
    networking = {
      wireless.iwd = {
        enable = true;
        settings = {
          Network.EnableIPv6 = true;
          Settings.AutoConnect = true;
        };
      };
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
  };
}
