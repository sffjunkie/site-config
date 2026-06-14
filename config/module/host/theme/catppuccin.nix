{ config, ... }:
{
  config = {
    catppuccin = {
      enable = true;
      autoEnable = true;

      flavor = config.looniversity.site.theme.catppuccin.flavor;

      cursors = {
        enable = true;
        accent = config.looniversity.site.theme.catppuccin.accent;
      };
    };
  };
}
