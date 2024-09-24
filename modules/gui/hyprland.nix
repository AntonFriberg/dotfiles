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
        "${modifier}, Shift, Q, killactive,"
        "${modifier}, Shift, Space, togglefloating,"

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

        "${modifier}, Control, left, resizeactive, -10 0"
        "${modifier}, Control, right, resizeactive, 10 0"
        "${modifier}, Control, up, resizeactive, 0 -10"
        "${modifier}, Control, down, resizeactive, 0 10"
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

      decoration = {
        drop_shadow = "yes";
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(00000044)";
        dim_inactive = false;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
    };
  };
}
# };
# wayland.windowManager.hyprland = {
#   enable = true;
#   package = config.lib.nixGL.wrap pkgs.hyprland;
#   systemd.enable = true;
#   xwayland.enable = true;
#   settings = {
#     exec-once = [
#       "${(config.lib.nixGL.wrap pkgs.hyprpanel)}/bin/hyprpanel"
#     ];
#     monitor = [
#       ",preferred,auto,1"
#     ];
#     general = {
#       gaps_in = 5;
#       gaps_out = 5;
#       border_size = 10;
#       layout = "dwindle";
#       resize_on_border = true;
#     };
#     dwindle = {
#       pseudotile = "yes";
#       preserve_split = "yes";
#       # no_gaps_when_only = "yes";
#     };
#     misc = {
#       disable_splash_rendering = true;
#       force_default_wallpaper = 1;
#     };
#     input = {
#       kb_layout = "us,sv";
#       kb_options = "grp:win_space_toggle";
#       follow_mouse = 1;
#       touchpad = {
#         natural_scroll = "yes";
#         disable_while_typing = true;
#         drag_lock = true;
#       };
#       sensitivity = 0;
#       float_switch_override_focus = 2;
#     };
#     binds = {
#       allow_workspace_cycles = true;
#     };
#     gestures = {
#       workspace_swipe = true;
#       workspace_swipe_use_r = true;
#     };
#     bind = let
#       binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
#       mvfocus = binding "SUPER" "movefocus";
#       ws = binding "SUPER" "workspace";
#       resizeactive = binding "SUPER CTRL" "resizeactive";
#       mvactive = binding "SUPER ALT" "moveactive";
#       mvtows = binding "SUPER SHIFT" "movetoworkspace";
#       e = "exec, ags -b hypr";
#       arr = [1 2 3 4 5 6 7];
#     in
#       [
#         "CTRL SHIFT, R,  ${e} quit; ags -b hypr"
#         "SUPER, R,       ${e} -t launcher"
#         "SUPER, Tab,     ${e} -t overview"
#         ",XF86PowerOff,  ${e} -r 'powermenu.shutdown()'"
#         ",XF86Launch4,   ${e} -r 'recorder.start()'"
#         # ",Print,         exec, ${screenshot}"
#         # "SHIFT,Print,    exec, ${screenshot} --full"
#         "SUPER, Return, exec, alacritty" # xterm is a symlink, not actually xterm
#         "SUPER, W, exec, firefox-developer-edition"
#         # youtube
#         # ", XF86Launch1,  exec, ${yt}"
#         "ALT, Tab, focuscurrentorlast"
#         "CTRL ALT, Delete, exit"
#         "ALT, Q, killactive"
#         "SUPER, F, togglefloating"
#         "SUPER, G, fullscreen"
#         "SUPER, O, fakefullscreen"
#         "SUPER, P, togglesplit"
#         (mvfocus "k" "u")
#         (mvfocus "j" "d")
#         (mvfocus "l" "r")
#         (mvfocus "h" "l")
#         (ws "left" "e-1")
#         (ws "right" "e+1")
#         (mvtows "left" "e-1")
#         (mvtows "right" "e+1")
#         (resizeactive "k" "0 -20")
#         (resizeactive "j" "0 20")
#         (resizeactive "l" "20 0")
#         (resizeactive "h" "-20 0")
#         (mvactive "k" "0 -20")
#         (mvactive "j" "0 20")
#         (mvactive "l" "20 0")
#         (mvactive "h" "-20 0")
#       ]
#       ++ (map (i: ws (toString i) (toString i)) arr)
#       ++ (map (i: mvtows (toString i) (toString i)) arr);
#     # bindle = [
#     #   ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
#     #   ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
#     #   ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d asus::kbd_backlight set +1"
#     #   ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set  1-"
#     #   ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
#     #   ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
#     # ];
#     # bindl = [
#     #   ",XF86AudioPlay,    exec, ${playerctl} play-pause"
#     #   ",XF86AudioStop,    exec, ${playerctl} pause"
#     #   ",XF86AudioPause,   exec, ${playerctl} pause"
#     #   ",XF86AudioPrev,    exec, ${playerctl} previous"
#     #   ",XF86AudioNext,    exec, ${playerctl} next"
#     #   ",XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
#     # ];
#     bindm = [
#       "SUPER, mouse:273, resizewindow"
#       "SUPER, mouse:272, movewindow"
#     ];
#     decoration = {
#       drop_shadow = "yes";
#       shadow_range = 8;
#       shadow_render_power = 2;
#       "col.shadow" = "rgba(00000044)";
#       dim_inactive = false;
#       blur = {
#         enabled = true;
#         size = 8;
#         passes = 3;
#         new_optimizations = "on";
#         noise = 0.01;
#         contrast = 0.9;
#         brightness = 0.8;
#         popups = true;
#       };
#     };
#     animations = {
#       enabled = "yes";
#       bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
#       animation = [
#         "windows, 1, 5, myBezier"
#         "windowsOut, 1, 7, default, popin 80%"
#         "border, 1, 10, default"
#         "fade, 1, 7, default"
#         "workspaces, 1, 6, default"
#       ];
#     };
#     plugin = {
#       overview = {
#         centerAligned = true;
#         hideTopLayers = true;
#         hideOverlayLayers = true;
#         showNewWorkspace = true;
#         exitOnClick = true;
#         exitOnSwitch = true;
#         drawActiveWorkspace = true;
#         reverseSwipe = true;
#       };
#       hyprbars = {
#         bar_color = "rgb(2a2a2a)";
#         bar_height = 28;
#         col_text = "rgba(ffffffdd)";
#         bar_text_size = 11;
#         bar_text_font = "Ubuntu Nerd Font";
#         buttons = {
#           button_size = 0;
#           "col.maximize" = "rgba(ffffff11)";
#           "col.close" = "rgba(ff111133)";
#         };
#       };
#       };
#     };
#   };
# }

