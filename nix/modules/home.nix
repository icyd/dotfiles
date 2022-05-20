{ config, pkgs }:
let
    XDG = config.xdg;
in {
    file = {
        ".editorconfig".source = ../../editorconfig/.editorconfig;
        ".p10k.zsh".source = ../../zsh/p10k.zsh;
        ".k8s_aliases.zsh".source = ../../zsh/kubectl_aliases.zsh;
        ".gitalias".source = ../../git/gitalias.txt;
    };
    packages = with pkgs; [
        asdf-vm
        binutils
        cmake
        ccls
        dive
        docker
        exa
        (pkgs.callPackage ./go/gig/default.nix {})
        fd
        gcc
        gcc-arm-embedded
        gdb
        go_1_17
        gopass
        krew
        kubectl
        kubernetes-helm
        hyperfine
        jq
        jdk11
        neovim
        neovim-remote
        nodejs
        python3Minimal
        ripgrep
        rustup
        rust-analyzer
        sshfs
        stern
        sumneko-lua-language-server
        tree-sitter
        universal-ctags
        vifm
        yq-go
    ];
    sessionPath = [
        "/usr/local/bin"
        "$ASDF_DATA_DIR/shims"
        "$ASDF_DIR/bin"
        "$CARGO_HOME/bin"
        "$GOPATH/bin"
        "$HOME/.local/bin/"
        "$KREW_ROOT/bin"
    ];
    sessionVariables = {
        ASDF_CONFIG_FILE = "${XDG.configHome}/asdf/asdfrc";
        ASDF_DATA_DIR = "${XDG.dataHome}/asdf";
        ASDF_DIR="$HOME/.asdf";
        BROWSER = "firefox";
        DOTFILES = "$HOME/.dotfiles";
        GOPATH = "$HOME/go";
        NVIM_LISTEN_ADDRESS = "/tmp/nvimsocket";
        PAGER = "less";
        PASSWORD_STORE_GENERATED_LENGTH = 12;
        PY_VENV = "$HOME/.venv";
        WINEDLLOVERRIDES = "winemenubuilder.exe=d";
        XDG_CONFIG_HOME = "${XDG.configHome}";
        ZSH_CACHE_DIR = "$HOME/.cache/zsh";
        ZSH_CONFIG = "${XDG.configHome}/zsh";
    };
}
