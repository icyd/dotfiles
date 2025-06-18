{
  lib,
  inputs,
  ...
}: let
  nixpkgsInputs = with inputs; {inherit nixpkgs nixpkgs-unstable;};
in rec {
  flake.modules.nixos.base = {
    nix = {
      channel.enable = true;
      nixPath =
        nixpkgsInputs
        |> lib.mapAttrsToList (name: _value: "${name}=/etc/nix/channels/${name}");
      registry =
        nixpkgsInputs
        |> lib.mapAttrs (_name: flake: {inherit flake;});
    };
    environment.etc =
      nixpkgsInputs
      |> lib.mapAttrs' (name: value: {
        name = "nix/channels/${name}";
        value.source = value.outPath;
      });
  };
  flake.modules.darwin.base = flake.modules.nixos.base;
}
