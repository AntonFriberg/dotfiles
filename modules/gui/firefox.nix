{
  config,
  pkgs,
  firefox-addons,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.firefox-devedition;
    profiles = {
      dev-edition-default = {
        id = 0;
        name = "dev-edition-default";
        isDefault = true;
        extensions.packages = with firefox-addons.packages."${pkgs.system}"; [
          ublock-origin
          bitwarden
          istilldontcareaboutcookies
        ];
        settings = {
          # General
          "browser.search.defaultengine" = "google";
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
          # disable annoying web features
          "dom.push.enabled" = false; # no notifications, really...
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false; # you don't need to see my battery...
          "dom.private-attribution.submission.enabled" = false; # https://news.ycombinator.com/item?id=40974112
        };
        search = {
          force = true;
          default = "google";
          order = ["google" "youtube" "GitHub" "HackerNews" "Kagi" "Nix Packages" "Home Manager" "NixOS Options"];
          engines = {
            "bing".metaData.hidden = true;
            "amazondotcom-us".metaData.hidden = true;
            "wikipedia".metaData.hidden = true;
            "ddg".metaData.hidden = true;

            "Goalie" = {
              icon = "https://go.se.axis.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              urls = [{template = "https://go.se.axis.com/{searchTerms}";}];
              definedAliases = ["@go"];
            };
            "youtube" = {
              icon = "https://youtube.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@yt"];
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Nix Packages" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "NixOS Options" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "GitHub" = {
              icon = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@gh"];
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Home Manager" = {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@hm"];
              urls = [
                {
                  template = "https://mipmip.github.io/home-manager-option-search/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "HackerNews" = {
              icon = "https://hn.algolia.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@hn"];
              urls = [
                {
                  template = "https://hn.algolia.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };
}
