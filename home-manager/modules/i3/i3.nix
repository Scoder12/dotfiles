{ config
, lib
, pkgs
, ...
}:
let
  mod = "Mod4";

  outPrimary = "HDMI-A-0";
  outSecondary = "DVI-D-0";

  wallpaper =
    pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath;

  inherit (import ./workspaces.nix) ws0 ws1 ws2 ws3 ws4 ws5 ws6 ws7 ws8 ws9 ws-icons;
in
{
  imports = [
    ./startup.nix
  ];

  # Start i3 from home-manager
  # https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8
  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
  };

  programs.i3status-rust = {
    enable = true;
    bars.bottom = {
      theme = "nord-dark";
      settings.icons.icons = "material-nf";
      settings.icons.overrides = {
        # idk why these aren't the default
        music_prev = "玲";
        music_next = "怜";
      };
      blocks = [
        {
          block = "music";
        }
        {
          block = "disk_space";
          path = "/";
          info_type = "available";
          interval = 15;
          warning = 20.0;
          alert = 10.0;
          alert_unit = "GB";
        }
        {
          block = "memory";
          interval = 5;
        }
        {
          block = "cpu";
          interval = 5;
        }
        {
          block = "load";
          interval = 5;
          format = "$icon $1m.eng(w:4)";
        }
        { block = "sound"; }
        {
          block = "time";
          interval = 1;
          format = "$icon $timestamp.datetime(f:'%a %m/%d %r', l:en_US)";
        }
      ];
    };
  };

  services.polybar.enable = true;
  services.polybar.package = pkgs.polybarFull; # enable i3 support
  services.polybar.script = ''
    # Terminate already running bar instances
    polybar-msg cmd quit
    polybar bottom &
  '';
  services.polybar.settings =
    let
      colors = {
        background = "#282A2E";
        background-alt = "#373B41";
        foreground = "#C5C8C6";
        primary = "#F0C674";
        secondary = "#8ABEB7";
        alert = "#A54242";
        disabled = "#707880";
      };
    in
    {
      "bar/bottom" = {
        monitor = outPrimary;
        background = colors.background;
        foreground = colors.foreground;
        line-size = "3pt";
        border-size = "4pt";
        border-color = "#00000000";
        padding-left = 0;
        padding-right = 1;
        module-margin = 1;
        separator = "|";
        separator-foreground = colors.disabled;
        font = [ "monospace;2" "Symbols Nerd Font Mono:size=12;2" ];
        bottom = true;
        modules-left = "i3";
        modules-right = "filesystem pulseaudio xkeyboard memory cpu wlan eth date";
      };

      "module/i3" = {
        type = "internal/i3";
        ws-icon = lib.lists.imap0
          (i: v: if (builtins.stringLength v) > 0 then "${builtins.toString i};${v}" else "${builtins.toString i};${builtins.toString i}")
          ws-icons;
        label.mode = {
          text = "%icon%";
          padding = 0.5;
        };
        label.focused = {
          text = "%icon% ";
          background = colors.background-alt;
          underline = colors.primary;
          padding = 0.5;
        };
        label.unfocused = {
          text = "%icon%";
          padding = 0.5;
        };
        label.visible = {
          text = "%icon%";
          padding = 0.5;
        };
        label.urgent = {
          text = "%icon%";
          background = colors.alert;
          padding = 0.5;
        };
      };

      "module/filesystem" = {
        type = "internal/fs";
        mount = [ "/" ];
        interval = 30;
        label-mounted = "󰋊 %free%";
        label-unmounted = "";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        interval = 5;
        click-right = "${pkgs.pavucontrol}/bin/pavucontrol &";
        format-volume = "<ramp-volume> <label-volume>";
        label.muted.text = "󰝟";
        label.muted.foreground = "#666";
        ramp.volume = [ "󰕿" "󰖀" "󰕾" ];
      };
    };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod; # super

      keybindings = lib.mkOptionDefault {
        "${mod}+n" = "move workspace to output left";
        "${mod}+m" = "move workspace to output right";

        "${mod}+0" = "workspace number ${ws0}";
        "${mod}+1" = "workspace number ${ws1}";
        "${mod}+2" = "workspace number ${ws2}";
        "${mod}+3" = "workspace number ${ws3}";
        "${mod}+4" = "workspace number ${ws4}";
        "${mod}+5" = "workspace number ${ws5}";
        "${mod}+6" = "workspace number ${ws6}";
        "${mod}+7" = "workspace number ${ws7}";
        "${mod}+8" = "workspace number ${ws8}";
        "${mod}+9" = "workspace number ${ws9}";

        "${mod}+Shift+1" = "move container to workspace number ${ws1}";
        "${mod}+Shift+2" = "move container to workspace number ${ws2}";
        "${mod}+Shift+3" = "move container to workspace number ${ws3}";
        "${mod}+Shift+4" = "move container to workspace number ${ws4}";
        "${mod}+Shift+5" = "move container to workspace number ${ws5}";
        "${mod}+Shift+6" = "move container to workspace number ${ws6}";
        "${mod}+Shift+7" = "move container to workspace number ${ws7}";
        "${mod}+Shift+8" = "move container to workspace number ${ws8}";
        "${mod}+Shift+9" = "move container to workspace number ${ws9}";
        "${mod}+Shift+0" = "move container to workspace number ${ws0}";

        # vim keybindings
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+a" = "focus parent";
        "${mod}+b" = "focus child";

        "${mod}+Shift+p" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock";

        "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";

        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
        "XF86MonBrightnessUp" = "exec --no-startup-id light -A 30";
        "XF86MonBrightnessDown" = "exec --no-startup-id light -U 30";
      };

      assigns.${ws0} = [{ class = "^discord$"; } { class = "^signal$"; }];
      assigns.${ws2} = [{ class = "^Alacritty$"; }];
      assigns.${ws3} = [{ class = "^VSCodium$"; }];
      assigns.${ws4} = [{ class = "^zoom$"; } { class = "^[cC]hromium-browser$"; }];
      assigns.${ws9} = [
        { class = "^csgo_linux64$"; }
        { class = "^factorio$"; }
        { class = "^portal2_linux$"; }
        { class = "^Celeste"; }
        { class = "^GettingOverIt.x86_64$"; }
        { class = "^hollow_knight.x86_64$"; }
      ];

      startup = [
        # Setup monitors (generated by arandr)
        {
          command = "xrandr --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output HDMI-A-0 --primary --mode 1920x1080 --pos 1440x0 --rotate normal --output DVI-D-0 --mode 1440x900 --pos 0x180 --rotate normal";
        }
        # Set background properly
        # its set by lightdm but glitches when i3 starts
        {
          always = true;
          command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}";
        }
      ];

      window.hideEdgeBorders = "both";

      workspaceAutoBackAndForth = true;

      terminal =
        if config.programs.alacritty.enable
        then "${config.programs.alacritty.package}/bin/alacritty"
        else "i3-sensible-terminal";

      bars = [
        {
          position = "bottom";
          mode = "dock";
          hiddenState = "hide";
          workspaceButtons = true;
          workspaceNumbers = false;
          statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-bottom.toml";
          fonts = {
            # Monospace still makes fontwawesome fonts work
            # putting fontawesome as the font face makes colons off-center
            names = [ "DejaVu Sans Mono" ];
            size = 10.0;
          };
          trayOutput = "primary";
          colors = {
            background = "#2e3440";
            statusline = "#ffffff";
            separator = "#666666";
            focusedWorkspace = {
              border = "#4c7899";
              background = "#285577";
              text = "#ffffff";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#5f676a";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#333333";
              background = "#222222";
              text = "#888888";
            };
            urgentWorkspace = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
            bindingMode = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
          };
        }
      ];

      colors = {
        focused = {
          background = "#ee303a";
          border = "#ff4f59";
          childBorder = "#ff4f59";
          indicator = "#b34a46";
          text = "#262626";
        };
      };
    };

    extraConfig = ''
      workspace ${ws0} output ${outSecondary}
      workspace ${ws1} output ${outPrimary}

      for_window [class="^Spotify$"] move --no-auto-back-and-forth to workspace ${ws7}
      for_window [class="^steam$"] move --no-auto-back-and-forth to workspace ${ws8}
    '';
  };
}
