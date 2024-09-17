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
          "privacy.clearOnShutdown.history" = false; # We want to save history on exit
          # Disable some useless stuff
          "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
          "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
          "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
          "identity.fxaccounts.enabled" = false; # disable firefox login
          "identity.fxaccounts.toolbar.enabled" = false;
          "identity.fxaccounts.pairing.enabled" = false;
          "identity.fxaccounts.commands.enabled" = false;
          "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
          "browser.uitour.enabled" = false; # no tutorial please
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        };
      };
    };
  };
}
