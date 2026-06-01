{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    site-secrets = {
      url = "github:sffjunkie/site-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree = {
      url = "github:vic/import-tree";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index = {
      url = "github:nix-community/nix-index";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };

    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zmx = {
      url = "github:neurosnap/zmx";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      ns = "looniversity";
      lib = nixpkgs.lib.extend (import ./lib { inherit lib ns; });

      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      siteModules = [
        (inputs.import-tree ./config/site)
        (inputs.import-tree ./config/option/site)
        (inputs.import-tree ./config/fixes)
      ];

      hostModules = [
        ./config/overlay
        ./config/user/user/common/host

        inputs.disko.nixosModules.disko
        # inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
        inputs.nurpkgs.modules.nixos.default

        inputs.site-secrets.nixosModules.default
        inputs.site-secrets.nixosModules.api_key
        inputs.site-secrets.nixosModules.automation
        inputs.site-secrets.nixosModules.backup
        inputs.site-secrets.nixosModules.location
        inputs.site-secrets.nixosModules.network
        inputs.site-secrets.nixosModules.service
        inputs.site-secrets.nixosModules.tool

        inputs.site-secrets.nixosModules.sdk
        inputs.site-secrets.nixosModules.sysadmin
        inputs.site-secrets.nixosModules.nixos

        (inputs.import-tree ./config/module/host)
        (inputs.import-tree ./config/role/host)
      ];

      homeModules = [
        home-manager.nixosModules.default
        {
          config = {
            home-manager = {
              useGlobalPkgs = true;

              extraSpecialArgs = {
                inherit inputs ns;
              };

              sharedModules = [
                ./config/user/user/common/home

                inputs.sops-nix.homeManagerModules.sops
                inputs.nixvim.homeModules.nixvim
                inputs.wayland-pipewire-idle-inhibit.homeModules.default

                (inputs.import-tree ./config/option/home)
                (inputs.import-tree ./config/module/home)
                (inputs.import-tree ./config/role/home)
              ];
            };
          };
        }
      ];

      mkNixosSystem =
        { modules, ... }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              lib
              ns
              ;
          };

          modules = modules ++ siteModules ++ hostModules ++ homeModules;
        };

      mkNixosISO =
        {
          modules,
          ...
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit lib ns;
          };

          modules = modules ++ siteModules ++ hostModules;
        };

    in
    {
      meta = {
        description = "Looniversity Site Configuration";
        homepage = "https://github.com/sffjunkie/siteconfig";
        license = lib.licenses.mit;
      };

      nixosConfigurations = {
        # Security
        pinky = mkNixosSystem {
          modules = [
            ./config/host/pinky
            ./config/user/user/sysadmin
          ];
        };

        # Services
        thebrain = mkNixosSystem {
          modules = [
            ./config/host/thebrain
            ./config/user/user/dbadmin
            ./config/user/user/sysadmin
            ./config/user/group/media
          ];
        };

        # Workstation
        furrball = mkNixosSystem {
          modules = [
            ./config/host/furrball
            ./config/user/user/sdk
            ./config/user/user/sysadmin
            ./config/user/group/media
          ];
        };

        # Storage
        babs = mkNixosSystem {
          modules = [
            ./config/host/babs
            ./config/user/user/sysadmin
            ./config/user/group/media
          ];
        };

        # Laptop
        buster = mkNixosSystem {
          modules = [
            ./config/host/buster
            ./config/user/user/sdk
            ./config/user/user/sysadmin
            ./config/user/group/media
          ];
        };

        # Installer ISO - Use `nixos-rebuild build-image`
        installer = mkNixosISO {
          modules = [
            ./config/installer/looniversity-minimal.nix
          ];
        };
      };

      devShells = forAllSystems (pkgs: {
        default = import ./devshell { inherit pkgs; };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);

      # The nix devShell above adds a `nut` function which runs the tests
      # under the `unitTests` attribute
      unitTests = forAllSystems (
        pkgs:
        lib.nut.run {
          dir = ./test;
          inherit lib pkgs ns; # Needed by test functions
          # Optional attrs
          # include = ".*_test\.nix";
          # exclude = "";
          # quiet = false;
        }
      );
    };
}
