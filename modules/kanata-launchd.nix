{lib, ...}: {
  flake.modules.darwin.kanata = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.services.kanata;
    kanata_bin =
      if (cfg.binOverride == "")
      then (lib.getExe cfg.package)
      else cfg.binOverride;
    keyboard = {name, ...}: {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "Keyboard name.";
        };
        device = lib.mkOption {
          type = lib.types.str;
          description = "Keyboard IOKit name.";
        };
        defcfg = {
          enable = lib.mkEnableOption "Automatic generate defcfg block.";
        };
        config = lib.mkOption {
          type = lib.types.lines;
          description = "Keyboard configuration.";
        };
      };
    };

    mkCfg = keyboard: let
      defcfg = ''
        (defcfg
          macos-dev-names-include (
            "${keyboard.device}"
          )
        )
      '';
    in
      pkgs.writeTextFile {
        name = "kanata-${keyboard.name}.kbd";
        text = lib.optionalString keyboard.defcfg.enable (defcfg + "\n") + keyboard.config;
        checkPhase = "${kanata_bin} --check --cfg $out";
      };
    mkService = keyboard: let
      cmd = [kanata_bin] ++ cfg.extraArgs ++ ["--cfg" "${mkCfg keyboard}"];
      name = "kanata-${keyboard.name}";
    in {
      inherit name;
      value.serviceConfig = {
        ProgramArguments = cmd;
        RunAtLoad = true;
        StandardOutPath = "/var/log/${name}.out.log";
        StandardErrorPath = "/var/log/${name}.err.log";
      };
    };
    services = builtins.listToAttrs (map mkService (builtins.attrValues cfg.keyboards));
  in {
    options.services.kanata = {
      enable = lib.mkEnableOption "Enable kanata launch daemon";
      package = lib.mkPackageOption pkgs "kanata" {default = "kanata";};
      binOverride = lib.mkOption {
        # type = lib.types.nullOr lib.types.path;
        type = lib.types.str;
        default = "";
        description = "Override kanata binary path";
      };
      keyboards = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule keyboard);
        default = {};
        description = "Keyboard configuration";
      };
      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Extra arguments to pass to kanata.";
      };
    };
    config = lib.mkIf cfg.enable {
      launchd.daemons = services;
    };
  };
}
