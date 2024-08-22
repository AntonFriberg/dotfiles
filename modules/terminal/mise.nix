{...}: {
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig = {
      tools = {
        python = "3.12";
        bun = "1.1";
        poetry = {
          version = "1.8";
        };
      };
      plugins = {
        poetry = "https://github.com/mise-plugins/mise-poetry";
      };
    };
    settings = {
      verbose = false;
      experimental = true;
      # https://github.com/jdx/mise/issues/1501
      trusted_config_paths = [
        "~/.config/mise/config.toml"
      ];
    };
  };
}
