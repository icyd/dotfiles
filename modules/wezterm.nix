{lib, ...}: {
  flake.modules.homeManager.base = {
    config,
    pkgs,
    ...
  }: {
    programs.wezterm = {
      enable = true;
      package = pkgs.unstable.wezterm;
      extraConfig =
        lib.optional (config.lib.stylix ? colors) (with config.lib.stylix.colors.withHashtag; ''
          local tab_active_color = "${base0B}"
          local tab_hover_color = "${base0A}"
        '')
        ++ [
          (builtins.readFile ../config/wezterm/wezterm.lua)
        ]
        |> lib.mkMerge;
    };
  };
}
