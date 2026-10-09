{
  flake.modules.homeManager.base = {pkgs, ...}: {
    stylix.targets.ghostty.fonts.override = {
      sizes.terminal = 12;
    };
    programs.ghostty = {
      enable = true;
      package = pkgs.mv.tip.ghostty-bin;
      settings = {
        command = "$SHELL -c nu";
        copy-on-select = "clipboard";
        fullscreen = "true";
        macos-option-as-alt = true;
        working-directory = "home";
        keybind = [
          "ctrl+a=activate_key_table_once:tmux"
          "tmux/a=text:\\x01"
          "tmux/minus=new_split:down"
          "tmux/backslash=new_split:right"
          "tmux/z=toggle_fullscreen"
          "tmux/c=new_tab"
          "tmux/n=next_tab"
          "tmux/p=previous_tab"
          "tmux/shift+digit_6=goto_tab:1"
          "tmux/shift+digit_4=last_tab"
          "tmux/digit_1=goto_tab:1"
          "tmux/digit_2=goto_tab:2"
          "tmux/digit_3=goto_tab:3"
          "tmux/digit_4=goto_tab:4"
          "tmux/digit_5=goto_tab:5"
          "tmux/digit_6=goto_tab:6"
          "tmux/digit_7=goto_tab:7"
          "tmux/digit_8=goto_tab:8"
          "tmux/digit_9=goto_tab:9"
          "tmux/digit_0=goto_tab:0"
          "tmux/x=close_surface"
          "tmux/shift+digit_7=close_tab"
          "tmux/shift+equal=equalize_splits"
          "tmux/shift+k=resize_split:up,10"
          "tmux/shift+l=resize_split:right,10"
          "tmux/shift+j=resize_split:down,10"
          "tmux/shift+h=resize_split:left,10"
          "tmux/escape=deactivate_key_table"
          "unconsumed:alt+k=goto_split:up"
          "unconsumed:alt+l=goto_split:right"
          "unconsumed:alt+j=goto_split:down"
          "unconsumed:alt+h=goto_split:left"
          "unconsumed:alt+shift+k=resize_split:up,10"
          "unconsumed:alt+shift+l=resize_split:right,10"
          "unconsumed:alt+shift+j=resize_split:down,10"
          "unconsumed:alt+shift+h=resize_split:left,10"
        ];
      };
    };
  };
}
