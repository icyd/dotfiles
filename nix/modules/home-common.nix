{ config, lib, pkgs, nix-colors, email, mypkgs ? [], mypaths ? [] }:
let
    XDG = config.xdg;
in {
    imports = [
      nix-colors.homeManagerModule
    ];
    colorscheme = nix-colors.colorSchemes.gruvbox-dark-medium;
    fonts.fontconfig.enable = true;
    home.file = {
        ".editorconfig".source = ../../editorconfig/.editorconfig;
        ".p10k.zsh".source = ../../zsh/p10k.zsh;
        ".k8s_aliases.zsh".source = ../../zsh/kubectl_aliases.zsh;
        ".gitalias".source = ../../git/gitalias.txt;
    };
    home.sessionPath = [
        "/usr/local/bin"
        "$ASDF_DATA_DIR/shims"
        "$ASDF_DIR/bin"
        "$CARGO_HOME/bin"
        "$GOPATH/bin"
        "$HOME/.local/bin/"
        "$KREW_ROOT/bin"
    ] ++ mypaths;
    home.packages = with pkgs; [
      asdf-vm
      dive
      exa
      (pkgs.callPackage ./go/gig/default.nix {})
      fd
      gcc
      gdb
      go_1_17
      gopass
      gopass-jsonapi
      krew
      kubectl
      kubernetes-helm
      hyperfine
      jq
      jdk11
      mosh
      neovim
      neovim-remote
      nodejs
      python3Minimal
      ripgrep
      rustup
      rust-analyzer
      stern
      tree-sitter
      universal-ctags
      yq-go
    ] ++ mypkgs;
    home.sessionVariables = {
        ASDF_CONFIG_FILE = "${XDG.configHome}/asdf/asdfrc";
        ASDF_DATA_DIR = "${XDG.dataHome}/asdf";
        ASDF_DIR="$HOME/.asdf";
        BROWSER = "firefox";
        DOTFILES = "$HOME/.dotfiles";
        GOPATH = "$HOME/go";
        NVIM_LISTEN_ADDRESS = "/tmp/nvimsocket";
        ORGMODE_HOME = "$HOME/Nextcloud";
        PAGER = "less";
        PASSWORD_STORE_GENERATED_LENGTH = 12;
        PY_VENV = "$HOME/.venv";
        VIMWIKI_HOME = "$HOME/Nextcloud";
        WINEDLLOVERRIDES = "winemenubuilder.exe=d";
        XDG_CONFIG_HOME = "${XDG.configHome}";
        ZSH_CACHE_DIR = "$HOME/.cache/zsh";
        ZSH_CONFIG = "${XDG.configHome}/zsh";
    };
}
