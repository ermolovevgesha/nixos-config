{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;
  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    inputs.noctalia.homeModules.default

    ./vscode.nix
    ./fish.nix
    ./starship.nix
  ];

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  home.packages = with pkgs; [
    alacritty
    dust
    eza
    rustup
    gpu-screen-recorder
    ncdu

    seahorse

    element-desktop
    telegram-desktop
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--enable-gpu-rasterization"
      ];
    })
    yandex-music
    
    drawio
    anki-bin
    zathura
    
    fzf
    wl-clipboard

    docker
    docker-compose
    lazydocker

    lazygit

    ffmpegthumbnailer
    imagemagick
    poppler

    uv

    colloid-gtk-theme
    colloid-icon-theme
    rose-pine-gtk-theme
  ];

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
        image_quality = 90;
      };
    };
  };

  programs.noctalia = {
    enable = true;
    settings = {
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16"; # или "Dracula"
      italic-text = "always";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      shell = "fish";
      font_size = 11;
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
  };

  programs.obsidian = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  home.file.".vscode/argv.json".text = builtins.toJSON {
    "password-store" = "gnome-libsecret";
  };

  xdg.desktopEntries = {
    "org.freedesktop.IBus.Setup" = {
      name = "IBus Preferences";
      noDisplay = true;
    };
    "htop" = {
      name = "Htop";
      noDisplay = true;
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" "toml" "rust" "python" "ruff" "gruvbox" ];
    userSettings = {
      theme = {
        mode = "dark";
        dark = "Gruvbox Dark Hard";
        light = "Gruvbox Dark Soft";
      };
      
      buffer_font_size = 15;
      ui_font_size = 15;

      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
    };
  };
}
