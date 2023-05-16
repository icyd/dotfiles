{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.my-nushell;

  configDir = if pkgs.stdenv.isDarwin then
    "Library/Application Support/nushell"
  else
    "${config.xdg.configHome}/nushell";

  linesOrSource = name:
    types.submodule ({ config, ... }: {
      options = {
        text = mkOption {
          type = types.lines;
          default = if config.source != null then
            builtins.readFile config.source
          else
            "";
          defaultText = literalExpression
            "if source is defined, the content of source, otherwise empty";
          description = ''
            Text of the nushell <filename>${name}</filename> file.
            If unset then the source option will be preferred.
          '';
        };

        source = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Path of the nushell <filename>${name}</filename> file to use.
            If the text option is set, it will be preferred.
          '';
        };
      };
    });

    aliasesStr concatStringSep "\n" (
        mapAttrsToList (k: v: "alias ${k} = ${v}" )
    );
in {
  # meta.maintainers = [ maintainers.Philipp-M ];

  # imports = [
  #   (mkRemovedOptionModule [ "programs" "nushell" "settings" ] ''
  #     Please use
  #
  #       'programs.my-nushell.configFile' and 'programs.my-nushell.envFile'
  #
  #     instead.
  #   '')
  # ];

  options.programs.my-nushell = {
    enable = mkEnableOption "nushell";

    package = mkOption {
      type = types.package;
      default = pkgs.nushell;
      defaultText = literalExpression "pkgs.nushell";
      description = "The package to use for nushell.";
    };

    configFile = mkOption {
      type = types.nullOr (linesOrSource "config.nu");
      default = null;
      example = literalExpression ''
        { text = '''
            let $config = {
              filesize_metric: false
              table_mode: rounded
              use_ls_colors: true
            }
          ''';
        }
      '';
      description = ''
        The configuration file to be used for nushell.
        </para>
        <para>
        See <link xlink:href="https://www.nushell.sh/book/configuration.html#configuration" /> for more information.
      '';
    };

    envFile = mkOption {
      type = types.nullOr (linesOrSource "env.nu");
      default = null;
      example = ''
        let-env FOO = 'BAR'
      '';
      description = ''
        The environment variables file to be used for nushell.
        </para>
        <para>
        See <link xlink:href="https://www.nushell.sh/book/configuration.html#configuration" /> for more information.
      '';
    };

    extraConfigFirst = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell configuration file.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell configuration file.
      '';
    };

    aliases = mkOption {
        type = types.attrsOf types.str;
        default = {};
    }

    extraEnv = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell environment variables file.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.file = mkMerge [
      (mkIf (cfg.extraConfigFirst != "" || cfg.configFile != null || cfg.extraConfig != "") {
        "${configDir}/config.nu".text = mkMerge [
          cfg.extraConfigFirst
          (mkIf (cfg.configFile != null) cfg.configFile.text)
          aliasesStr
          cfg.extraConfig
        ];
      })
      (mkIf (cfg.envFile != null || cfg.extraEnv != "") {
        "${configDir}/env.nu".text = mkMerge [
          (mkIf (cfg.envFile != null) cfg.envFile.text)
          cfg.extraEnv
        ];
      })
    ];
  };
}
