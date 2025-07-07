{
  config,
  pkgs,
  ...
}: {
  home.username = "stein";
  home.homeDirectory = "/home/stein";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    lua-language-server
    stylua

    nixd
    alejandra
  ];
}
