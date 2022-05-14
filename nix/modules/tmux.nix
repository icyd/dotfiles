{ lib, pkgs  }:
let
    customTmuxPlugins = pkgs.callPackage ./tmux-custom-plugins.nix {};
in {
    enable = true;
    clock24 = true;
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "screen-256color";
    tmuxp.enable = true;
    extraConfig = lib.strings.fileContents ../../../tmux/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
        sensible
        copycat
        logging
        sessionist
        tmux-fzf
        fzf-tmux-url
        {
            plugin = continuum;
            extraConfig = ''
                set -g @continuum-restore 'off'
                set -g @continuum-boot-options 'alacritty,fullscreen'
            '';
        }
        {
            plugin = resurrect;
            extraConfig = ''
                set -g @resurrect-capture-pane-contents 'on'
                set -g @resurrect-strategy-nvim 'session'
            '';
        }
        customTmuxPlugins.tmux-gopass
    ];
}
