{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      input = {
        keyboard.xkb.layout = "us";
        touchpad = {
          tap = true;
          natural-scroll = true; # Enable natural scrolling
        };
      };
      environment = {
        # Critical for Electron apps like VSCode
        NIXOS_OZONE_WL = "1";
        # Some apps need this
        MOZ_ENABLE_WAYLAND = "1";
      };
      binds = {
        # Terminals & Apps
        "Mod+Return".action.spawn = "foot";
        "Mod+D".action.spawn = "fuzzel"; # App launcher

        # Window Management
        "Mod+Shift+Q".action.close-window = [];
        "Mod+Left".action.focus-column-left = [];
        "Mod+Right".action.focus-column-right = [];
        "Mod+Down".action.focus-window-down = [];
        "Mod+Up".action.focus-window-up = [];

        # Move windows
        "Mod+Shift+Left".action.move-column-left = [];
        "Mod+Shift+Right".action.move-column-right = [];

        # Workspaces
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 10;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        "Mod+Shift+0".action.move-column-to-workspace = 10;
        # System
        "Ctrl+Alt+Delete".action.quit = [];
      };

      layout = {
        gaps = 8;
        center-focused-column = "never";
        #preset-column-widths = [
        #  { proportion = 0.33333; }
        #  { proportion = 0.5; }
        #  { proportion = 0.66667; }
        #];
      };

      # Optional: Set a wallpaper
      # outputs."eDP-1".background-color = "#1e1e2e";
    };
  };
}
