{
  description = "dev's inputs, used by top level flake in partition.";
  inputs = {
    root.url = "path:../../..";
    nixpkgs.follows = "root/nixpkgs";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "";
        gitignore.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = _inputs: {};
}
