{ pkgs, email, ... }:
{
  programs.git = {
    delta.enable = true;
    enable = true;
    extraConfig = {
      core = {
        editor = pkgs.lib.getExe pkgs.nixvimin;
      };
      credential = {
        helper = "gopass";
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
      pull = {
        rebase = false;
      };
      push.default = "current";
    };
    includes = [ { path = ../../git/gitalias.txt; } ];
    userName = "Alberto Vázquez";
    userEmail = email;
  };
}
