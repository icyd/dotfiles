{ pkgs, lib, config, stateVersion, username, homeDirectory, email, nix-colors, ... }: let
    colors = config.colorScheme.colors;
    zellijConfigDir = if pkgs.stdenv.isDarwin then
        "${config.home.homeDirectory}/Library/Application Support/org.Zellij-Contributors.Zellij"
    else
        "${config.xdg.configHome}/zellij";
    liblpeg = pkgs.stdenv.mkDerivation {
        pname = "liblpeg";
        inherit (pkgs.luajitPackages.lpeg) version src;

        nativeBuildInputs = [ pkgs.fixDarwinDylibNames ];
        buildInputs = [ pkgs.luajit ];

        patches = [ ../patches/liblpeg-makefile.patch ];

        installPhase = ''
          install -D lpeg.dylib $out/lib/lpeg.dylib
        '';

        meta = {
          homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
          description = "Parsing Expression Grammars For Lua";
          license.fullName = "MIT/X11";
          platforms = [ "x86_64-darwin" "aarch64-darwin" ];
        };
    };
    neovim-patched = pkgs.neovim-nightly.overrideAttrs (oa: {
        nativeBuildInputs = oa.nativeBuildInputs ++ lib.optionals (liblpeg != null) [
          liblpeg
        ];

        patches = builtins.filter
          (p:
            let
              patch =
                if builtins.typeOf p == "set"
                then baseNameOf p.name
                else baseNameOf p;
            in
            patch != "use-the-correct-replacement-args-for-gsub-directive.patch")
          oa.patches;
    });
