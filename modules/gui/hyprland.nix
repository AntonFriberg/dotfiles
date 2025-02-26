{
  pkgs,
  pkgs-stable,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs-stable.hyprland;

    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "waybar" # Start waybar when Hyprland starts
      ];

      monitor = [
        ",preferred,auto,1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 3;
        layout = "master";
        "col.active_border" = "rgb(5e81ac)";
        "col.inactive_border" = "rgb(2e3440)";
        resize_on_border = true;
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
      };

      decoration = {
        rounding = 1;
        blur = {
          enabled = false;
          size = 0;
          passes = 0;
        };
        shadow = {
          range = 12;
          render_power = 2;
          color = "rgb(101010)";
        };
      };

      input = {
        kb_layout = "us,se";
        kb_variant = ",";
        kb_model = "";
        kb_options = "grp:win_space_toggle";
        kb_rules = "";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          drag_lock = true;
        };
        sensitivity = 0;
        float_switch_override_focus = 2;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_use_r = true;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      # Tip: You can install wev to tell you name of key being pressed
      bind = let
        modifier = "Super";
        terminal = "alacritty";
        menu = "fuzzel";
        file_explorer = "nautilus";
        lock_screen = "hyprlock";
        screenshot_dir = "$HOME/Pictures/Screenshots";
      in [
        # Exit
        "CTRL ALT, Delete, exit"

        # Top level bindings
        "${modifier}, Tab, cyclenext"
        "${modifier}, Return, exec, ${terminal}"
        "${modifier}, D, exec, ${menu}"
        "${modifier}, E, exec, ${file_explorer}"
        "${modifier}, L, exec, ${lock_screen}"
        "${modifier}, F, fullscreen"
        "${modifier}, W, togglegroup,"
        "${modifier}, P, pseudo,"
        "${modifier}, T, togglesplit,"
        "${modifier}, S, swapsplit,"

        # Second level bindings
        "${modifier} Shift, Q, killactive,"
        "${modifier} Shift, Space, togglefloating,"

        # Move focus with modifier + arrow keys
        "${modifier}, left, movefocus, l"
        "${modifier}, right, movefocus, r"
        "${modifier}, up, movefocus, u"
        "${modifier}, down, movefocus, d"

        # Switch workspaces with modifier + [0-9]
        "${modifier}, 1, workspace, 1"
        "${modifier}, 2, workspace, 2"
        "${modifier}, 3, workspace, 3"
        "${modifier}, 4, workspace, 4"
        "${modifier}, 5, workspace, 5"
        "${modifier}, 6, workspace, 6"
        "${modifier}, 7, workspace, 7"
        "${modifier}, 8, workspace, 8"
        "${modifier}, 9, workspace, 9"
        "${modifier}, 0, workspace, 10"

        # Move active window to a workspace with modifier + Shift + [0-9]
        "${modifier} Shift, 1, movetoworkspace, 1"
        "${modifier} Shift, 2, movetoworkspace, 2"
        "${modifier} Shift, 3, movetoworkspace, 3"
        "${modifier} Shift, 4, movetoworkspace, 4"
        "${modifier} Shift, 5, movetoworkspace, 5"
        "${modifier} Shift, 6, movetoworkspace, 6"
        "${modifier} Shift, 7, movetoworkspace, 7"
        "${modifier} Shift, 8, movetoworkspace, 8"
        "${modifier} Shift, 9, movetoworkspace, 9"
        "${modifier} Shift, 0, movetoworkspace, 10"

        # Navigate between workspaces with modifier + Alt + arrow keys
        "${modifier} Alt, left, workspace, e-1" # Go to workspace on the left
        "${modifier} Alt, right, workspace, e+1" # Go to workspace on the right

        # Rezie active window
        "${modifier}+Ctrl, left, resizeactive, -10 0"
        "${modifier}+Ctrl, right, resizeactive, 10 0"
        "${modifier}+Ctrl, up, resizeactive, 0 -10"
        "${modifier}+Ctrl, down, resizeactive, 0 10"
        # Screenshot bindings
        ", Print, exec, grim ${screenshot_dir}/$(date +'%Y-%m-%d_%H-%M-%S').png"
        "Shift, Print, exec, grim -g \"$(slurp)\" ${screenshot_dir}/$(date +'%Y-%m-%d_%H-%M-%S').png"
      ];

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
    };
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: JetBrainsMono NerdFont, SourceHanSansJP;
        font-weight: bold;
        font-size: 13px;
      }

      window#waybar {
        background-color: transparent;
        color: #d8dee9;
      }

      window#waybar > box {
          margin: 0px 0px 5px 0px;
          background-color: #2e3440;
          box-shadow: 1 1 3 1px #151515;
      }

      #workspaces button {
        padding: 0 0.6em;
        color: #d8dee9;
        border-radius: 6px;
        margin-right: 4px;
        margin-left: 4px;
        margin-top: 2px;
        margin-bottom: 2px;
      }

      #workspaces button.active {
        color: #d8dee9;
        background: #434c5e;
      }

      #workspaces button.focused {
        color: #d8dee9;
        background: #434c5e;
      }

      #workspaces button.urgent {
        color: #bf616a;
        background: #d8dee9;
      }

      #workspaces button:hover {
        background: #2e3440;
        color: #d8dee9;
      }

      #date,
      #battery,
      #clock,
      #pulseaudio,
      #workspaces,
      #window,
      #language,
      #temperature,
      #text,

      #tray {
        background: #3b4252;
        padding: 0 0.6em;
        margin-right: 4px;
        margin-left: 4px;
        margin-top: 4px;
        margin-bottom: 4px;
        border-radius: 6px;
      }

      #tray {
        margin-right: 6px;
      }

      #pulseaudio {
        margin-right: 6px;
        color: #d8dee9;
      }

      #clock {
        color: #d8dee9;
        margin-right: 6px;
      }

      #battery {
        color: #d8dee9;
        margin-right: 6px;
      }

      #window {
        color: #d8dee9;
        background: #3b4252;
        padding: 0 0.6em;
        margin-right: 4px;
        margin-left: 4px;
        margin-top: 4px;
        margin-bottom: 4px;
        border-radius: 6px;
        background: radial-gradient(circle, #5e81ac, #3b4252)
      }

      #language {
        color: #d8dee9;
        background: #3b4252;
        padding: 0 0.6em;
        margin-right: 4px;
        margin-left: 4px;
        margin-top: 4px;
        margin-bottom: 4px;
        border-radius: 6px;
      }

      #temperature {
        color: #d8dee9;
        background: #3b4252;
        padding: 0 0.6em;
        margin-right: 4px;
        margin-left: 4px;
        margin-top: 4px;
        margin-bottom: 4px;
        border-radius: 6px;
      }

      #custom-launcher {
        color: #d8dee9;
        background: #3b4252;
        padding: 0 0.6em;
        margin-right: 4px;
        margin-left: 4px;
        margin-top: 4px;
        margin-bottom: 4px;
        border-radius: 6px;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = ["custom/launcher" "pulseaudio" "hyprland/language" "hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["clock#date" "clock#time" "temperature" "battery"];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "<span color=\"#d8dee9\">一</span>";
            "2" = "<span color=\"#d8dee9\">二</span>";
            "3" = "<span color=\"#d8dee9\">三</span>";
            "4" = "<span color=\"#d8dee9\">四</span>";
            "5" = "<span color=\"#d8dee9\">五</span>";
            "6" = "<span color=\"#d8dee9\">六</span>";
            "7" = "<span color=\"#d8dee9\">七</span>";
            "8" = "<span color=\"#d8dee9\">八</span>";
            "9" = "<span color=\"#d8dee9\">九</span>";
          };
        };

        "clock#time" = {
          interval = 1;
          format = " {:%H:%M:%S}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 10;
          format = " {:%e %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          scroll-step = 5;
          on-click = "pactl set-sink-mute 0 toggle";
          format-icons = {
            "headphone" = " ";
            "hands-free" = " ";
            "headset" = " ";
            "default" = ["" "" "墳" " "];
          };
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "{capacity}%  ";
          format-plugged = "{capacity}%  ";
          format-alt = "{time} {icon}";
          format-icons = [" " " " " " " " " "];
        };

        "battery#bat2" = {
          bat = "bat2";
        };

        "hyprland/window" = {
          format = " {} ";
          max-length = 50;
        };

        "hyprland/language" = {
          format = " {}";
          interval = 1;
          format-en = "US";
          format-sv = "SE";
        };

        "temperature" = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [""];
        };

        "custom/launcher" = {
          format = "<span color='#d8dee9'> 本 </span>";
          on-click = "fuzzel";
        };
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        layer = "overlay";
        width = 30;
        font = "JetBrainsMono NerdFont:weight=bold:size=10";
        inner-pad = 10;
        lines = 15;
        border-width = 2;
        border-radius = 6;
        horizontal-pad = 20;
        vertical-pad = 20;
      };
      colors = {
        # Nord color palette
        background = "2e3440ff"; # Dark blue-grey background
        text = "d8dee9ff"; # Light blue-grey text
        match = "88c0d0ff"; # Light blue for matched text
        selection = "4c566aff"; # Lighter blue-grey for selected item
        selection-text = "eceff4ff"; # Almost white for text in selected item
        border = "5e81acff"; # Medium blue for border
      };
      border = {
        width = 2;
        radius = 6;
      };
    };
  };
}
