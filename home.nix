{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    waybar
    fuzzel
    rofi
    hyprlock
    alacritty
    swww
    yazi
    dust
    eza
    neovim
    rustup      

    colloid-gtk-theme
    colloid-icon-theme
    rose-pine-gtk-theme
  ];

  programs.waybar = {
    enable = true;
  };

  home.file.".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
  home.file.".config/waybar/style.css".source = ./waybar/style.css;

  home.file.".config/waybar/scripts/drun.sh" = {
    source = ./rofi/drun.sh;
    executable = true;
  };
  home.file.".config/waybar/scripts/powermenu.sh" = {
    source = ./rofi/powermenu.sh;
    executable = true;
  };

  home.file.".config/rofi-themes/config.rasi".source = ./rofi/config.rasi;
  home.file.".config/rofi-themes/config.powermenu.rasi".source = ./rofi/config.powermenu.rasi;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.zsh = {
    enable = true; 
    syntaxHighlighting.enable = true;
  };
}
