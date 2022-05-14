{ email }:
{
    enable = true;
    userName = "Alberto Vázquez";
    userEmail = email;
    aliases = {
        p4 = "/usr/local/bin/git-p4";
    };
    extraConfig = {
        diff = {
            tool = "nvr";
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
    };
}
