{inputs, ...}: {
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
  nixpkgsConfig = {system}: let
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (_self: super: {
        inherit unstable;
        bash-env-json = inputs.bash-env-json.packages.${system}.default;
        bash-env-nushell = inputs.bash-env-nushell.packages.${system}.default;
        nixvim = inputs.nixvim.packages.${system}.default;
        nixvimin = inputs.nixvim.packages.${system}.nvimin;
        zjstatus = inputs.zjstatus.packages.${super.system}.default;
      })
      inputs.nur.overlays.default
    ];
  };
}
