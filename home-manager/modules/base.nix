{ lib, pkgs, ... }:

# Shared configuration for all profiles.
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-ms-vscode-cpptools"
      "vscode-extension-ms-toolsai-jupyter"
      "vscode-extension-ms-vsliveshare-vsliveshare"
      "steam"
      "steam-original"
      "steam-runtime"
      "obsidian"
      "discord"
    ];

  programs.home-manager.enable = true;

  # enable non-nixos
  targets.genericLinux.enable = true;
}