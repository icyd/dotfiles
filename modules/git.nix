{
  flake.modules.homeManager.git = {
    config,
    pkgs,
    ...
  }: {
    programs = {
      git = let
        ssh_dir = "${config.home.homeDirectory}/.ssh";
      in {
        delta.enable = true;
        enable = true;
        extraConfig = {
          commit.gpgsign = true;
          commit.verbose = true;
          core.editor = pkgs.lib.getExe pkgs.nixvimin;
          credential.helper = "gopass";
          diff.tool = "nvim";
          difftool.nvim.cmd = "nvim -d $LOCAL $REMOTE";
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = "${ssh_dir}/allowed_signers";
          user.signingkey = "${ssh_dir}/id_ed25519.pub";
          merge.tool = "nvim";
          mergetool.nvim.cmd = "nvim -d $LOCAL $BASE $REMOTE $MERGED -c 'wincmd J | wincmd ='";
          pull.rebase = false;
          push.default = "current";
        };
        includes = [{path = ../config/git/gitalias.txt;}];
      };
      lazygit = {
        enable = true;
        settings = {
          os = {
            edit = ''if ("NVIM" in $env) {nvim --server $env.NVIM --remote-send "q" ; nvim --server $env.NVIM --remote-tab {{filename}}} else {nvim -- {{filename}}}'';
            editAtLine = ''if ("NVIM" in $env) {nvim --server $env.NVIM --remote-send "q" ; nvim --server $env.NVIM --remote-tab {{filename}} ; nvim --server $env.NVIM --remote-send ":{{line}}<CR>"} else {nvim +{{line}} -- {{filename}}}'';
            editAtLineAndWait = "nvim {{filename}}";
            openDirInEditor = ''if ("NVIM" in $env) {nvim --server $env.NVIM --remote-send "q" ; nvim --server $env.NVIM --remote-tab {{dir}}} else {nvim -- {dir}}}'';
          };
        };
      };
    };
  };
}
