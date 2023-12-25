{ email }: {
  aliases = { p4 = "/usr/local/bin/git-p4"; };
  delta.enable = true;
  enable = true;
  extraConfig = {
    core = { editor = "nvim"; };
    credential = { helper = "store"; };
    diff = { tool = "nvim"; };
    difftool.nvim = { cmd = "nvim -d $LOCAL $REMOTE"; };
    include = { path = "~/.gitalias"; };
    merge = { tool = "nvim"; };
    mergetool.nvim = {
      cmd = "nvim -d $LOCAL $BASE $REMOTE $MERGED -c 'wincmd J | wincmd ='";
    };
    pull = { rebase = false; };
    push.default = "current";
  };
  includes = [{ path = "~/.gitalias"; }];
  userEmail = email;
  userName = "Alberto Vázquez";
}
