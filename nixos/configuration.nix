{ config, lib, pkgs, ... }:
{
  imports =
    [ ./hardware-configuration.nix ];

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
    ];
  };


  fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	noto-fonts-cjk-sans
	font-awesome
  ];



  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
  ];


  system.stateVersion = "25.05"; 

}

