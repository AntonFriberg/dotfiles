{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = lib.mkMerge [
    (with pkgs; [
      xwayland-satellite
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
      environment = {
        # Critical for Electron apps like VSCode
        NIXOS_OZONE_WL = "1";
        # Some apps need this
        MOZ_ENABLE_WAYLAND = "1";
        # Disable DMS polkit
        DMS_DISABLE_POLKIT = "1";
        # Disable DMS dynamic theming
        DMS_DISABLE_MATUGEN = "1";
      };
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
        # Set background
        {argv = ["${pkgs.swaybg}/bin/swaybg" "-m" "fill" "--image" "${config.home.homeDirectory}/Pictures/wallpaper.jpg"];}
        # Needs `sudo apt install swaylock swayidle`
        {
          argv = [
            "swayidle" # Handles locking of screen if idle
            "-w"
            "timeout"
            "601" # One second after screen lock power off monitors
            "niri msg action power-off-monitors"
            "timeout"
            "600" # After 10 minutes of inactivity lock screen
            "swaylock -f"
            "before-sleep" # On laptop lid close make sure to lock screen
            "swaylock -f"
          ];
        }
      ];

      layout = {
        gaps = 8; # Space between windows

        preset-column-widths = [
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
          {proportion = 1. / 3.;}
        ];

        # Focus ring colors (Material You style)
        # These can be adjusted to match your DMS color scheme
        focus-ring = {
          enable = true;
          width = 4;
          # Active color: A soft Material Primary (e.g., a muted lavender/blue)
          active.color = "#81a1c1";
          # Inactive color: Darker surface color
          inactive.color = "#5e81ac";
        };
      };
      layer-rules = [
        {
          matches = [{namespace = "^wallpaper$";}];
          place-within-backdrop = true;
        }
      ];
      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 12.;
            bottom-right = 12.;
            top-left = 12.;
            top-right = 12.;
          };
          clip-to-geometry = true;
        }
        {
          matches = [{app-id = "org.kde.polkit-kde-authentication-agent-1";}];
          open-floating = true;
        }
        {
          matches = [{app-id = "org.kde.polkit-kde-authentication-agent-1";}];
          open-floating = true;
        }
        # For screencasting
        {
          matches = [{is-window-cast-target = true;}];
          focus-ring = {
            active.color = "#bf616a";
            inactive.color = "#bb4551";
          };
          tab-indicator = {
            active.color = "#bf616a";
            inactive.color = "#bb4551";
          };
        }
      ];
      hotkey-overlay = {
        skip-at-startup = true;
      };
      binds = {
        # Terminals & Apps
        "Mod+Return".action.spawn = "foot";
        "Mod+D".action.spawn = "fuzzel";

        # Lock screen
        "Mod+L" = {
          allow-when-locked = true;
          action.spawn = "swaylock";
        };

        # Keyboard layout
        "Alt+Space".action.switch-layout = "next";

        # Layout adjustments
        "Mod+R".action.switch-preset-column-width = [];
        "Mod+F".action.maximize-column = [];
        "Mod+Shift+F".action.fullscreen-window = [];

        # Screenshot (requires grim/slurp)
        "Print".action.screenshot = [];
        "Mod+Print".action.screenshot-screen = [];

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
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Settings" = ["gnome" "gtk"];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Swaylock configuration (1.7.2)
  # Note: Lock screens are really tricky to install outside OS native, swaylock usually exists
  xdg.configFile."swaylock/config".text = ''
    ignore-empty-password
    show-failed-attempts
    image=/home/antonfr/Pictures/wallpaper_dark.jpg
    show-keyboard-layout
    indicator-caps-lock
    bs-hl-color=b48eadff
    caps-lock-bs-hl-color=d08770ff
    caps-lock-key-hl-color=ebcb8bff
    font-size=40
    indicator-radius=100
    indicator-thickness=10
    inside-color=2e3440ff
    inside-clear-color=81a1c1ff
    inside-ver-color=5e81acff
    inside-wrong-color=bf616aff
    key-hl-color=a3be8cff
    layout-bg-color=2e3440ff
    line-uses-ring
    ring-color=3b4252ff
    ring-clear-color=88c0d0ff
    ring-ver-color=81a1c1ff
    ring-wrong-color=d08770ff
    separator-color=3b4252ff
    text-color=eceff4ff
    text-clear-color=3b4252ff
    text-ver-color=3b4252ff
    text-wrong-color=3b4252ff
  '';

  # Fix keyring issues on ubuntu by stubbing the service
  systemd.user.services.gnome-keyring = {
    Service.ExecStart = lib.mkForce "${pkgs.coreutils}/bin/true";
    Install.WantedBy = lib.mkForce [];
  };
}
