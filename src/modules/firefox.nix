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

              "browser.cache.disk.enable" = false;
              "browser.privatebrowsing.forceMediaMemoryCache" = true;
              "media.memory_cache_max_size" = 65536;
              "browser.sessionstore.privacy_level" = 2;
              "toolkit.winRegisterApplicationRestart" = false;
              "browser.shell.shortcutFavicons" = false;
              "security.ssl.require_safe_negotiation" = true;
              "security.tls.enable_0rtt_data" = false;
              "security.OCSP.enabled" = 1;
              "security.OCSP.require" = true;
              "security.cert_pinning.enforcement_level" = 2;
              "security.remote_settings.crlite_filters.enabled" = true;
              "security.pki.crlite_mode" = 2;
              "signon.rememberSignons" = false;
              "browser.bookmarks.showMobileBookmarks" = false;
              "dom.security.https_only_mode_send_http_background_request" = false;
              "identity.fxaccounts.enabled" = false;
              "security.ssl.treat_unsafe_negotiation_as_broken" = true;
              "browser.xul.error_pages.expert_bad_cert" = true;
              "network.http.referer.XOriginTrimmingPolicy" = 2;
              "privacy.userContext.enabled" = true;
              "privacy.userContext.ui.enabled" = true;
              "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
              "media.peerconnection.ice.default_address_only" = true;
              "dom.disable_window_move_resize" = true;
              "browser.download.start_downloads_in_tmp_dir" = true;
              "browser.helperApps.deleteTempFileOnExit" = true;
              "browser.uitour.enabled" = false;
              "permissions.manager.defaultsUrl" = "";
              "network.IDN_show_punycode" = true;
              "pdfjs.enableScripting" = false;
              "browser.tabs.searchclipboardfor.middleclick" = false;
              "browser.contentanalysis.enabled" = false;
              "browser.contentanalysis.default_result" = 0;
              "browser.download.alwaysOpenPanel" = false;
              "browser.download.manager.addToRecentDocs" = false;
              "browser.download.always_ask_before_handling_new_types" = true;
              "extensions.enabledScopes" = 5;
              "extensions.postDownloadThirdPartyPrompt" = false;
              "browser.contentblocking.category" = "strict";
              # "privacy.sanitize.sanitizeOnShutdown" = true;
              "privacy.clearOnShutdown_v2.cache" = true;
              "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
              "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
              "privacy.clearOnShutdown_v2.downloads" = true;
              "privacy.clearOnShutdown_v2.formdata" = true;
              # "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
              "privacy.clearSiteData.cache" = true;
              "privacy.clearSiteData.cookiesAndStorage" = false;
              "privacy.clearSiteData.historyFormDataAndDownloads" = true;
              "privacy.clearSiteData.browsingHistoryAndDownloads" = true;
              "privacy.clearSiteData.formdata" = true;
              "privacy.clearHistory.cache" = true;
              "privacy.clearHistory.cookiesAndStorage" = false;
              "privacy.clearHistory.historyFormDataAndDownloads" = true;
              "privacy.clearHistory.browsingHistoryAndDownloads" = true;
              "privacy.clearHistory.formdata" = true;
              "privacy.sanitize.timeSpan" = 0;
              "privacy.window.maxInnerWidth" = 1600;
              "privacy.window.maxInnerHeight" = 900;
              "privacy.resistFingerprinting.block_mozAddonManager" = true;
              "privacy.spoof_english" = 1;
              "browser.display.use_system_colors" = false;
              "widget.non-native-theme.use-theme-accent" = false;
              "browser.link.open_newwindow" = 3;
              "browser.link.open_newwindow.restriction" = 0;
              "extensions.blocklist.enabled" = true;
              "network.http.referer.spoofSource" = false;
              "security.dialog_enable_delay" = 1000;
              "privacy.firstparty.isolate" = false;
              "extensions.webcompat.enable_shims" = true;
              "security.tls.version.enable-deprecated" = false;
              "extensions.webcompat-reporter.enabled" = false;
              "extensions.quarantinedDomains.enabled" = true;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.server" = "data:,";
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.coverage.opt-out" = true;
              "toolkit.coverage.opt-out" = true;
              "toolkit.coverage.endpoint.base" = "";
              "browser.startup.homepage_override.mstone" = "ignore";
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
              "browser.urlbar.showSearchTerms.enabled" = false;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.search.widget.inNavBar" = false;
              "layers.acceleration.force-enabled" = true;
              "browser.translate.enable" = false;
              "browser.urlbar.interventions" = false;
              "browser.urlbar.suggest.topsites" = false;
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

              "ChatGPT" = {
                urls = [
                  {
                    template = "https://chatgpt.com/";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "https://chatgpt.com/favicon.ico";
                definedAliases = ["@gpt"];
              };

              "DeepL de-en" = {
                urls = [
                  {
                    template = "https://www.deepl.com/translator#de/en-gb/{searchTerms}";
                  }
                ];
                icon = "https://www.deepl.com/favicon.ico";
                definedAliases = ["@de-en"];
              };

              "DeepL en-de" = {
                urls = [
                  {
                    template = "https://www.deepl.com/translator#en/de/{searchTerms}";
                  }
                ];
                icon = "https://www.deepl.com/favicon.ico";
                definedAliases = ["@en-de"];
              };

              "Claude" = {
                urls = [
                  {
                    template = "https://claude.ai/new?";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "https://claude.ai/favicon.ico";
                definedAliases = ["@c"];
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
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            DisableAccounts = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
            UserMessaging = {
              SkipOnboarding = true;
            };
            FirefoxSuggest = {
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
