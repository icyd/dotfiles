{
  flake.modules.homeManager.git = {
    config,
    pkgs,
    ...
  }: {
    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
      };
      git = let
        ssh_dir = "${config.home.homeDirectory}/.ssh";
      in {
        enable = true;
        settings = {
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
        enableNushellIntegration = false;
        settings = {
          os = (nvim: {
            edit = ''if ($env | get -o NVIM | is-empty) {${nvim} -- {{filename}}} else {${nvim} --server $env.NVIM --remote-send "q" ; ${nvim} --server $env.NVIM --remote-tab {{filename}}}'';
            editAtLine = ''if ($env | get -o NVIM | is-empty)  {${nvim} +{{line}} -- {{filename}}} else {${nvim} --server $env.NVIM --remote-send "q" ; ${nvim} --server $env.NVIM --remote-tab {{filename}} ; ${nvim} --server $env.NVIM --remote-send ":{{line}}<CR>"}'';
            editAtLineAndWait = "${nvim} {{filename}}";
            openDirInEditor = ''if ($env | get -o NVIM | is-empty) {${nvim} -- {dir}}} else {${nvim} --server $env.NVIM --remote-send "q" ; ${nvim} --server $env.NVIM --remote-tab {{dir}}}'';
            editInTerminal = true;
          }) "nvim";
        };
      };
    };
  };
}
