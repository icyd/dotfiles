{ email }:
{
    enable = true;
    userName = "Alberto Vázquez";
    userEmail = email;
    aliases = {
        p4 = "/usr/local/bin/git-p4";
    };
    includes = [
        { path = "~/.gitalias"; }
    ];
    delta.enable = true;
    extraConfig = {
        push.default = "current";
        core = {
            editor = "nvim";
        };
        diff = {
            tool = "nvim";
        };
        difftool.nvim = {
            cmd = "nvim -d $LOCAL $REMOTE";
        };
        merge = {
            tool = "nvim";
        };
        mergetool.nvim = {
            cmd = "nvim -d $LOCAL $BASE $REMOTE $MERGED -c 'wincmd J | wincmd ='";
        };
        credential = {
            helper = "store";
        };
        pull = {
            rebase = false;
        };
        include = {
            path = "~/.gitalias";
        };
    };
}
