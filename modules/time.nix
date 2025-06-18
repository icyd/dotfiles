{
  flake.modules.nixos.base = {
    services.ntpd-rs.enable = true;
    time.timeZone = "Europe/Madrid";
  };
}
