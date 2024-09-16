{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.hyprland;
    settings = {
      exec-once = [
        "${(config.lib.nixGL.wrap pkgs.hyprpanel)}/bin/hyprpanel"
      ];
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 20;
      };
    };
  };
}
