{
  inputs,
  system,
  fetchFromGitHub,
  lib,
  pkgs,
  ...
}: let
  src = fetchFromGitHub {
    owner = "fresh2dev";
    repo = "zellij-autolock";
    tag = "0.2.2";
    hash = "sha256-uU7wWSdOhRLQN6cG4NvA9yASlvRwB6gggX89B5K9dyQ=";
  };
  toolchain = inputs.fenix.packages.${system}.fromToolchainFile {
    dir = src;
    sha256 = "sha256-SJwZ8g0zF2WrKDVmHrVG3pD2RGoQeo24MEXnNx5FyuI=";
  };
in
  (inputs.naersk.lib.${system}.override {
    cargo = toolchain;
    rustc = toolchain;
  }).buildPackage {
    inherit src;
    # buildInputs = with pkgs; [
    #   openssl
    # ];
    # nativeBuildInputs = with pkgs; [
    #   pkg-config
    # ];
    CARGO_BUILD_TARGET = "wasm32-wasip1";
    meta = {
      description = "autolock Zellij when certain processes open";
      homepage = "https://github.com/fresh3dev/zellij-autolock";
      changelog = "https://github.com/fresh3dev/zellij-autolock/blob/${src.tag}/CHANGELOG.md";
      license = with lib.licenses; [mit];
      mainProgram = "${src.repo}.wasm";
    };
  }
