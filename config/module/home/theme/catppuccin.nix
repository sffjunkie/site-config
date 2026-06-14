{ config, ... }:
{
  config = {
    catppuccin = {
      enable = true;
      autoEnable = true;

      flavor = config.looniversity.user.theme.catppuccin.flavor;

      cursors = {
        enable = true;
        accent = config.looniversity.user.theme.catppuccin.accent;
      };
    };
  };
}
