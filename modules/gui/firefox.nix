{
  config,
  pkgs,
  firefox-addons,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.firefox-devedition-bin;
    profiles = {
      dev-edition-default = {
        id = 0;
        name = "dev-edition-default";
        isDefault = true;
        extensions = with firefox-addons.packages."${pkgs.system}"; [
          ublock-origin
          bitwarden
          istilldontcareaboutcookies
        ];
        settings = {
          "browser.startup.homepage" = "https://google.com";
          "browser.search.defaultengine" = "Google";
        };
      };
    };
  };
}
