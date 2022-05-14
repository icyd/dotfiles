{ lib, ... }:
let
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
    fzfctrlTOpts = [
        "--preview={}"
        "--preview-window=:hidden"
        "--height=20%"
    ];
in {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    defaultCommand = fzfDefaultCmd;
    defaultOptions = fzfDefaultOpts;
    fileWidgetCommand = "${fzfDefaultCmd} --type d";
    fileWidgetOptions = fzfctrlTOpts;
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = fzfctrlTOpts;
    historyWidgetOptions = fzfctrlTOpts;
}
