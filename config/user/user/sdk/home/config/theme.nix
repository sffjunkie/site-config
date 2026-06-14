{ config, ... }:
{
  config = {
    looniversity.user.theme = {
      cursor = {
        name = "catppuccin-${config.looniversity.user.theme.catppuccin.flavor}-${config.looniversity.user.theme.catppuccin.accent}-cursors";
        size = 32;
      };

      lockscreen = {
        image = ./a2-nier-automata-art-nw-3840x2160.jpg;
      };
    };
  };
}
