{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [  ];
  
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;

  imports = [ <home-manager/nix-darwin> ];

  home-manager = {
    verbose = true;
    backupFileExtension = "hm_bak~";
    useUserPackages = true;
    useGlobalPkgs = true;
    users."<USERNAME>" = {
      home.packages = with pkgs; [ 
        hello
        tree
        bat
      ];  
      programs = {
        home-manager.enable = true;
        zsh = {
          enable = true;
          enableCompletion = true;
          enableAutosuggestions = true;
          shellAliases = {
            ls = "ls --color";
            ll = "ls -la --color";
          };
        };
        git = {
          enable = true;
          userName = "<USERNAME>";
          userEmail = "<EMAIL>";
          aliases = {
            prettylog = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
          };
          extraConfig = {
            github.user = "<USERNAME>";
            color.ui = true;
          };
        };
        ssh = {
          enable = true;
          matchBlocks = {
            gondolin = {
              hostname = "<HOSTNAME>";
              user = "<USERNAME>";
              port = 22;
            };
          };
        };
        starship.enable = true;
        vim.enable = true;
      };
    };
  };
 
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [ "FiraCode" ];
      })
    ];
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        # tilesize = 16;
      };
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
      };
      trackpad = {
        TrackpadThreeFingerDrag = true;
        Clicking = true; 
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  system.stateVersion = 4;
}
