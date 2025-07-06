{ config, lib, pkgs, ... }:
{
  imports =
    [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "stein-btw";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.waybar.enable = true;
  programs.firefox.enable = true;
  
  users.defaultUserShell = pkgs.zsh;

  services.openssh.enable = true;
  services.xserver.xkb.layout = "de";
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry;
    enableSSHSupport = true;
  };

  services.power-profiles-daemon.enable = true;

  users.users.stein = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
      neovim
      kitty
      git
      starship
      fzf
      eza
      bat
      btop
      ripgrep
      cargo
      rustc
      wofi
      fastfetch
      kdePackages.dolphin
      hyprshot
      dunst
      gcc
      clang
      cmake
      hypridle
      hyprpaper
      chezmoi
      wl-clipboard
      hyprpicker
      hyprlock
      alejandra
      gnupg
      pinentry-tty
      diff-so-fancy
      mpd-small
      waybar-mpris
      playerctl
      spotify
      power-profiles-daemon
      gamemode
      pavucontrol
      libayatana-appindicator
      discord
    ];
  };


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
  ];



  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
  ];


  system.stateVersion = "25.05"; 

}

