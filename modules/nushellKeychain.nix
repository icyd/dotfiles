{
  flake.modules.homeManager.nushell = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.nushellKeychain;
  in {
    options.nushellKeychain = {
      enable = lib.mkEnableOption "Enable keychain configuration for nushell";
      keys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["id_ed25519"];
        description = "List of keys to add to keychain";
      };
    };
    config = lib.mkIf (config.programs.nushell.enable && cfg.enable && cfg.keys != []) {
      programs.nushell.extraEnv = let
        bin = lib.getExe pkgs.keychain;
        keys = lib.strings.concatStringsSep " " cfg.keys;
      in ''
        ${bin} --agents ssh --eval --quiet ${keys}
          | lines
          | where not ($it | is-empty)
          | parse "{name}={value}; export {name2};"
          | reject name2
          | transpose --header-row
          | into record
          | load-env
      '';
    };
  };
}
