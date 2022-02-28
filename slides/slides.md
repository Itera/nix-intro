---
marp: true
theme: uncover
_class: invert
paginate: true
_paginate: false
---

![w:160](https://upload.wikimedia.org/wikipedia/commons/2/28/Nix_snowflake.svg)
# **Nix**

---
### Content
- An introduction to [Nix] and how it operates
- how to write *declarative* platform-independent user environments with [Home Manager]
- how I configured the looks and feel of my MacBook using [Nix Darwin]
- how to use Nix to create *reproducible* development environments


[nix]: https://nixos.org
[Home Manager]: https://github.com/nix-community/home-manager
[Nix Darwin]: https://github.com/LnL7/nix-darwin

---
# Introduction

*What* and *why*

---
<!-- _class: left -->
# Terms
**`Derivation`** A Nix expression that describes everything that goes into a package build action
**`Store`** A self-contained store of all the software we need to bootstrap up to any particular package
**`Profile`** A set of packages in the Nix store that appear in the user’s PATH. 
**`Generation`** Versioned state of a profile

---
<!-- _class: left -->
# Terms
**`Channels`** A set of packages and expressions available for download (repository)
**`Closures`** The closures of a derivation is a list of all its dependencies, recursively, including absolutely everything necessary to use that derivation (= runtime dependencies)
**`Symlinks`** A file that contains a reference to another file

---
## Installation

**MacOS**
```
sh <(curl -L https://nixos.org/nix/install)
```

**Linux**
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**Windows (WSL2)**
```
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```

*See the latest instructions at: nixos.org/download*

---
<!-- _class: invert -->
# DEMO

`CLI`

<!--
DEMO: dependencies of a package will be built and referenced in the nix store.
Installation (on linux VM)
Verify installation: nix-env --version
Install package: nix-env -iA nixpkgs.hello
where is it installed?: which hello
check the symlink: readlink -f `which hello`
Install another package: nix-env -iA nixpkgs.tree

Profile and rollback
See binaries in /home/ubuntu/.nix-profile
See symlink of nix-profile: readlink /home/ubuntu/.nix-profile
See different profile-links at: /nix/var/nix/profiles/per-user/ubuntu
See generations with: nix-env --list-generations
nix-env --rollback
nix-env -G 2

Search packages: https://search.nixos.org/packages
-->

---
<!-- _class: left -->
# CLI 

`nix-env`  manages environments, profiles and their generations
`nix-store` queries and manipulates the store
`nix-channel` manages channels
`nix-shell` interactive sandbox
`nix-build` building derivations

---
<!-- _class: left -->
<!-- _header: CLI -->
## nix-env
<!--
The `nix-env` tool manages environments, profiles and their generations.
-->

`nix-env -i <pkg>` installs package to system
`nix-env -q` list installed packages
`nix-env --list-generations` lists generations 
`nix-env --rollback` switches to the previoous generation 
`nix-env -G <number>` switches to given generation 
`nix-env -u` will upgrade all packages in the environment

---
<!-- _class: left -->
<!-- _header: CLI -->
## nix-store
<!--
To query and manipulate the store, there's the nix-store command.
-->

``nix-store --query --references `which hello` `` 
Shows direct/immediate dependencies
``nix-store --query --referrers `which hello` ``
Shows reverse dependencies 
``nix-store --query --requisites `which hello` `` 
Lists runtime dependencies
``nix-store --query --tree `which hello` ``
Same but prettier. Lists runtime dependencies

---
## Home Manager

Going from CLI-commands to config files

---
<!-- _class: invert -->
# DEMO

`home-manager`

<!--
DEMO:
install Home Manager
vim /home/ubuntu/.config/nixpkgs/home.nix 
(home-manager edit)
add to config: home.packages = [ pkgs.hello pkgs.tree ];
delete installed packages: nix-env -e hello tree
install new config: home-manager switch

programs.bat.enable = true;
bat /home/ubuntu/.config/nixpkgs/home.nix
home-amanger switch
bat /home/ubuntu/.config/nixpkgs/home.nix

home-manager generations

Search programs: https://github.com/nix-community/home-manager/tree/master/modules/programs

Manual: https://rycee.gitlab.io/home-manager/
-->

---
<!-- _header: HOME MANAGER -->
## Installation

```

nix-channel --add https://github.com/nix-community/\
home-manager/archive/master.tar.gz home-manager

nix-channel --update

export NIX_PATH=$HOME/.nix-defexpr/channels:\
/nix/var/nix/profiles/per-user/root/channels\
${NIX_PATH:+:$NIX_PATH}

nix-shell '<home-manager>' -A install
```

*github.com/nix-community/home-manager#installation*

---
<!-- _header: HOME MANAGER -->
### /home/user/.config/nixpkgs/home.nix

```
{ config, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
```

`home-manager switch`

---

```
{ config, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = [
    pkgs.hello
    pkgs.tree
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

}
```

---
## Nix Darwin
Configuring MacOS with code

---
<!-- _class: invert -->
# DEMO

`nix-darwin`

<!--
DEMO:
install Nix Darwin
Change Dock-config
darwin-rebuild switch 

darwin-rebuild --list-generations

Nix Darwin Manual: https://daiderd.com/nix-darwin/manual/index.html
-->

---
<!-- _header: NIX DARWIN -->
### Installation


```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz\
-A installer


./result/bin/darwin-installer
```

*github.com/LnL7/nix-darwin#install*

---
<!-- _header: NIX DARWIN -->
### ~/.nixpkgs/darwin-configuration.nix

```
{ pkgs, ... }:

{
  environment.systemPackages = [ 
      pkgs.vim
    ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
```

`darwin-rebuild switch`

---
<!-- _header: NIX DARWIN -->

```
{
  system = {
    defaults = {
      dock = {
        autohide = true;
      };
      finder = {
        AppleShowAllExtensions = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
```

---

## Build environments
Creating *reproducible* development environments

---
<!-- _class: invert -->
# DEMO

`builds`

<!--
DEMO:
Python web app
try running python myapp.py: missing imports
nix-build
try running: ./result/bin/myapp  
try sourcing env: nix-shell default.nix
then running python myapp.py
-->

---
### Next steps

Flake: https://nixos.wiki/wiki/Flakes
NixOS: https://nixos.org/download.html#nixos-iso

---
<!-- _class: left -->
Resources:
https://nixos.org
https://github.com/nix-community/home-manager
https://rycee.gitlab.io/home-manager/
https://github.com/LnL7/nix-darwin
https://daiderd.com/nix-darwin/manual/index.html
https://nixcloud.io/main
https://www.youtube.com/results?search_query=Burke+Libbey+nixology
https://github.com/kradalby/dotfiles


<!-- STYLES -->

<style>
section.left h4, section.left p {
  text-align: left;
}
</style>