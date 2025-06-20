{lib, ...}: {
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
      clean = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        extraArgs = "--keep-since 4d --keep 5";
      };
    };
  };
  flake.modules.darwin.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      home-manager
      nh
      nix-diff
      nix-fast-build
      nix-output-monitor
      nix-tree
      nvd
      vim
    ];
  };
  flake.modules.homeManager.base = {
    programs.nix-index.enable = true;
    programs.nix-your-shell.enable = true;
  };
}
