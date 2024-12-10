{
  config,
  pkgs,
  inputs,
  username,
  ...
}:
let
  nix-colors = inputs.nix-colors;
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
  fonts.fontconfig.enable = true;
  imports = [
    nix-colors.homeManagerModule
    ./editorconfig.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./nix-your-shell.nix
    ./nushell.nix
    ./starship.nix
    ./zsh.nix
  ];
  fzf.enable = true;
  home = {
    inherit username homeDirectory;
    stateVersion = "22.05";
    extraOutputsToInstall = [ "man" ];
    file = {
      ".k8s_aliases.nu".source = ../../nushell/kubectl_aliases.nu;
      ".k8s_aliases.zsh".source = ../../zsh/kubectl_aliases.zsh;
      ".npmrc".text = ''
        prefix=~/.npm-global
      '';
      ".scripts".source = ../../scripts;
    };
    packages = with pkgs; [
      black
      binutils
      bottom
      buildah
      carapace
      cargo
      ccls
      clang-tools
      cmake
      codespell
      commitlint
      devenv
      direnv
      eza
      fd
      fish
      ghc
      go
      golangci-lint
      gotools
      gopass
      gopass-jsonapi
      git-credential-gopass
      hadolint
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
      isort
      istioctl
      jdk11
      jq
      kind
      krew
      kubectl
      kubernetes-helm
      lazygit
      ledger
      lemminx
      lua-language-server
      lua51Packages.lua
      lua51Packages.luarocks
      # lua51Packages.magick
      luajitPackages.luacheck
      mosh
      mypy
      nil
      nodejs
      nodePackages.bash-language-server
      nodePackages.jsonlint
      nodePackages.vscode-langservers-extracted
      (nerdfonts.override {
        fonts = [
          "AnonymousPro"
          "Hack"
          "Inconsolata"
          "Meslo"
          "SourceCodePro"
        ];
      })
      nixfmt-rfc-style
      nil
      nix-index
      pandoc
      procs
      python312
      python312Packages.pip
      python312Packages.virtualenv
      pylint
      pyright
      reckon
      ripgrep
      rust-analyzer
      rustc
      sd
      shellcheck
      skim
      stylua
      tree-sitter
      universal-ctags
      unstable.yq-go
      ueberzugpp
      vale
      imagemagick
      yamllint
      yaml-language-server
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
        CARGO_HOME = "$HOME/.cargo";
        DOTFILES = "$FLAKE";
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
        ZSH_CACHE_DIR = "$HOME/.cache/zsh";
        ZSH_CONFIG = "${config.xdg.configHome}/zsh";
      };
  };
  programs.bat = {
    enable = true;
    config.theme = "base16";
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.home-manager.enable = true;
  programs.wezterm = {
    enable = true;
    package = pkgs.unstable.wezterm;
    extraConfig = builtins.readFile ../../wezterm/wezterm.lua;
  };
  programs.zoxide.enable = true;
  xdg.enable = true;
  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
  };
}
