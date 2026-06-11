{ config, ... }:
{
  config = {
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = config.looniversity.theme.catppuccin.flavor;

      cursors = {
        enable = true;
        accent = config.looniversity.theme.catppuccin.accent;
      };
    };
  };
}
