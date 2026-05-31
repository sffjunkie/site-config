{
  config,
  ...
}:
let
  username = "sdk";
  mkHome = p: "/home/${username}/${p}";
in
{
  config = {
    services.restic.backups.sdk_local = {
      user = username;
      initialize = true;
      paths = map mkHome [
        "development"
        "persona"
        "pictures"
        "secrets"
      ];
      exclude = [
        "__pycache__"
        ".mypy_cache"
        ".pdm-build"
        ".pytest_cache"
        ".ruff_cache"
        ".tox"
        ".venv"
        "**/obj/"
      ];
      repository = "/home/${username}/backup/";
      passwordFile = config.sops.secrets."restic/repositories/sdk/local/password".path;
    };

    system.activationScripts."restic_sdk_local" = ''
      mkdir /home/${username}/backup 2>/dev/null && chown sdk:users /home/${username}/backup
    '';
  };
}
