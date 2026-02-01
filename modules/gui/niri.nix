{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.mkMerge [
    (with pkgs; [
      ])
  ];

  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableKeybinds = true; # Sets static preset keybinds
      enableSpawn = true; # Auto-start DMS with niri, if enabled
      includes.enable = false;
    };
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      input = {
        keyboard.xkb.layout = "us,se";
        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
        };
      };
      outputs = {
        "eDP-1".scale = 1.5;
      };
      spawn-at-startup = [
        {argv = ["dbus-update-activation-environment --systemd --all"];}
        # Needs `sudo apt install --no-install-recommends polkit-kde-agent-1`
        {argv = ["/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1"];}
      ];
      environment = {
        # Critical for Electron apps like VSCode
        NIXOS_OZONE_WL = "1";
        # Some apps need this
        MOZ_ENABLE_WAYLAND = "1";
        # Disable DMS polkit
        DMS_DISABLE_POLKIT = "1";
      };
      window-rules = [
        {
          matches = [{app-id = "org.kde.polkit-kde-authentication-agent-1";}];
          open-floating = true;
        }
      ];
      binds = {
        # Terminals & Apps
        "Mod+Return".action.spawn = "foot";
        "Mod+D".action.spawn = "fuzzel";

        # Keyboard layout
        "Alt+Space".action.switch-layout = "next";

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
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
        width = 30;
        font = "Hack Nerd Font:weight=bold:size=10";
        inner-pad = 10;
        lines = 15;
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

  # Fix file picker and similar issues
  xdg.portal = {
    enable = true;
    config = {
      niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Fix keyring issues on ubuntu by stubbing the service
  systemd.user.services.gnome-keyring = {
    Service.ExecStart = lib.mkForce "${pkgs.coreutils}/bin/true";
    Install.WantedBy = lib.mkForce [];
  };
}
