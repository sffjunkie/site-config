{
  config,
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf osConfig.looniversity.desktop.environment.lde.enable {
    xdg.configFile = {
      "lwm" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/development/project/lwm${
          if osConfig.looniversity.desktop.window_manager.lwm.dev then ".develop" else ""
        }/src/lwm";
        recursive = true;
      };
    };
  };
}
