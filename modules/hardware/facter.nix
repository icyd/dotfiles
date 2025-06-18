{inputs, ...}: {
  flake.modules = {
    nixos.facter = {
      imports = [inputs.nixos-facter-modules.nixosModules.facter];
      facter.detected.dhcp.enable = false;
    };
    hm.facter = {pkgs, ...}: {
      home.packages = [pkgs.facter];
    };
  };
}
