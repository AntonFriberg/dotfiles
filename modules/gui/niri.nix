{pkgs, ...}: {
  programs.niri = {
    enable = true;
    # This uses the package provided by the flake (rolling release)
    package = pkgs.niri;

    # Optional: Basic configuration
    settings = {
      input = {
        keyboard.xkb.layout = "us"; # Change to your layout
        touchpad.tap = true;
      };
      # Define your layout and keybindings here
      binds = {
        "Mod+Return".action.spawn = "foot";
        "Mod+Shift+Q".action.close-window = [];
        "Ctrl+Alt+Delete".action.quit = [];

        # # Examples of actions with arguments
        # "Mod+1".action.focus-column-or-monitor = 1;
        # "Mod+Shift+1".action.move-column-to-monitor = 1;

        # # Scrolling/Layout
        # "Mod+WheelScrollDown".action.focus-workspace-down = [];
        # "Mod+WheelScrollUp".action.focus-workspace-up = [];
      };

      #   layout = {
      #     gaps = 10;
      #     center-focused-column = "never";
      #   };
    };
  };
}
