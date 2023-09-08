{ lib, pkgs  }:
let
    customTmuxPlugins = pkgs.callPackage ./tmux-custom-plugins.nix {};
in {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    keyMode = "vi";
    historyLimit = 10000;
    sensibleOnTop = true;
    shortcut = "a";
    tmuxp.enable = true;
    extraConfig = lib.strings.fileContents ../../tmux/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
        {
            plugin = prefix-highlight;
            extraConfig = ''
                my_session=""
                my_user_host="#[fg=green]#(whoami)#[default]@#H"
                my_date="#[fg=green]%h %d %H:%M#[default]"
                my_battery="#{battery_status_fg} #{battery_icon} #{battery_percentage}"
                my_is_zoomed="#[fg=black,bg=blue]#{?window_zoomed_flag, Z ,}#[default]"
                my_is_keys_off="#[fg=black,bg=grey]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"

                set -g @prefix_highlight_output_prefix ' '
                set -g @prefix_highlight_output_suffix ' '
                set -g @prefix_highlight_fg "black"
                set -g @prefix_highlight_bg "blue"
                set -g @prefix_highlight_show_copy_mode 'on'
                set -g @prefix_highlight_show_sync_mode 'on'
                set -g @prefix_highlight_prefix_prompt 'P'
                set -g @prefix_highlight_copy_prompt 'Copy'
                set -g @prefix_highlight_sync_prompt 'Sync'
                set -g @prefix_highlight_copy_mode_attr "fg=black,bg=blue"
                set -g @prefix_highlight_sync_mode_attr "fg=black,bg=blue"
                set -g @online_icon "#[fg=green] ﯱ #[default]"
                set -g @offline_icon "#[fg=red]  #[default]"
                set -g @batt_icon_status_charged ''
                set -g @batt_icon_status_charging ''
                set -g @batt_icon_status_discharging ''
                set -g @batt_icon_status_attached ''
                set -g @batt_icon_status_unknown ''
                set -g @batt_color_full_charge "#[fg=green]"
                set -g @batt_color_high_charge "#[fg=green]"
                set -g @batt_color_medium_charge "#[fg=orange]"
                set -g @batt_color_low_charge "#[fg=red]"
                set -g @sysstat_cpu_color_low "green"
                set -g @sysstat_cpu_color_medium "orange"
                set -g @sysstat_cpu_color_stress "red"
                set -g @sysstat_mem_color_low "green"
                set -g @sysstat_mem_color_medium "orange"
                set -g @sysstat_mem_color_stress "red"
                set -g @sysstat_swap_color_low "green"
                set -g @sysstat_swap_color_medium "orange"
                set -g @sysstat_swap_color_stress "red"

                set -g status-left "$my_session"
                set -g status-right "#{prefix_highlight}$my_is_keys_off$my_is_zoomed #{sysstat_cpu} | #{sysstat_mem} | #{sysstat_loadavg} | $my_user_host | $my_date $my_battery #{online_status}"
            '';
        }
        online-status
        battery
        sysstat
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
        {
            plugin = tmux-thumbs;
            extraConfig = ''
                set -g @thumbs-key F
                set -g @thumbs-alphabet dvorak-homerow
            '';
        }
        (customTmuxPlugins.tmux-gopass // {
            extraConfig = ''
                set -g @gopass-filter-program 'fzf'
                set -g @gopass-vertical-split-pane-key 'b'
                set -g @gopass-pane-percentage 20
            '';
        })
        better-mouse-mode
        jump
        fzf-tmux-url
        {
         plugin = tmux-fzf;
         extraConfig = ''
             TMUX_FZF_PREVIEW=0
             TMUX_FZF_LAUNCH_KEY="C-f"
         '';
        }
        logging
        sessionist
        yank
        extrakto
    ];
}
