{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.hyprland;

    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "${(config.lib.nixGL.wrap pkgs.hyprpanel)}/bin/hyprpanel"
      ];

      monitor = [
        ",preferred,auto,1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 10;
        layout = "dwindle";
        resize_on_border = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
        # no_gaps_when_only = "yes";
      };

      input = {
        kb_layout = "us,se";
        kb_variant = ",swerty";
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

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
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
        "${modifier}, F, exec, fullscreen"
        "${modifier}, W, togglegroup,"
        "${modifier}, P, pseudo,"
        "${modifier}, T, togglesplit,"
        "${modifier}, S, swapsplit,"

        # Second level bindings
        "${modifier}, Shift Q, killactive,"
        "${modifier}, Shift Space, togglefloating,"

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
}
