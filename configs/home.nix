{ config, pkgs, ... }:

{
  home.username = "ubuntu";
  home.homeDirectory = "/home/ubuntu";

  home.packages = [
    pkgs.hello
    pkgs.tree
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
  programs.bat.enable = true;

}
