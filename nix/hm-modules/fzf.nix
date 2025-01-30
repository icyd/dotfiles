{ lib, config, ... }:
let
  cfg = config.my.fzf;
  fzfCtrlTOpts = [
    "--preview={}"
    "--preview-window=:hidden"
    "--height=20%"
  ];
  fzfDefaultCmd = lib.strings.concatStringsSep " " [
    "fd --hidden --ignore-case --follow"
    "--exclude .git --exclude node_modules"
    "--exclude .hg --exclude .svn"
    "--type f --type l"
  ];
  fzfDefaultOpts = [
    "--ansi"
    "--multi"
    "--reverse"
    "--height=40%"
    "--preview='bat --color=always --style=plain {}'"
    "--preview-window='right:66%'"
    "--bind='ctrl-d:page-down,ctrl-u:page-up,alt-u:preview-page-up,alt-d:preview-page-down'"
  ];
in
{
  options.my = {
    fzf.enable = lib.mkEnableOption "Enable module";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = fzfCtrlTOpts;
      defaultCommand = fzfDefaultCmd;
      defaultOptions = fzfDefaultOpts;
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = true;
      fileWidgetCommand = "${fzfDefaultCmd} --type d";
      fileWidgetOptions = fzfCtrlTOpts;
      historyWidgetOptions = fzfCtrlTOpts;
    };
  };
}
