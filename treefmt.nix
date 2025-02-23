{pkgs, ...}: {
  projectRootFile = "flake.nix";
  programs = {
    deadnix.enable = true;
    nixfmt = {
      enable = true;
      package = pkgs.alejandra;
    };
  };
}
