# Enter the Looniversity

![OS: NixOS](https://img.shields.io/badge/OS-NixOS-6e9bcb?logo=NixOS)
![License](https://img.shields.io/github/license/sffjunkie/siteconfig)
![GitHub repo size](https://img.shields.io/github/repo-size/sffjunkie/siteconfig)
![GitHub top language](https://img.shields.io/github/languages/top/sffjunkie/siteconfig)
![GitHub last commit](https://img.shields.io/github/last-commit/sffjunkie/siteconfig)

## Code Structure

- `config` - the configuration of the looniversity
- `devshell` - dev shell for building machines
- `lib` - Nix functions
- `test` - tests to be run by `nut.nix`

### `config`

- `host` - host machine configuration
- `module` - NixOS modules
- `overlay` - add packages to the `pkgs` instance
- `role` - groups NixOS modules into roles to apply multiple modules with a single configuration option e.g. `games_machine`
- `site` - site configuration
- `user` - user and group definitions

### `devshell`

Creates a development shell that provides various scripts to build host's NixOS configuration, deploy
to bare machines, run tests, and others.

### `lib`

Various library functions

- `ipv4.nix` - Manipulate IPv4 addresses
- `network.nix` - Retrieve info dfrom the site config
- `nut.nix` - Runs test functions

### `test`

Test functions to check the `lib` functions.

## Hosts

The following hosts are currently defined...

- `babs` - Storage server
- `buster` - Laptop
- `furrball` - Workstation
- `pinky` - Firewall/Looniversity Access (<span style="color: orange;">Not yet deployed</span>)
- `thebrain` - Services provided to the Looniversity
