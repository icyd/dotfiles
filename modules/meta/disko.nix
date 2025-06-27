{
  lib,
  inputs,
  ...
}: {
  flake.modules.nixos.disko = {
    imports = lib.optional (inputs.disko.nixosModules ? disko) inputs.disko.nixosModules.disko;
  };
}
