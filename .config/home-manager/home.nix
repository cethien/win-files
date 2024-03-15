{ config, pkgs, lib, ... }:

{
  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = "23.05"; # dont change

  home.packages = [
    pkgs.curl
    pkgs.zip
    pkgs.unzip
    pkgs.wget
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.ripgrep
    pkgs.fzf
    pkgs.oh-my-posh

    pkgs.gnumake

    pkgs.ansible

    pkgs.wgo
    pkgs.gopls
    pkgs.go-tools
    pkgs.go-migrate
    pkgs.hugo
    pkgs.protobuf
    pkgs.protoc-gen-go

    pkgs.bun
    pkgs.jdk8
    pkgs.lua

    # pkgs.warp-terminal
    pkgs.gimp
    pkgs.inkscape
    # pkgs.ocenaudio
  ];

  home.activation = {
    checkEnvVars = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -z "$WSLENV" ] || [ -z "$USERPROFILE" ] || [ -z "$POSH_THEMES_PATH" ]; then
        echo "WSLENV / needed variables from WSLENV could not be loaded. Exiting"
        exit 1
      fi
    '';
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      sudo = "sudo ";
      apt = "nala";

      cd = "z";
      ll = "eza -la --icons --group-directories-first --git";
      ls = "eza -a --icons --group-directories-first --git";
      tree = "eza -T --icons";
      grep = "rg";
      cat = "bat -p";
      find = "fd";
      vi = "nvim";
      vim = "nvim";

      init = ". $HOME/scripts/init.sh";
      update = ". $HOME/scripts/update.sh";
      reload = ". $HOME/.profile";

      sync = "git pull && home-manager switch";

      # git
      g = "git";
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gco = "git checkout";
      gcb = "git checkout -b";
      gcp = "git cherry-pick";
      gcl = "git clone";
      gpl = "git pull";
      gpm = "git pull --merge";
      gps = "git push";
      gpf = "git push --force";

    };

    profileExtra = ''
      if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then
        . "$HOME"/.nix-profile/etc/profile.d/nix.sh;
      fi
    '';

    initExtra = ''
      eval "$(oh-my-posh init bash --config $POSH_THEMES_PATH/custom/negligible.omp.json)"
    '';
  };

  programs.zoxide = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number
    '';
  };

  programs.git = {
    enable = true;
    userName = "cethien";

    aliases.ignore = "!gi() { curl -fsSL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";

    diff-so-fancy.enable = true;
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";

      aliases = {
        co = "pr checkout";
        pv = "pr view";
        pc = "pr create";
        rcp = "repo create --private";
        rc = "repo create";
      };
    };
  };

  programs.go = {
    enable = true;

    goPath = "go";
    goBin = "go/bin";
  };
}
