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
        (self: super: {
          inherit unstable;
          nixvim = inputs.nixvim.packages.${system}.default;
          nixvimin = inputs.nixvim.packages.${system}.nvimin;
          flox = inputs.flox.packages.${super.system}.default;
          zjstatus = inputs.zjstatus.packages.${super.system}.default;
        })
        inputs.nur.overlays.default
      ];
    };
}
