{
  lib,
  inputs,
  ...
}:
{
  imports = lib.optionals (inputs.flake-parts ? flakeModules) (
    with inputs.flake-parts.flakeModules; [modules partitions]
  );
}
// (
  lib.optionalAttrs (inputs.flake-parts ? flakeModules) {
    debug = true;
    partitions = {
      dev = {
        module = ./_dev;
        extraInputsFlake = ./_dev;
      };
    };

    partitionedAttrs = let
      partition = "dev";
    in {
      checks = partition;
      devShells = partition;
      formatter = partition;
    };
  }
)
