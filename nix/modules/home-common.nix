{
  pkgs,
  lib,
  config,
  stateVersion,
  username,
  email,
  homeDirectory,
  nix-colors,
  alacrittyFont,
  ...
}:
let
  nushell = pkgs.unstable.nushell;
  zellijConfigDir =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support/org.Zellij-Contributors.Zellij"
    else
      "${config.xdg.configHome}/zellij";
  alacrittyShell = if pkgs.stdenv.isDarwin then "${pkgs.zsh}/bin/zsh" else "${nushell}/bin/nu";
  alacrittyShellArgs =
    if pkgs.stdenv.isDarwin then
      [
        "-c"
        "${nushell}/bin/nu"
      ]
    else
      [ ];
in
{
  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
  fonts.fontconfig.enable = true;
  # imports = [ nix-colors.homeManagerModule ./nushell.nix ];
  imports = [ nix-colors.homeManagerModule ];
  home = {
    inherit stateVersion username homeDirectory;
    extraOutputsToInstall = [ "man" ];
    file = {
      ".editorconfig".source = ../../editorconfig/editorconfig;
      ".gitalias".source = ../../git/gitalias.txt;
      ".k8s_aliases.nu".source = ../../nushell/kubectl_aliases.nu;
      ".k8s_aliases.zsh".source = ../../zsh/kubectl_aliases.zsh;
      ".npmrc".source = ../../npm/npmrc;
      ".p10k.zsh".source = ../../zsh/p10k.zsh;
      ".scripts".source = ../../nushell/scripts;
      # "${config.xdg.dataHome}/nushell/nix-your-shell.nu".source =
      #   pkgs.nix-your-shell.generate-config "nu";
      "${
        zellijConfigDir
      }".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zellij";
    };
    packages = with pkgs; [
      binutils
      bottom
      carapace
      cargo
      ccls
      clang-tools
      cmake
      devenv
      direnv
      eza
      fd
      fish
      ghc
      go
      gopass
      gopass-jsonapi
      haskellPackages.cabal-install
      haskellPackages.fast-tags
      haskellPackages.ghci-dap
      # haskellPackages.haskell-language-server
      # haskellPackages.haskell-debug-adapter
      haskellPackages.hlint
      haskellPackages.hoogle
      haskellPackages.stack
      hledger
      hwatch
      hyperfine
      jdk11
      jq
      lazygit
      ledger
      lua-language-server
      lua51Packages.lua
      lua51Packages.luarocks
      # lua51Packages.magick
      mosh
      nodejs_20
      (nerdfonts.override {
        fonts = [
          "AnonymousPro"
          "Hack"
          "Inconsolata"
          "Meslo"
          "SourceCodePro"
        ];
      })
      unstable.nix-your-shell
      nixfmt-rfc-style
      nil
      nix-index
      pandoc
      procs
      python310
      python310Packages.pip
      python310Packages.virtualenv
      reckon
      ripgrep
      rust-analyzer
      rustc
      sd
      skim
      tree-sitter
      universal-ctags
      unstable.yq-go
      unstable.zellij
      unstable.zoxide
      # vscode-extensions.vadimcn.vscode-lldb
      ueberzugpp
      unstable.wezterm
      imagemagick
      zenith
    ];
    sessionPath = [
      "/usr/local/bin"
      "$HOME/.local/bin/"
      "$CARGO_HOME/bin"
      "$GOPATH/bin"
      "$HOME/.krew/bin"
      "$HOME/.ghcup/bin"
      "${config.xdg.dataHome}/cabal/bin"
      "$HOME/.npm-global/bin"
    ];
    sessionVariables =
      let
        editor = "nvim";
      in
      {
        ASDF_DATA_DIR = "$HOME/.asdf";
        BROWSER = "firefox";
        # CABAL_DIR = "${config.xdg.dataHome}/cabal";
        CARGO_HOME = "$HOME/.cargo";
        DOTFILES = "$HOME/.dotfiles";
        EDITOR = editor;
        GOPATH = "$HOME/go";
        LEDGER_HOME = "$HOME/Dropbox/ledger";
        LEDGER_DATE_FORMAT = "%Y/%m/%d";
        KUBE_EDITOR = editor;
        NVIM_SERVER = "/tmp/nvimsocket";
        ORGMODE_HOME = "$HOME/Dropbox";
        PAGER = "less";
        PASSWORD_STORE_GENERATED_LENGTH = 12;
        PY_VENV = "$HOME/.venv";
        RUSTUP_HOME = "$HOME/.rustup";
        VISUAL = editor;
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
  };
  programs.alacritty = import ./alacritty.nix {
    inherit config;
    package = pkgs.unstable.alacritty;
    shell = alacrittyShell;
    shellArgs = alacrittyShellArgs;
    font = alacrittyFont;
  };
  programs.bat = {
    config = {
      theme = "base16";
    };
    enable = true;
  };
  programs.direnv = {
    enable = true;
    enableNushellIntegration = false;
    nix-direnv.enable = true;
  };
  programs.fzf = import ./fzf.nix { inherit lib; };
  programs.git = import ./git.nix { inherit email; };
  programs.home-manager.enable = true;
  programs.man.enable = false;
  programs.nushell = {
    enable = true;
    package = nushell;
    shellAliases = {
      "~docs" = ''cd $"($env.HOME)/Documents"'';
      "~dot" = ''cd $"($env.HOME)/.dotfiles"'';
      "~drop" = ''cd $"($env.HOME)/Dropbox"'';
      "~org" = ''cd $"($env.HOME)/Dropbox/org"'';
      "~work" = ''cd $"($env.HOME)/Dropbox/org/work"'';
      "~dw" = ''cd $"($env.HOME)/Downloads"'';
      "~ea" = ''cd $"($env.HOME)/Projects/ea"'';
      "~nex" = ''cd $"($env.HOME)/Nextcloud"'';
      "~nix" = ''cd $"($env.HOME)/.dotfiles/nix"'';
      "~pj" = ''cd $"($env.HOME)/Projects"'';
      a = "enter";
      b64d = "base64 -d";
      cat = "bat";
      cl = "clear";
      cby = "clipboard copy";
      cbp = "clipboard paste";
      d = "shells";
      fj = "from json";
      fy = "from yaml";
      g = "git";
      gi = "git";
      gig = "utils gitignore_template";
      gpw = "gopass";
      jat = "bat -ljson";
      k = "kubectl";
      l = "eza";
      l1 = "eza -1";
      lb = "eza -lb";
      ll = "eza -la";
      llm = "eza -la --sort=modified";
      lx = "eza -lbhHigUmuSa@";
      la = "eza -lbhHigUmuSa";
      lg = "lazygit";
      mini-ci = "zellij action start-or-reload-plugin `file:${zellijConfigDir}/plugins/multitask.wasm`";
      nv = "nvim_client";
      nvr = "nvim_server";
      pw = "gopass show -c";
      svim = "sudo -E $env.EDITOR";
      tcp = "utils trimcopy";
      tj = "to json";
      tree = "eza --tree";
      ty = "to yaml";
      yat = "bat -lyaml";
      xat = "bat -lxml";
      zj = "zellij";
      zr = "zellij-runner";
      xssh = "TERM=xterm-256color ssh";
    };
    configFile.text =
      with lib;
      mkMerge [
        (concatStringsSep "\n" (
          mapAttrsToList (k: v: ''let ${toLower k} = "#${v}"'') config.colorScheme.palette
        ))

        (builtins.readFile ../../nushell/config.nu)
      ];
    envFile.source = ../../nushell/env.nu;
    extraConfig = ''
      source ${config.xdg.dataHome}/nushell/nix-your-shell.nu
      source ~/.zoxide.nu
      use utils.nu
      use certs.nu
      use modules/background_task/task.nu
      use modules/weather/get-weather.nu *
      use git-gone.nu *
      use cd-root.nu *
      use kubernetes.nu *
      use ~/.local.nu *
    '';
    extraEnv = ''
      $env.LANG = "en_US.UTF-8"
      $env.LC_ALL = "en_US.UTF-8"
    '';
  };
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    settings = {
      add_newline = true;
      command_timeout = 1200;
      haskell.disabled = true;
      nodejs.disabled = true;
      kubernetes = {
        disabled = false;
        contexts = [
          {
            context_pattern = ".*-prod(?<version>-v[^-]+)?-.*";
            context_alias = "Prod";
            style = "red bold";
          }
          {
            context_pattern = ".*-load(?<version>-v[^-]+)?-.*";
            context_alias = "Load$version";
            style = "orange";
          }
          {
            context_pattern = ".*-nonprod(?<version>-v[^-]+)?-.*";
            context_alias = "Nonprod$version";
            style = "green";
          }
        ];
      };
    };
  };
  programs.tmux = import ./tmux.nix { inherit lib pkgs; };
  programs.zsh = import ./zsh.nix { inherit lib pkgs config; };
  xdg.enable = true;
  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
    wezterm.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/wezterm";
    tmuxp.source = ../../tmux/tmuxp;
  };
}
