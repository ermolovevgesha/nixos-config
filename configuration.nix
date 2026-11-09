{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  # Kernel and Hardware
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "usbmon" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        FastConnectable = false;
        ReconnectAttempts = 0;
      };
    };
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.checkReversePath = false;
  };

  # Time and Locale
  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "en_US.UTF-8";

  # Display and Desktop Environment
  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome = {
    gnome-keyring.enable = true;
    core-apps.enable = false;
    rygel.enable = false;
  };
  security.pam.services.login.enableGnomeKeyring = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-color-manager
  ];

  # Services
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  documentation.doc.enable = false;

  # Sound with Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User Account
  users.users."evgeniye" = {
    isNormalUser = true;
    description = "Evgeniy Ermolov";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  # Shell and Desktop Programs
  programs.fish.enable = true;
  programs.niri.enable = true;
  programs.amnezia-vpn.enable = true;
  virtualisation.docker.enable = true;

  # Nix Helper
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  programs.nix-ld.enable = true;

  # Nix Package Manager settings
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    udiskie
    chromium
    amnezia-vpn
    stdenv.cc.cc.lib
    zlib
    glibc
    openssl
    zip
    unzip
  ];

  # Fonts configuration
  fonts = {
    packages = with pkgs; [
      font-awesome
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      inter
      roboto
    ];

    fontconfig.defaultFonts = {
      serif = [ "Liberation Serif" "Noto Serif" ];
      sansSerif = [ "Inter" "Liberation Sans" "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" "JetBrains Mono" ];
    };
  };

  # XDG Desktop Portals configuration for native file pickers in Niri
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gnome" "gtk" ];
  };

  # Environment variables for portals and Qt apps
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
    TDESKTOP_USE_GTK_FILE_DIALOG = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Home Manager
  home-manager = {
    backupCommand = "filename=$1; rm -rf \"$filename.backup\"; mv \"$filename\" \"$filename.backup\"";
    extraSpecialArgs = { inherit inputs; };
    users.evgeniye = import ./home.nix;
  };

  system.stateVersion = "26.05";
}
