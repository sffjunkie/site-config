{
  config,
  lib,
  ...
}:
let
  port = lib.looniversity.network.serviceHandlerMainPort config "homepage-dashboard";
in
{
  config = {
    services.homepage-dashboard = {
      listenPort = port;

      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
          };
        }
      ];
    };
  };
}
