{ config, pkgs, lib, ... }:

{
  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = "23.05"; # dont change

  home.activation = {
    checkEnvVars = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -z "$WSLENV" ] || [ -z "$USERPROFILE" ] || [ -z "$POSH_THEMES_PATH" ]; then
        echo "WSLENV / needed variables from WSLENV could not be loaded. Exiting"
        exit 1
      fi
    '';

    symlinkToWindows = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -e "$HOME"/.gitconfig ]; then
        ln -s "$USERPROFILE"/.gitconfig "$HOME"/.gitconfig;
      fi

      if [ ! -e "$HOME"/.config/nvim ]; then
        ln -s "$USERPROFILE"/AppData/Local/nvim "$HOME"/.config/nvim;
      fi
    '';
  };

  home.packages = [
    pkgs.curl
    pkgs.git
    pkgs.wget
    pkgs.bat
    pkgs.eza
    pkgs.ripgrep
    pkgs.neovim
    pkgs.oh-my-posh

    pkgs.direnv
    pkgs.gnumake

    pkgs.go
    pkgs.wgo
    pkgs.gopls
    pkgs.go-tools

    pkgs.bun
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ll = "eza -la --icons --group-directories-first --git";
      ls = "eza -a --icons --group-directories-first --git";
      tree = "eza -T --icons";
      grep = "rg";
      cat = "bat";
      vi = "nvim";
      vim = "nvim";

      sudo = "sudo ";
      apt = "nala";

      init = ". $HOME/scripts/init.sh";
      update = ". $HOME/scripts/update.sh";
      reload = "home-manager switch && . $HOME/.profile";
    };

    profileExtra = ''
      if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then
        . "$HOME"/.nix-profile/etc/profile.d/nix.sh;
      fi

      export GOPATH=$HOME/go
      export GOBIN=$GOPATH/bin
      export PATH=$PATH:$GOPATH/bin
    '';

    initExtra = ''
      eval "$(oh-my-posh init bash --config $POSH_THEMES_PATH/custom/negligible.omp.json)"
    '';
  };
}
