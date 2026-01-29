{...}: {
  programs.mise = {
    enable = false;
    enableFishIntegration = true;
    globalConfig = {
      tools = {
        python = "3.12";
        bun = "1.1";
        node = "lts";
        poetry = {
          version = "1.8";
        };
      };
      settings = {
        verbose = false;
        experimental = true;
        # https://github.com/jdx/mise/issues/1501
        trusted_config_paths = [
          "~/.config/mise/config.toml"
        ];
        idiomatic_version_file_enable_tools = [];
      };
    };
  };
}
