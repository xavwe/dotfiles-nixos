{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use firefox";
    };
    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Make firefox default";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.firefox.enable {
      home-manager.users.nu = {...}: {
        programs.firefox = {
          enable = true;
          profiles.nu = {
            settings = {
              "dom.security.https_only_mode" = true;
              "pdfjs.disabled" = true;
              "browser.aboutConfig.showWarning" = false;
              "devtools.chrome.enabled" = true;
              "devtools.debugger.remote-enabled" = true;
              "browser.download.useDownloadDir" = false;

              "extensions.autoDisableScopes" = 0;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.startup.page" = 0;
              "browser.startup.homepage" = "about:blank";
              "browser.newtabpage.enabled" = false;
              "browser.newtabpage.activity-stream.default.sites" = "";

              "geo.provider.use_geoclue" = false;

              "extensions.getAddons.showPane" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "browser.discovery.enabled" = false;
              "browser.shopping.experience2023.enabled" = false;

              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;

              "app.shield.optoutstudies.enabled" = false;
              "app.normandy.enabled" = false;
              "app.normandy.api_url" = "";

              "breakpad.reportURL" = "";
              "browser.tabs.crashReporting.sendReport" = false;
              "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

              "captivedetect.canonicalURL" = "";
              "network.captive-portal-service.enabled" = false;
              "network.connectivity-service.enabled" = false;

              "browser.safebrowsing.downloads.remote.enabled" = false;

              "network.prefetch-next" = false;
              "network.dns.disablePrefetch" = true;
              "network.dns.disablePrefetchFromHTTPS" = true;
              "network.predictor.enabled" = false;
              "network.predictor.enable-prefetch" = false;
              "network.http.speculative-parallel-limit" = 0;
              "browser.places.speculativeConnect.enabled" = false;
              "browser.send_pings" = false;

              "network.proxy.socks_remote_dns" = true;
              "network.file.disable_unc_paths" = true;
              "network.gio.supported-protocols" = "";

              "browser.urlbar.speculativeConnect.enabled" = false;
              "browser.urlbar.quicksuggest.enabled" = false;
              "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
              "browser.urlbar.suggest.quicksuggest.sponsored" = false;
              "browser.search.suggest.enabled" = false;
              "browser.urlbar.suggest.searches" = false;
              "browser.urlbar.trending.featureGate" = false;
              "browser.urlbar.addons.featureGate" = false;
              "browser.urlbar.fakespot.featureGate" = false;
              "browser.urlbar.mdn.featureGate" = false;
              "browser.urlbar.pocket.featureGate" = false;
              "browser.urlbar.weather.featureGate" = false;
              "browser.urlbar.yelp.featureGate" = false;
              "browser.formfill.enable" = false;
              "browser.search.separatePrivateDefault" = true;
              "browser.search.separatePrivateDefault.ui.enabled" = true;

              "signon.autofillForms" = false;
              "signon.formlessCapture.enabled" = false;
              "network.auth.subresource-http-auth-allow" = 1;
            };
            search.engines = {
              bing.metaData.hidden = true;
              ecosia.metaData.hidden = true;
              google.metaData.hidden = true;
              "Nix Packages" = {
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
                      {
                        name = "channel";
                        value = "unstable";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };
              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@nw"];
              };

              "NixOS Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@no"];
              };
              "Arch Wiki" = {
                urls = [
                  {
                    template = "https://wiki.archlinux.org/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://archlinux.org/static/favicon.png";
                definedAliases = ["@aw"];
              };
              "Gentoo Wiki" = {
                urls = [
                  {
                    template = "https://wiki.gentoo.org/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://www.gentoo.org/favicon.ico";
                definedAliases = ["@gw"];
              };
              "Home Manager Options" = {
                urls = [
                  {
                    template = "https://home-manager-options.extranix.com/";
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

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@ho"];
              };
              "youtube" = {
                name = "YouTube";
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
              "reddit" = {
                name = "Reddit";
                urls = [
                  {
                    template = "https://www.reddit.com/search/";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://www.redditstatic.com/shreddit/assets/favicon/64x64.png";
                definedAliases = ["@rd"];
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
              "GitLab" = {
                icon = "https://gitlab.com/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = ["@gl"];

                urls = [
                  {
                    template = "https://gitlab.com/search";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
              };
            };
            search.force = true;
            userChrome = ''
            '';
            extensions = {
              packages = with inputs.firefox-addons.packages."x86_64-linux"; [
                private-grammar-checker-harper
                vimium
                ublock-origin
                sponsorblock
                youtube-shorts-block
                awesome-rss
                passff
                dearrow
                return-youtube-dislikes
                skip-redirect
                wayback-machine
              ];
            };
          };
          policies = {
            PasswordManagerEnabled = false;
            OfferToSaveLogins = false;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
            DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
            DontCheckDefaultBrowser = true;
            SearchBar = "unified";
            HardwareAcceleration = true;
            TranslateEnabled = false;
            UserMessaging = {
              UrlbarInterventions = false;
              SkipOnboarding = true;
            };
            FirefoxSuggest = {
              WebSuggestions = false;
              SponsoredSuggestions = false;
              ImproveSuggest = false;
            };
          };
        };
      };
    })

    (lib.mkIf config.modules.firefox.default {
      home-manager.users.nu = {...}: {
        xdg.mimeApps = {
          defaultApplications = {
            "text/html" = "firefox.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
            "x-scheme-handler/about" = "firefox.desktop";
            "x-scheme-handler/unknown" = "firefox.desktop";
          };
        };
      };
    })
  ];
}