{
  flake.modules.nixos.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      nix-diff
      nix-fast-build
      nix-output-monitor
      nix-tree
      nvd
    ];
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 5";
      };
    };
  };
  flake.modules.homeManager.base = {
    programs.nix-index.enable = true;
    programs.nix-your-shell.enable = true;
  };
}
