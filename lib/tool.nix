{ ns, ... }:
let
  # getToolModule :: attrSet -> str -> str
  # Gets a hosts network device given an alias
  getToolModule = config: toolName: config.${ns}.tools.${toolName}.module;

  # getToolPort :: attrSet -> str -> int
  getToolPort = config: toolName: config.${ns}.tools.${toolName}.port;
in
{
  inherit getToolModule getToolPort;
}
