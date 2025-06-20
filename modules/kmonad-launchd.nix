{lib, ...}: {
  flake.modules.darwin.kmonad = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.services.kmonad;
    kmonad_bin = cfg.binOverride or (lib.getExe cfg.package);
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
          fallthrough = lib.mkEnableOption "Reemitting unhandled key events.";
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
          input (iokit-name "${keyboard.device}")
          output (kext)
          fallthrough ${lib.boolToString keyboard.defcfg.fallthrough}
        )
      '';
    in
      pkgs.writeTextFile {
        name = "kmonad-${keyboard.name}.kbd";
        text = lib.optionalString keyboard.defcfg.enable (defcfg + "\n") + keyboard.config;
        checkPhase = "${kmonad_bin} -d $out";
      };
    mkService = keyboard: let
      cmd = [kmonad_bin] ++ cfg.extraArgs ++ ["${mkCfg keyboard}"];
      name = "kmonad-${keyboard.name}";
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
    options.services.kmonad = {
      enable = lib.mkEnableOption "Enable kmonad launch daemon";
      package = lib.mkPackageOption pkgs "KMonad" {default = "kmonad";};
      binOverride = lib.mkOption {
        # type = lib.types.nullOr lib.types.path;
        type = lib.types.str;
        default = "";
        description = "Override KMonad binary path";
      };
      keyboards = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule keyboard);
        default = {};
        description = "Keyboard configuration";
      };
      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Extra arguments to pass to kmonad.";
      };
    };
    config = lib.mkIf cfg.enable {
      launchd.daemons = services;
    };
  };
}
