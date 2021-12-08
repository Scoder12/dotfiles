{ lib, pkgs, ... }:

{
  # My desktop PC, running Pop! OS
  # Rationale: it is nice to have apt in a pinch or in a time-sensitive situation where
  #  I can't afford to waste time fighting with nix

  imports = [
    ./modules/base.nix
    ./modules/cli.nix
    ./modules/rust.nix
    ./modules/python.nix
    ./modules/vscode.nix
    ./modules/firefox.nix
    ./modules/i3.nix
    ./modules/guiutils.nix
    ./modules/tmux.nix
    ./modules/gtk.nix
    ./modules/flameshot.nix
    ./modules/fonts.nix
    ./modules/alacritty.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    SHELL = "${pkgs.zsh}/bin/zsh";
    BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  home.packages = with pkgs; [
    # command-line color picker
    xcolor
    # note-taking
    obsidian
    # secondary browser, for school and WebGL stuff
    ungoogled-chromium
    # chat
    discord
    # gaming
    steam
    # meetings
    zoom-us
    # screen recording
    obs-studio
    # volume
    pavucontrol
    # compile
    gcc
    # seriously?
    unzip
    # reverse engineering
    ghidra-bin
  ];
}
