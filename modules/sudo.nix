{
  flake.modules.nixos.base = {
    security.sudo-rs.enable = true;
  };
}
