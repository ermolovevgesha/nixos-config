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

    docker-compose
    lazydocker

    lazygit

    ffmpegthumbnailer
    imagemagick
    poppler
    jq
    fd
    ripgrep
    p7zip
    imv
    mpv

    uv

    colloid-gtk-theme
    colloid-icon-theme
    rose-pine-gtk-theme
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      style = "compact";
      inline_height = 20;
      search_mode = "fuzzy";
      filter_mode_shell_up_key_binding = "directory";
    };
  };

  programs.television = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "natural";
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
        image_quality = 90;
      };
      opener = {
        edit = [
          { run = ''zeditor "$@"''; orphan = true; desc = "Zed"; }
          { run = ''code "$@"''; orphan = true; desc = "VS Code"; }
          { run = ''$EDITOR "$@"''; block = true; desc = "Terminal editor"; }
        ];
        pdf = [
          { run = ''firefox "$@"''; orphan = true; desc = "Firefox"; }
          { run = ''zathura "$@"''; orphan = true; desc = "Zathura"; }
        ];
        image = [
          { run = ''imv "$@"''; orphan = true; desc = "imv"; }
        ];
        video = [
          { run = ''mpv "$@"''; orphan = true; desc = "mpv"; }
        ];
        open = [
          { run = ''xdg-open "$1"''; orphan = true; desc = "System default"; }
        ];
      };
      open.rules = [
        { mime = "application/pdf"; use = [ "pdf" "open" ]; }
        { mime = "image/*"; use = [ "image" "open" ]; }
        { mime = "video/*"; use = [ "video" "open" ]; }
        { mime = "audio/*"; use = [ "video" "open" ]; }
        { mime = "text/*"; use = [ "edit" "open" ]; }
        { mime = "*"; use = [ "open" "edit" ]; }
      ];
    };
    keymap = {
      mgr.prepend_keymap = [
        { on = "<C-n>"; run = "shell --orphan 'nautilus .'"; desc = "Open in Nautilus"; }
        { on = "<C-e>"; run = "shell --orphan 'zeditor .'"; desc = "Open in Zed"; }
        { on = "<C-y>"; run = ''shell 'for f in "$@"; do printf "file://%s\n" "$f"; done | sed "s/ /%20/g" | wl-copy -t text/uri-list' ''; desc = "Copy file to clipboard"; }
      ];
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
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
