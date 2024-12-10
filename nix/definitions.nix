{ inputs, ... }:
{
  users = {
    linux = {
      email = "beto.v25@gmail.com";
      username = "beto";
    };
    darwin = {
      email = "aj.vazquez@globant.com";
      username = "aj.vazquez";
    };
  };
  nixpkgsConfig =
    { system }:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (self: super: { inherit unstable; })
        inputs.nur.overlays.default
      ];
    };
  neovim-override =
    { system }:
    ({ environment.systemPackages = [ inputs.neovim-nightly-overlay.packages.${system}.default ]; });
}
