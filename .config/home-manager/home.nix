{ config, pkgs, lib, ... }:

{
  home.username = "cethien";
  home.homeDirectory = "/home/cethien";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.activation = {
    checkEnvVars = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -z "$WSLENV" ] || [ -z "$USERPROFILE" ] || [ -z "$POSH_THEMES_PATH" ]; then
        echo "WSLENV / needed variables from WSLENV could not be loaded. Exiting script"
        exit 1
      fi
    '';

    installScripts = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME"/.local/bin
      PATH="${pkgs.curl}/bin:${pkgs.unzip}/bin:${pkgs.gawk}/bin:$HOME/.local/bin:$PATH"
      curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
      curl -fsSL https://aliae.dev/install.sh | bash -s -- -d "$HOME/.local/bin"

      if ! grep -q 'eval "$(oh-my-posh init {{ .Shell }} --config $POSH_THEME)"' "$HOME/.bashrc"; then
        echo 'eval "$(oh-my-posh init {{ .Shell }} --config $POSH_THEME)"' >> "$HOME/.bashrc"
      fi
    '';

    symlinkToWindows = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -n "$USERPROFILE" ] && [ -n "$HOME" ]; then
        ln -sf "$USERPROFILE"/.gitconfig "$HOME"/.gitconfig
        ln -sf "$USERPROFILE"/AppData/Local/nvim "$HOME"/.config/nvim
        ln -sf "$USERPROFILE"/Documents/PowerShell/ "$HOME"/.config/powershell
      fi
    '';
  };

  home.sessionVariables = {
    POSH_THEME = "$POSH_THEMES_PATH/custom/negligible.omp.json";
  };

  home.sessionVariablesExtra = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';

  home.packages = [
    pkgs.curl
    pkgs.git
    pkgs.wget
    pkgs.bat
    pkgs.eza
    pkgs.ripgrep
    pkgs.neovim
    pkgs.gh
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
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
      reload = "home-manager switch && . $HOME/.bashrc";
    };
  };
}
