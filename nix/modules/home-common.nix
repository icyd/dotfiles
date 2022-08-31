{ config, lib, pkgs, nix-colors, email, mypkgs ? [], mypaths ? [], sessionVars ? {} }: {
    imports = [
      nix-colors.homeManagerModule
    ];
    colorscheme = nix-colors.colorSchemes.gruvbox-dark-medium;
    fonts.fontconfig.enable = true;
    home.file = {
        ".editorconfig".source = ../../editorconfig/.editorconfig;
        ".npmrc".source = ../../npm/.npmrc;
        ".p10k.zsh".source = ../../zsh/p10k.zsh;
        ".k8s_aliases.zsh".source = ../../zsh/kubectl_aliases.zsh;
        ".gitalias".source = ../../git/gitalias.txt;
    };
    home.sessionPath = [
        "/usr/local/bin"
        "$CARGO_HOME/bin"
        "$GOPATH/bin"
        "$HOME/.local/bin/"
        "$HOME/.krew/bin"
    ] ++ mypaths;
    home.packages = with pkgs; [
      # dnsutils-unstable
      exa
      fd
      krew
      kubectl
      kubernetes-helm
      hyperfine
      jq
      jdk11
      neovim-nightly
      neovim-remote
      nodejs
      python310
      python310Packages.pip
      python310Packages.virtualenv
      ripgrep
      stern
      tree-sitter
      universal-ctags
      yq-go
    ] ++ mypkgs;
    home.sessionVariables = {
        ASDF_DATA_DIR = "${config.xdg.dataHome}/asdf";
        BROWSER = "firefox";
        DOTFILES = "$HOME/.dotfiles";
        GOPATH = "$HOME/go";
        NVIM_SERVER = "/tmp/nvimsocket";
        ORGMODE_HOME = "$HOME/Nextcloud";
        PAGER = "less";
        PATH = "$ASDF_DATA_DIR/shims:$HOME/.npm-global/bin:$PATH";
        PASSWORD_STORE_GENERATED_LENGTH = 12;
        PY_VENV = "$HOME/.venv";
        VIMWIKI_HOME = "$HOME/Nextcloud";
        WINEDLLOVERRIDES = "winemenubuilder.exe=d";
        XDG_CONFIG_HOME = "${config.xdg.configHome}";
        ZSH_CACHE_DIR = "$HOME/.cache/zsh";
        ZSH_CONFIG = "${config.xdg.configHome}/zsh";
    } // sessionVars;
}
