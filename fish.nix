{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path --prepend "$HOME/.local/bin"
    '';

    shellAliases = {
      agy = "$HOME/.local/bin/agy";
      ll = "eza -l --icons";
      la = "eza -a --icons";
      lla = "eza -la --icons";
      icat = "kitty icat";
      nix-switch = "nh os switch";
    };

    shellAbbrs = {
      dtop = "lazydocker";
      dco  = "docker-compose";
    };

    plugins = with pkgs.fishPlugins; [
      { name = "done"; src = done.src; }
      { name = "autopair"; src = autopair.src; }
      { name = "fzf-fish"; src = fzf-fish.src; }
      { name = "colored-man-pages"; src = colored-man-pages.src; }
    ];
  };
}