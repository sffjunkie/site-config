{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  ageKeyFile = "/home/sdk/.config/sops/age/keys.txt";
  mpdConfig = config.looniversity.music.mpd;
  inherit (lib.looniversity) disabled enabled;
in
{
  imports = [
    ./accounts
    ./config
    ./desktop
    ./ssh
  ];

  # config = osConfig.home-manager.users.${user}.config
  config = {
    home = {
      username = "sdk";
      homeDirectory = "/home/sdk";
      stateVersion = "23.05";
      sessionVariables = {
        MANWIDTH = 100;
        DEVELOPMENT_HOME = "$HOME/development";

        SOPS_AGE_KEY_FILE = ageKeyFile;
      };

      packages = [
        pkgs.python3
        pkgs.uv
        pkgs.rofi-clip
        pkgs.musicctl
        pkgs.volumectl
        pkgs.music-notify
      ];
    };

    looniversity = {
      user = {
        apps = {
          brain = "obsidian";
          browser = "firefox";
          clipboard = "rofi-clip";
          code_editor = "vscode";
          editor = "micro";
          file_manager = "ranger";
          launcher = "rofi-app-launcher";
          music_player = "ncmpcpp";
          pager = "bat";
          screenshot = "sshot";
          terminal = "ghostty";
        };

        controller = {
          audio = "pavucontrol";
          music = "musicctl";
          volume = "volumectl";
        };

        menu = {
          system = "rofi-system-menu";
          # user = "";
        };

        notifier = {
          general = "libnotify";
          music_track_change = "music-notify";
        };
      };

      audio = {
        easyeffects = disabled;
        qpwgraph = enabled;
      };

      cad = {
        freecad = enabled;
        sweethome3d = enabled;
      };

      cli = {
        atuin = enabled;
        bat = enabled;
        beancount = enabled;
        bottom = enabled;
        cava = enabled // {
          settings = {
            input = {
              method = "${mpdConfig.outputType}";
              source = "mpd.${mpdConfig.outputName}";
            };
          };
        };
        dircolors = enabled;
        exiftool = enabled;
        fd = enabled;
        feh = enabled;
        fzf = enabled;
        gh = enabled;
        git = enabled;
        htop = enabled;
        jc = enabled;
        jq = enabled;
        just = enabled;
        khal = enabled;
        lazydocker = enabled;
        lazygit = enabled;
        lsd = enabled;
        onefetch = enabled;
        pass = enabled;
        pulsemixer = enabled;
        ranger = enabled;
        ripgrep = enabled;
        slurm = enabled;
        starship = enabled;
        swayimg = enabled;
        worktrunk = enabled;
        youtubeDl = enabled;
        yq = enabled;
        yubikeyManager = enabled;
        zellij = disabled;
        zoxide = enabled;
      };

      desktop = {
        dunst = disabled;
        mako = enabled;
        wallpaper = enabled;
        lockscreen.swaylock = enabled;
        lockscreen.idle-inhibit = enabled;
      };

      development = {
        alejandra = enabled;
        delta = enabled;
        devenv = enabled;
        direnv = enabled;
        gnumake = enabled;
        nixfmt = enabled;
        pre-commit = enabled;
        shellcheck = enabled;
        treefmt = enabled;
      };

      editor = {
        micro = enabled;
        nixvim = enabled;
        vscode = enabled // {
          git = enabled;
          just = enabled;
          markdown = enabled;
          nix = enabled;
          python = enabled;
          shellcheck = enabled;
          toml = enabled;

          theme.catppuccin = enabled;
        };
      };

      game = {
        minesweeper = enabled;
        openmw = enabled;
        solitaire = enabled;
      };

      gui = {
        f3d = enabled;
        fava = enabled;
        firefox = enabled;
        google-chrome = enabled;
        brave = enabled;
        darktable = enabled;
        discord = enabled;
        gimp = enabled;
        gittyup = enabled;
        gnomeApps = enabled;
        gns3 = disabled;
        gramps = enabled;
        inkscape = enabled;
        libreoffice = enabled;
        mpv = enabled;
        obsidian = enabled;
        okular = enabled;
        picard = enabled;
        qutebrowser = enabled;
        streamdeck = enabled;
        thunderbird = enabled;
        walker = enabled;
        wofi = enabled;
        zathura = enabled;
      };

      keyboard = {
        input-remapper = disabled;
        hyper_super = enabled;
      };

      media = {
        pavucontrol = enabled;
        playerctl = enabled;
        spotify = enabled;
      };

      music = {
        mpd = enabled // {
          inherit (osConfig.users.users.sdk) uid;
        };
        ncmpcpp = enabled;
        rmpc = enabled;
      };

      print3d.orca-slicer = enabled;

      role = {
        podcaster = enabled;
      };

      script = {
        linkhandler = enabled;
        paths = enabled;
        sysinfo = enabled;
      };

      security = {
        keepassxc = enabled;
        gnome-passwords = enabled;
        gpg = disabled;
        passage = enabled;
        polkit-gnome = enabled;
      };

      service = {
        syncthing = enabled;
      };

      settings = {
        gnome = enabled;
      };

      shell = {
        nushell = enabled;
        zmx = enabled;
        zsh = enabled // {
          initContent = ''
            bindkey ^f autosuggest-accept
            edit() { command "''${EDITOR:-${config.looniversity.user.apps.editor}}" "$@"; }
            fm() { command "''${FILEMANAGER:-${config.looniversity.user.apps.file_manager}}" "$@"; }
          '';
        };
      };

      shellcmd = {
        nds = enabled;
      };

      storage = {
        udiskie = enabled;
        veracrypt = disabled;
      };

      system = {
        elephant = enabled;
        imagemagick = enabled;
        pywal = enabled;
        user-dirs = enabled;
      };

      terminal = {
        alacritty = disabled;
        kitty = enabled;
        ghostty = enabled;
      };

      theme = {
        rofi = enabled;
      };

      tui = {
        bagels = enabled;
      };

      wayland = {
        clipboard.cliphist = enabled;
        display = {
          kanshi = enabled;
          wdisplays = enabled;
        };
      };
    };

    programs.home-manager = enabled;

    sops = {
      age.keyFile = ageKeyFile;
    };

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.looniversity.theme.base16}.yaml";

      cursor = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 32;
      };

      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };

        sizes = {
          applications = 13;
          popups = 13;
          terminal = 13;
        };
      };

      image = ./a2-nier-automata-art-nw-3840x2160.jpg;

      polarity = "dark";

      targets = {
        firefox.profileNames = [ "default" ];
        vscode.enable = false;
      };
    };
  };
}