in {
    imports = [
      nix-colors.homeManagerModule
      # ./nushell
    ];
    colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
    fonts.fontconfig.enable = true;

    programs.direnv = {
        enable = true;
        enableNushellIntegration = false;
        nix-direnv.enable = true;
    };

    programs.starship = {
        enable = true;
        package = pkgs.starship-unstable;
        settings = {
            add_newline = true;
            # format = "$character";
            # right_format = "$all";
        };
    };

    programs.wezterm.enable = true;

    programs.nushell = {
        enable = true;
        package = pkgs.nushell-unstable;
        shellAliases = {
            "~docs" = ''cd $"($env.HOME)/Documents"'';
            "~dot" = ''cd $"($env.HOME)/.dotfiles"'';
            "~dw" = ''cd $"($env.HOME)/Downloads"'';
            "~ea" = ''cd $"($env.HOME)/Projects/ea"'';
            "~nex" = ''cd $"($env.HOME)/Nextcloud"'';
            "~drop" = ''cd $"($env.HOME)/Dropbox"'';
            "~nix" = ''cd $"($env.HOME)/.dotfiles/nix"'';
            "~pj" = ''cd $"($env.HOME)/Projects"'';
            cat = "bat";
            cl = "clear";
            gpw = "gopass";
            pw = "gopass show -c";
            k = "kubectl";
            # ldr = ''(gpg -d $"($env.LEDGER_HOME)/journals/journal.ledger.gpg" | ledger --pedantic --file $"($env.LEDGER_HOME)/main.ledger" --file -)'';
            # hldr = "(ldr print | hledger -f-)";
            # ldre = "ldr --exchange EUR";
            # ldru = "ldr --exchange USD";
            l = "exa";
            l1 = "exa -1";
            lb = "exa -lb";
            ll = "exa -la";
            llm = "exa -la --sort=modified";
            lx = "exa -lbhHigUmuSa@";
            la = "exa -lbhHigUmuSa";
            gi = "git";
            nvr = "nvim --listen $env.NVIM_SERVER";
            nv = "nvim_client";
            # nt = "nvim_client --remote-tab-silent";
            # o = "own_pop";
            # p = "own_push";
            svim = "sudo -E $env.EDITOR";
            tree = "exa --tree";
            # tx = "tmuxp_fzf";
            zj = "zellij";
            zr = "zellij-runner";
            d = "shells";
            a = "enter";
            nuwatch = ''hwatch -c -s "nu -c"'';
            mini-ci = "zellij action start-or-reload-plugin `file:${zellijConfigDir}/plugins/multitask.wasm`";
        };

        configFile.text = with lib; mkMerge [
            (concatStringsSep "\n" (
                mapAttrsToList (k: v: ''let ${toLower k} = "#${v}"'' ) config.colorScheme.colors)
            )

            (builtins.readFile ../../nushell/config.nu)
        ];

        envFile.source = ../../nushell/env.nu;

        extraEnv = ''
            $env.LANG = "en_US.UTF-8"
            $env.LC_ALL = "en_US.UTF-8"
        '';

    extraConfig = ''
        source ~/.k8s_aliases.nu
        # use job.nu
        use modules/background_task/job.nu *
        # use get-weather.nu *
        use modules/weather/get-weather.nu *
        use git-gone.nu *
        use cd-root.nu *
        use k8s.nu *
        # use modules/kubernetes/kubernetes.nu *
        use certs.nu *
        use local.nu *
    '';
    };

    # programs.my-nushell = {
    #     enable = true;
    #     package = pkgs.nushell-unstable;
    #     configFile.source = ../../nushell/config.nu;
    #
    #     colors = config.colorScheme.colors;
    #
    #     aliases = {
    #         "~docs" = ''cd $"($env.HOME)/Documents"'';
    #         "~dot" = ''cd $"($env.HOME)/.dotfiles"'';
    #         "~dw" = ''cd $"($env.HOME)/Downloads"'';
    #         "~ea" = ''cd $"($env.HOME)/Projects/ea"'';
    #         "~nex" = ''cd $"($env.HOME)/Nextcloud"'';
    #         "~drop" = ''cd $"($env.HOME)/Dropbox"'';
    #         "~nix" = ''cd $"($env.HOME)/.dotfiles/nix"'';
    #         "~pj" = ''cd $"($env.HOME)/Projects"'';
    #         cat = "bat";
    #         cl = "clear";
    #         gpw = "gopass";
    #         pw = "gopass show -c";
    #         k = "kubectl";
    #         # ldr = ''(gpg -d $"($env.LEDGER_HOME)/journals/journal.ledger.gpg" | ledger --pedantic --file $"($env.LEDGER_HOME)/main.ledger" --file -)'';
    #         # hldr = "(ldr print | hledger -f-)";
    #         # ldre = "ldr --exchange EUR";
    #         # ldru = "ldr --exchange USD";
    #         l = "exa";
    #         l1 = "exa -1";
    #         lb = "exa -lb";
    #         ll = "exa -la";
    #         llm = "exa -la --sort=modified";
    #         lx = "exa -lbhHigUmuSa@";
    #         la = "exa -lbhHigUmuSa";
    #         gi = "git";
    #         nvr = "nvim --listen $env.NVIM_SERVER";
    #         nv = "nvim_client";
    #         # nt = "nvim_client --remote-tab-silent";
    #         # o = "own_pop";
    #         # p = "own_push";
    #         svim = "sudo -E $env.EDITOR";
    #         tree = "exa --tree";
    #         tx = "tmuxp_fzf";
    #         zj = "zellij";
    #         zr = "zellij-runner";
    #         d = "shells";
    #         a = "enter";
    #         mini-ci = "zellij action start-or-reload-plugin `file:${zellijConfigDir}/plugins/multitask.wasm`";
    #     };
    #
    #     prependPaths = [
    #         "($env.HOME)/.asdf/shims"
    #         "/opt/homebrew/bin"
    #         "/opt/homebrew/opt/coreutils/libexec/gnubin"
    #     ];
    #
    #     appendPaths = [
    #         "($env.CARGO_HOME)/bin"
    #         "($env.GOPATH)/bin"
    #         "($env.HOME)/.local/bin"
    #         "($env.HOME)/.krew/bin"
    #         "($env.HOME)/.ghcup/bin"
    #         "($env.HOME)/.cabal/bin"
    #     ];
    #
    #     manPaths = [
    #         "/opt/homebrew/opt/coreutils/libexec/gnuman"
    #     ];
    #
    #
    #     shellVariables = {
    #             PROMPT_INDICATOR =  "〉" ;
    #             PROMPT_INDICATOR_VI_INSERT =  " " ;
    #             PROMPT_INDICATOR_VI_NORMAL =  " " ;
    #             PROMPT_MULTILINE_INDICATOR =  " " ;
    #             BROWSER = "firefox";
    #             CARGO_HOME = "($env.HOME)/.cargo";
    #             DOTFILES = "($env.HOME)/.dotfiles";
    #             GOPATH = "($env.HOME)/go";
    #             LANG = "en_US.UTF-8";
    #             LC_ALL = "en_US.UTF-8";
    #             LEDGER_HOME = "($env.HOME)/Dropbox/ledger";
    #             NVIM_SERVER = "/tmp/nvimsocket";
    #             ORGMODE_HOME = "($env.HOME)/Dropbox";
    #             PASSWORD_STORE_GENERATED_LENGTH = "12";
    #             PY_VENV = "($env.HOME)/.venv";
    #             RUSTUP_HOME = "($env.HOME)/.rustup";
    #             VIMWIKI_HOME = "($env.HOME)/Dropbox";
    #             XDG_CONFIG_HOME = "($env.HOME)/.config";
    #             LEDGER_DATE_FORMAT = "%Y/%m/%d";
    #             KUBE_EDITOR = "nvim";
    #             EDITOR = "nvim";
    #             VISUAL = "nvim";
    #             ZELLIJ_RUNNER_BANNERS_DIR = "${zellijConfigDir}/banners";
    #             ZELLIJ_RUNNER_LAYOUTS_DIR = "${zellijConfigDir}/layouts";
    #             ZELLIJ_RUNNER_ROOT_DIR = "Projects";
    #             ZELLIJ_RUNNER_IGNORE_DIRS = "node_modules,target";
    #             ZELLIJ_RUNNER_MAX_DIRS_DEPTH = "2";
    #     };
    #
    #     extraConfig = ''
    #         source ~/.k8s_aliases.nu
    #         # use job.nu
    #         use get-weather.nu *
    #         use git-gone.nu *
    #         use cd-root.nu *
    #         use k8s.nu *
    #         use certs.nu *
    #         source ${config.xdg.cacheHome}/starship/init.nu
    #
    #
    #         def-env mkcd [directory: string] {mkdir $directory; cd $directory}
    #
    #         if ("/Users/aj.vazquez/.local.nu" | path expand | path exists) {
    #             use /Users/aj.vazquez/.local.nu *
    #         }
    #     '';
    #
    #     extraEnv = ''
    #         if (("WEZTERM_PANE" in ($env | columns)) and
    #             ("NVIM_SERVER" in ($env | columns))) {
    #             $env.NVIM_LISTEN_ADDRESS = $"($env.NVIM_SERVER)($env.WEZTERM_PANE)"
    #         }
    #     '';
    # };

    # programs.zellij = {
    #     enable = true;
    #     package = pkgs.zellij-unstable;
    #     settings = {
    #         theme = "kanagawa";
    #         simplified_ui = false;
    #         plugins = [
    #             { tag = "tab-bar"; path = "tab-bar"; }
    #             { tag = "status-bar"; path = "status-bar"; }
    #             { tag = "strider"; path = "strider"; }
    #         ];
    #         keybinds.normal = [
    #             { unbind = [ { Ctrl = "b"; } ]; }
    #             {
    #                 action = [ { SwitchToMode = "Tmux"; } ];
    #                 key = [ { Ctrl = "a"; } ];
    #             }
    #         ];
    #         keybinds.tmux = [
    #             {
    #                 action = [
    #                     { NewPane = "Down"; }
    #                     { SwitchToMode = "Normal"; }
    #                 ];
    #                 key = [ { Char = "-"; }];
    #             }
    #             {
    #                 action = [
    #                     { NewPane = "Right"; }
    #                     { SwitchToMode = "Normal"; }
    #                 ];
    #                 key = [ { Char = "\\"; }];
    #             }
    #         ];
    #     };
    # };

    home = {
        inherit stateVersion username homeDirectory;

        file = {
            ".editorconfig".source = ../../editorconfig/editorconfig;
            ".npmrc".source = ../../npm/npmrc;
            ".p10k.zsh".source = ../../zsh/p10k.zsh;
            ".k8s_aliases.zsh".source = ../../zsh/kubectl_aliases.zsh;
            ".k8s_aliases.nu".source = ../../nushell/kubectl_aliases.nu;
            ".gitalias".source = ../../git/gitalias.txt;
            ".scripts".source = ../../nushell/scripts;
        };

        sessionPath = [
            "/usr/local/bin"
            "$CARGO_HOME/bin"
            "$GOPATH/bin"
            "$HOME/.local/bin/"
            "$HOME/.krew/bin"
            "$HOME/.ghcup/bin"
            "$HOME/.cabal/bin"
        ];

        sessionVariables = {
            # ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
            BROWSER = "firefox";
            CARGO_HOME = "$HOME/.cargo";
            DOTFILES = "$HOME/.dotfiles";
            GOPATH = "$HOME/go";
            LEDGER_HOME = "$HOME/Dropbox/ledger";
            LEDGER_DATE_FORMAT = "%Y/%m/%d";
            KUBE_EDITOR = "nvim";
            EDITOR = "nvim";
            VISUAL = "nvim";
            NVIM_SERVER = "/tmp/nvimsocket";
            ORGMODE_HOME = "$HOME/Dropbox";
            PAGER = "less";
            # PATH = "$HOME/.npm-global/bin:$CARGO_HOME/bin:$PATH";
            # PATH = "$ASDF_DATA_DIR/shims:$HOME/.npm-global/bin:$PATH";
            PASSWORD_STORE_GENERATED_LENGTH = 12;
            PY_VENV = "$HOME/.venv";
            RUSTUP_HOME = "$HOME/.rustup";
            VIMWIKI_HOME = "$HOME/Dropbox";
            WINEDLLOVERRIDES = "winemenubuilder.exe=d";
            XDG_CONFIG_HOME = "${config.xdg.configHome}";
            ZELLIJ_CONFIG = "${zellijConfigDir}";
            ZELLIJ_RUNNER_BANNERS_DIR = "${zellijConfigDir}/banners";
            ZELLIJ_RUNNER_LAYOUTS_DIR = "${zellijConfigDir}/layouts";
            ZELLIJ_RUNNER_ROOT_DIR = "Projects";
            ZELLIJ_RUNNER_IGNORE_DIRS = "node_modules,target";
            ZELLIJ_RUNNER_MAX_DIRS_DEPTH = "2";
            ZSH_CACHE_DIR = "$HOME/.cache/zsh";
            ZSH_CONFIG = "${config.xdg.configHome}/zsh";
        };

        packages = with pkgs; [
          bottom
          exa
          carapace
          direnv
          fd
          fish
          hyperfine
          jq
          jdk11
          lazygit
          ledger
          hledger
          reckon
          # neovim-nightly
          # neovim-unstable
          # neovim-remote
          nodejs
          (nerdfonts.override {
            fonts = [
              "AnonymousPro" "Hack" "Inconsolata" "Meslo" "SourceCodePro"
            ];
          })
          pandoc
          procs
          python310
          python310Packages.pip
          python310Packages.virtualenv
          ripgrep
          sd
          tree-sitter
          universal-ctags
          yq-unstable
          # zellij-unstable
        ] ++ [neovim-patched];
    };
}
