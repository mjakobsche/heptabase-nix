## Heptabase nix 
**A simple way to install and update Heptabase on NixOS**

### Why
To solve the problem with mandatory Heptabase updates every now and then, which block users from accessing the app until a new version appears in nixpkgs.

Here, a GitHub workflow periodically checks for new releases on the [Heptabase repo](https://github.com/heptameta/project-meta/releases), ensuring the latest version of the app is available for installation on NixOS.

You can also clone this repo and update the nix expression manually - on demand - by running the provided script.

### Usage
To install: `nix profile install github:mjakobsche/heptabase-nix`

To update: `nix profile upgrade heptabase-nix --refresh`

-OR-

Run manual update: clone this repo, run `update.sh` and execute `nix profile install`

### Disclaimer
The default.nix file is based on the nixpkgs implementation.
