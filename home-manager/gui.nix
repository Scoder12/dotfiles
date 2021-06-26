{ ... }:

{
  imports = [
    ./modules/vscode.nix
    ./modules/firefox.nix
    ./modules/ungoogled-chromium.nix
    ./modules/xcolor.nix
  ];

  dconf.enable = true;

  fonts.fontconfig.enable = true;

  home.keyboard.options = [ "caps:escape_shifted_capslock" ];
}
