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

    aliasesStr = concatStringsSep "\n" (
        mapAttrsToList (k: v: "alias ${k} = ${v}" ) cfg.aliases
    );

    colorsStr = concatStringsSep "\n" (
        mapAttrsToList (k: v: ''let ${toLower k} = "#${v}"'' ) cfg.colors
    );

    profiles = [
        "($env.HOME)/.nix-profile"
        "/run/current-system/sw"
        "/nix/var/nix/profiles/default"
    ];


    paths = [
        "/usr/local/bin"
        "/usr/bin"
        "/usr/sbin"
        "/bin"
        "/sbin"
    ];

    nixPaths = [
        "darwin-config=($env.HOME)/.nixpkgs/darwin-configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
    ];

    listToStr = (ls: concatStringsSep " " (
        forEach ls (i:
            if hasInfix "$env." i then ''$"${i}"'' else ''"${i}"''
        )
    ));

    profilesStr = listToStr profiles;
    pathsStr = listToStr paths;
    nixPathsStr = listToStr nixPaths;
    prependPathsStr = listToStr cfg.prependPaths;
    appendPathsStr = listToStr cfg.appendPaths;
    manPathsStr = listToStr cfg.manPaths;

    variablesStr = concatStringsSep "\n    " (
        mapAttrsToList (k: v:
            if hasInfix "$env." v then ''$env.${k} = $"${v}"'' else ''$env.${k} = "${v}"''
        ) cfg.shellVariables
    );

in {
  # meta.maintainers = [ maintainers.Philipp-M ];

  options.programs.my-nushell = {
    enable = mkEnableOption "nushell";

    package = mkOption {
      type = types.package;
      default = pkgs.nushell-unstable;
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
        $env.FOO = 'BAR'
      '';
      description = ''
        The environment variables file to be used for nushell.
        </para>
        <para>
        See <link xlink:href="https://www.nushell.sh/book/configuration.html#configuration" /> for more information.
      '';
    };

    loginFile = mkOption {
      type = types.nullOr (linesOrSource "login.nu");
      default = null;
      example = ''
        $env.FOO = 'BAR'
      '';
      example = ''
        # Prints "Hello, World" upon logging into tty1
        if (tty) == "/dev/tty1" {
          echo "Hello, World"
        }
      '';
      description = ''
        The login file to be used for nushell upon logging in.

        See <https://www.nushell.sh/book/configuration.html#configuring-nu-as-a-login-shell> for more information.
      '';
    };

    extraConfigFirst = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell configuration file at the top of the file.
      '';
    };

    colors = mkOption {
        type = types.attrsOf types.str;
        default = {};
      description = ''
        Configuration of color scheme provided by nix-colors, or a map of attributes.
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
        description = ''
            Set of aliases for shell.
        '';
    };

    prependPaths = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
            List of paths to be prepended to $env.PATH
        '';
    };

    appendPaths = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
            List of paths to be appended to $env.PATH
        '';
    };

    manPaths = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
            List of paths to be appended to $env.MANPATH
        '';
    };

    shellVariables = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
            A set of environment variables used in the environment file.
        '';
    };

    extraEnvFirst = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell environment variables file at the top of the file.
      '';
    };

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
          (mkIf (cfg.extraConfigFirst != null) cfg.extraConfigFirst)
          (mkIf (cfg.colors != null) colorsStr)
          (mkIf (cfg.configFile != null) cfg.configFile.text)
          (mkIf (cfg.aliases != null) aliasesStr)
          (mkIf (cfg.extraConfig != null) cfg.extraConfig)
        ];
      })
      ({
        "${configDir}/env.nu".text = mkMerge [
            (mkIf (cfg.extraEnvFirst != null) cfg.extraEnvFirst)
            ''
            # Prevent this file from being sourced by child shells.
            if not ("__NIX_DARWIN_SET_ENVIRONMENT_DONE" in ($env | columns)) {
                $env.__NIX_DARWIN_SET_ENVIRONMENT_DONE = 1
                let profiles = [${profilesStr}]
                let paths = [${pathsStr}]
                let nix_path = [${nixPathsStr}]

                $env.PATH = (
                    $paths |
                    append ($profiles | each {|it| $"($it)/bin"})
                )
                $env.NIX_PATH = ($nix_path | str join (char esep))
                $env.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
                $env.TERMINFO_DIRS = (
                    $profiles |
                    append "/usr" |
                    each {|it| $"($it)/share/terminfo"} |
                    str join (char esep)
                )

                $env.XDG_CONFIG_DIRS = (
                    $profiles |
                    each {|it| $"($it)/etc/xdg"} |
                    str join (char esep)
                )
                $env.XDG_DATA_DIRS = (
                    $profiles |
                    each {|it| $"($it)/share"} |
                    str join (char esep)
                )

                # Extra initialisation
                # Bind gpg-agent to this TTY if gpg commands are used.
                $env.GPG_TTY = (tty)
                # SSH agent protocol doesn't support changing TTYs, so bind the agent
                # to every new TTY.
                (${pkgs.gnupg}/bin/gpg-connect-agent
                    --quiet updatestartuptty /bye out> /dev/null)

                $env.SSH_AUTH_SOCK = (
                    ${pkgs.gnupg}/bin/gpgconf
                    --list-dirs agent-ssh-socket
                )

                # reset TERM with new TERMINFO available (if any)
                # export TERM=$TERM

                $env.NIX_USER_PROFILE_DIR = $"/nix/var/nix/profiles/per-user/($env.USER)"
                $env.NIX_PROFILES = ($profiles | reverse | str join (char space))

                if ("~/.nix-defexpr/channels" | path exists) {
                    $env.NIX_PATH = (
                        $nix_path |
                        prepend $"($env.HOME)/.nix-defexpr/channels" |
                        str join (char esep)
                    )
                }

                # Set up secure multi-user builds: non-root users build through the
                # Nix daemon.
                if (ls -Dl /nix/var/nix/db | get readonly).0 {
                    $env.NIX_REMOTE = "daemon"
                }
            }

            # Only source this once.
            if not ("__HM_SESS_VARS_SOURCED" in ($env | columns)) {
                $env.__HM_SESS_VARS_SOURCED = 1

                ${variablesStr}

                let  man_paths = [${manPathsStr}]
                $env.MANPATH = (;
                    try {$env.MANPATH} catch {[]} |
                    append $man_paths
                )

                let path_to_prepend = [${prependPathsStr}]
                let path_to_append = [${appendPathsStr}]

                $env.PATH = (
                    $env.PATH |
                    prepend $path_to_prepend |
                    append $path_to_append
                )
            }

            # By default, <nushell-config-dir>/scripts is added
            $env.NU_LIB_DIRS = [
                ($nu.config-path | path dirname | path join 'scripts')
                $"($env.HOME)/${configDir}/scripts"
            ]

            # Directories to search for plugin binaries when calling register
            #
            # By default, <nushell-config-dir>/plugins is added
            $env.NU_PLUGIN_DIRS = [
                ($nu.config-path | path dirname | path join 'scripts')
            ]
            ''
            (mkIf (cfg.envFile != null) cfg.envFile.text)
            (mkIf (cfg.extraEnv != null) cfg.extraEnv)
        ];
      })
    ];
  };
}
