{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.cli.starship;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.starship = {
    enable = mkEnableOption "starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = {
        format = "$directory$git_branch$git_commit$git_state$git_metrics$cmd_duration$fill$direnv$env_var$python$nodejs$line_break$username$hostname$character";
        username = {
          format = "[$user]($style)";
          # show_always = true;
        };
        hostname = {
          format = "[@$hostname]($style) ";
          # ssh_only = false;
        };
        directory = {
          truncation_symbol = "…/";
          truncate_to_repo = false;
        };
        fill = {
          symbol = " ";
        };
        direnv = {
          disabled = false;
          style = "green";
          format = "[$symbol$allowed ]($style)";
          symbol = "direnv=";
          allowed_msg = "󰄬";
        };
        env_var.DEVENV_ROOT = {
          style = "green";
          format = "[devenv ]($style)";
        };
        env_var.NIX_DEVSHELL_PROJECT = {
          style = "green";
          format = "[devshell=$env_value ]($style)";
        };
        python = {
          python_binary = "python3";
          style = "green";
          symbol = "";
          format = "[python=(\${version} )(venv=$virtualenv )]($style)";
        };
        nodejs = {
          style = "green";
          format = "[node@($version )]($style)";
        };
      };
    };
  };
}
