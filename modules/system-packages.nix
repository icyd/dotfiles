{
  flake.modules.nixos.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      git
      unzip
      vim
    ];
  };
}
