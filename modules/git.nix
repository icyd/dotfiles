flakeAttrs: {
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
        userEmail = flakeAttrs.lib.mkDefault "beto.v25@gmail.com";
        userName = flakeAttrs.lib.mkDefault "Alberto Vázquez";
      };
      lazygit = {
        enable = true;
        settings = {
          os = {
            editPreset = "nvim-remote";
          };
        };
      };
    };
  };
}
