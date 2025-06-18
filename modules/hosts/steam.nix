{
  nixpkgs.allowedUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
  flake.modules.nixos.steam = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      mangohud
    ];
    programs.gamemode.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
}
