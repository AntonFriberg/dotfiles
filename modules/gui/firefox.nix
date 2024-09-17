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
          # General
          "browser.search.defaultengine" = "Google";
          "browser.startup.page" = 3; # Resume previous session on startup
          "browser.aboutConfig.showWarning" = false; # I sometimes know what I'm doing
          "browser.translations.neverTranslateLanguages" = "sv"; # No need to translate swedish
        };
      };
    };
  };
}
