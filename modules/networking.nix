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
      # nameservers = [
      #   "208.67.222.222"
      #   "208.67.220.220"
      # ];
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
  };
}
