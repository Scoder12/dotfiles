{ pkgs, ... }:

# Utitilities that are only useful on a GUI system
{
  home.packages = with pkgs; [
    # command-line color picker
    xcolor
    # note-taking
    obsidian
    # secondary browser, for school and WebGL stuff
    ungoogled-chromium
    # chat
    discord
    # for copying from command line. extremely useful
    xclip
  ];

  # enable nix managaing fonts (some GUI modules such as vscode and gnome-terminal need
  #  them)
  fonts.fontconfig.enable = true;

  # TODO: remove, useless
  home.keyboard.options = [ "caps:escape_shifted_capslock" ];
}
