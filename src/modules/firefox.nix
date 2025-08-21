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
        home = {
          file."firefox-gnome-theme" = {
            target = ".mozilla/firefox/nu/chrome/firefox-gnome-theme";
            source = inputs.firefox-gnome-theme;
          };
        };

        programs.firefox = {
          enable = true;
          profiles.nu = {
            name = "nu";
            settings = {
              "toolkit.zoomManager.zoomValues" = ".05,.1,.2,.3,.5,.67,.75,.8,.85,.9,.95,1,1.1,1.2,1.33,1.5,1.7,2,2.4,3,4,5";
              "zoom.minPercent" = 5;
              "zoom.maxPercent" = 500;

              # =========================
              # SECURITY & PRIVACY CORE
              # =========================

              # Force HTTPS-only mode
              "dom.security.https_only_mode" = true;
              "dom.security.https_only_mode_send_http_background_request" = false;

              # Disable PDF.js scripting
              "pdfjs.disabled" = true;
              "pdfjs.enableScripting" = false;

              # Development settings
              "browser.aboutConfig.showWarning" = false;
              "devtools.chrome.enabled" = true;
              "devtools.debugger.remote-enabled" = true;

              # =========================
              # STARTUP & NEW TAB PAGE
              # =========================

              # Disable sponsored content and homepage
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.startup.page" = 3; # Resume previous session for persistent logins
              "browser.startup.homepage" = "about:blank";
              "browser.newtabpage.enabled" = false;
              "browser.newtabpage.activity-stream.default.sites" = "";

              # Override first run and update pages (replaces OverrideFirstRunPage/OverridePostUpdatePage policies)
              "startup.homepage_override_url" = "";
              "startup.homepage_welcome_url" = "";
              "startup.homepage_welcome_url.additional" = "";
              "browser.startup.homepage_override.mstone" = "ignore";

              # =========================
              # GEOLOCATION & LANGUAGE
              # =========================

              # Disable geolocation services (arkenfox 0200)
              "geo.provider.use_geoclue" = false;
              "geo.provider.ms-windows-location" = false;
              "geo.provider.use_corelocation" = false;

              # Language/locale privacy (arkenfox 0200)
              "intl.accept_languages" = "en-US, en";
              "javascript.use_us_english_locale" = true;

              # =========================
              # EXTENSIONS & RECOMMENDATIONS
              # =========================

              # Disable extension recommendations
              "extensions.autoDisableScopes" = 0;
              "extensions.getAddons.showPane" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "browser.discovery.enabled" = false;
              "browser.shopping.experience2023.enabled" = false;
              "extensions.enabledScopes" = 15; # Allow all extension install locations (1+2+4+8)
              "extensions.postDownloadThirdPartyPrompt" = false;
              "extensions.blocklist.enabled" = true;
              "extensions.webcompat.enable_shims" = true;
              "extensions.webcompat-reporter.enabled" = false;
              "extensions.quarantinedDomains.enabled" = true;
              # Allow unsigned extensions (needed for custom addons)
              "xpinstall.signatures.required" = false;

              # =========================
              # TELEMETRY & DATA COLLECTION
              # =========================

              # Disable telemetry
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
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
              "browser.ping-centre.telemetry" = false;

              # =========================
              # STUDIES & EXPERIMENTS
              # =========================

              # Disable studies and experiments (replaces DisableFirefoxStudies policy)
              "app.shield.optoutstudies.enabled" = false;
              "app.normandy.enabled" = false;
              "app.normandy.api_url" = "";
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

              # =========================
              # CRASH REPORTING
              # =========================

              # Disable crash reports
              "breakpad.reportURL" = "";
              "browser.tabs.crashReporting.sendReport" = false;
              "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

              # =========================
              # CAPTIVE PORTAL & CONNECTIVITY
              # =========================

              # Disable captive portal detection
              "captivedetect.canonicalURL" = "";
              "network.captive-portal-service.enabled" = false;
              "network.connectivity-service.enabled" = false;

              # =========================
              # SAFE BROWSING
              # =========================

              # Disable safe browsing (arkenfox 0400)
              "browser.safebrowsing.malware.enabled" = false;
              "browser.safebrowsing.phishing.enabled" = false;
              "browser.safebrowsing.downloads.enabled" = false;
              "browser.safebrowsing.downloads.remote.enabled" = false;

              # =========================
              # NETWORK PREFETCHING
              # =========================

              # Disable network prefetching
              "network.prefetch-next" = false;
              "network.dns.disablePrefetch" = true;
              "network.dns.disablePrefetchFromHTTPS" = true;
              "network.predictor.enabled" = false;
              "network.predictor.enable-prefetch" = false;
              "network.http.speculative-parallel-limit" = 0;
              "browser.places.speculativeConnect.enabled" = false;
              "browser.send_pings" = false;

              # =========================
              # PROXY & DNS
              # =========================

              # Force DNS over SOCKS proxy
              "network.proxy.socks_remote_dns" = true;
              "network.file.disable_unc_paths" = true;
              "network.gio.supported-protocols" = "";

              # =========================
              # LOCATION BAR & SEARCH
              # =========================

              # Disable location bar suggestions and quick suggest
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
              "browser.urlbar.showSearchTerms.enabled" = false;
              "browser.urlbar.interventions" = false;
              "browser.urlbar.suggest.topsites" = false;

              # =========================
              # PASSWORDS & FORMS
              # =========================

              # Disable password autofill but allow cookie-based login persistence
              "signon.autofillForms" = false;
              "signon.formlessCapture.enabled" = false;
              "signon.rememberSignons" = false;
              "network.auth.subresource-http-auth-allow" = 1;

              # =========================
              # DISK CACHE & STORAGE
              # =========================

              # Disable disk cache but preserve login sessions
              "browser.cache.disk.enable" = false;
              "browser.privatebrowsing.forceMediaMemoryCache" = true;
              "media.memory_cache_max_size" = 65536;
              "browser.sessionstore.privacy_level" = 0; # Save cookies and storage for persistent logins
              "toolkit.winRegisterApplicationRestart" = false;
              "browser.shell.shortcutFavicons" = false;

              # =========================
              # SSL/TLS SECURITY
              # =========================

              # Enforce secure SSL/TLS
              "security.ssl.require_safe_negotiation" = true;
              "security.tls.enable_0rtt_data" = false;
              "security.OCSP.enabled" = 1;
              "security.OCSP.require" = true;
              "security.cert_pinning.enforcement_level" = 2;
              "security.remote_settings.crlite_filters.enabled" = true;
              "security.pki.crlite_mode" = 2;
              "security.ssl.treat_unsafe_negotiation_as_broken" = true;
              "browser.xul.error_pages.expert_bad_cert" = true;
              "security.dialog_enable_delay" = 1000;
              "security.tls.version.enable-deprecated" = false;

              # =========================
              # ACCOUNTS & SYNC
              # =========================

              # Disable Firefox accounts
              "identity.fxaccounts.enabled" = false;

              # =========================
              # REFERRER POLICY
              # =========================

              # Configure referrer policy
              "network.http.referer.XOriginTrimmingPolicy" = 2;
              "network.http.referer.spoofSource" = false;

              # =========================
              # CONTAINERS
              # =========================

              # Enable container tabs
              "privacy.userContext.enabled" = true;
              "privacy.userContext.ui.enabled" = true;

              # =========================
              # WEBRTC
              # =========================

              # Restrict WebRTC (arkenfox 2000)
              "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
              "media.peerconnection.ice.default_address_only" = true;

              # =========================
              # SERVICE WORKERS & WEB APIS
              # =========================

              # Disable service workers and web notifications (arkenfox 2300)
              "dom.serviceWorkers.enabled" = false;
              "dom.webnotifications.enabled" = false;

              # Disable beacon API (arkenfox 2600)
              "beacon.enabled" = false;

              # =========================
              # DOM & WINDOW BEHAVIOR
              # =========================

              # Prevent window manipulation (arkenfox 2400)
              "dom.disable_window_move_resize" = true;
              "browser.link.open_newwindow" = 3;
              "browser.link.open_newwindow.restriction" = 0;

              # Additional DOM hardening
              "dom.disable_window_open_feature.close" = true;
              "dom.disable_window_open_feature.location" = true;
              "dom.disable_window_open_feature.menubar" = true;
              "dom.disable_window_open_feature.minimizable" = true;
              "dom.disable_window_open_feature.personalbar" = true;
              "dom.disable_window_open_feature.resizable" = true;
              "dom.disable_window_open_feature.status" = true;
              "dom.disable_window_open_feature.titlebar" = true;
              "dom.disable_window_open_feature.toolbar" = true;
              "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";

              # =========================
              # DOWNLOADS & FILES
              # =========================

              # Download settings
              "browser.download.useDownloadDir" = false;
              "browser.download.start_downloads_in_tmp_dir" = true;
              "browser.helperApps.deleteTempFileOnExit" = true;
              "browser.download.alwaysOpenPanel" = false;
              "browser.download.manager.addToRecentDocs" = false;
              "browser.download.always_ask_before_handling_new_types" = true;

              # =========================
              # MISCELLANEOUS
              # =========================

              # Disable various features
              "browser.uitour.enabled" = false;
              "permissions.manager.defaultsUrl" = "";
              "network.IDN_show_punycode" = true;
              "browser.tabs.searchclipboardfor.middleclick" = false;
              "browser.contentanalysis.enabled" = false;
              "browser.contentanalysis.default_result" = 0;
              "browser.contentblocking.category" = "strict";
              "browser.bookmarks.showMobileBookmarks" = false;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.search.widget.inNavBar" = false;
              "browser.translate.enable" = false;
              "browser.translations.automaticallyPopup" = false;

              # Additional arkenfox settings
              "accessibility.force_disabled" = 1; # Disable accessibility services (fingerprinting)

              # UI configuration (replaces DisplayMenuBar policy)
              "browser.toolbars.bookmarks.visibility" = "never";

              # Skip onboarding (replaces UserMessaging.SkipOnboarding policy)
              "browser.aboutwelcome.enabled" = false;

              # =========================
              # PRIVACY SANITIZATION
              # =========================

              # Data clearing settings (preserve persistent logins across browser restarts)
              "privacy.sanitize.sanitizeOnShutdown" = false;
              "privacy.clearOnShutdown_v2.cache" = true;
              "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
              "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
              "privacy.clearOnShutdown_v2.downloads" = true;
              "privacy.clearOnShutdown_v2.formdata" = true;
              "privacy.clearOnShutdown_v2.cookiesAndStorage" = false; # Preserve cookies for persistent logins
              "privacy.clearOnShutdown_v2.sessions" = false; # Preserve sessions across browser restarts

              # Enable session restore for persistent logins
              "browser.sessionstore.resume_from_crash" = true; # Allow session restoration
              "browser.sessionstore.max_tabs_undo" = 10; # Allow tab restoration
              "browser.sessionstore.max_windows_undo" = 3; # Allow window restoration

              # Manual clearing preserves cookies
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

              # =========================
              # FINGERPRINTING RESISTANCE
              # =========================

              # Modern fingerprinting protection (allows dark mode and persistent logins)
              "privacy.resistFingerprinting" = false; # Disable old RFP for dark mode compatibility
              "privacy.resistFingerprinting.pbmode" = false;
              "privacy.fingerprintingProtection" = true; # Enable new FPP (FF114+)
              "privacy.fingerprintingProtection.pbmode" = true;
              "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme"; # Allow dark mode preference

              # Configure cookies for login persistence
              "network.cookie.cookieBehavior" = 1; # Block third-party cookies but allow first-party for logins
              "privacy.partition.network_state" = false; # Don't partition network state for login persistence
              "network.cookie.lifetimePolicy" = 0; # Accept cookies normally

              # Keep important fingerprinting protections
              "privacy.window.maxInnerWidth" = 1600;
              "privacy.window.maxInnerHeight" = 900;
              "privacy.resistFingerprinting.block_mozAddonManager" = true;
              "privacy.spoof_english" = 1;
              "browser.display.use_system_colors" = false;
              "widget.non-native-theme.use-theme-accent" = false;
              "privacy.firstparty.isolate" = false;

              # Disable WebGL (potential fingerprinting vector)
              "webgl.disabled" = true;

              # Font privacy (arkenfox 1400)
              "browser.display.use_document_fonts" = 0;

              # =========================
              # PERFORMANCE
              # =========================

              # Hardware acceleration
              "layers.acceleration.force-enabled" = true;

              # =========================
              # UI & THEME
              # =========================

              # Enable dark mode (works with FPP)
              "ui.systemUsesDarkTheme" = 1; # Force Firefox UI to use dark theme
              "browser.in-content.dark-mode" = true; # Dark mode for Firefox pages (about:*, settings)
              "layout.css.prefers-color-scheme.content-override" = 0; # Use system preference for websites
              "browser.theme.dark-private-windows" = true; # Dark theme for private windows
              "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org"; # Set dark theme as active

              "browser.tabs.loadInBackground" = true;
              "widget.gtk.rounded-bottom-corners.enabled" = true;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "svg.context-properties.content.enabled" = true;
              "gnomeTheme.hideSingleTab" = true;
              "gnomeTheme.bookmarksToolbarUnderTabs" = true;
              "gnomeTheme.normalWidthTabs" = false;
              "gnomeTheme.tabsAsHeaderbar" = false;
              "browser.fullscreen.autohide" = false;
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
              "npm" = {
                urls = [
                  {
                    template = "https://npmjs.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://static-production.npmjs.com/c426a1116301d1fd178c51522484127a.png";
                definedAliases = ["@npm"];
              };
              "Docker Hub" = {
                urls = [
                  {
                    template = "https://hub.docker.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://hub.docker.com/favicon.ico";
                definedAliases = ["@docker"];
              };
              # TODO: do not use google
              "man7" = {
                urls = [
                  {
                    template = "https://www.google.com/search";
                    params = [
                      {
                        name = "sitesearch";
                        value = "man7.org/linux/man-pages";
                      }
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://www.man7.org/koru-icon.png";
                definedAliases = ["@man"];
              };
              "svgl" = {
                urls = [
                  {
                    template = "https://svgl.app/";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://svgl.app/images/logo.svg";
                definedAliases = ["@logo"];
              };
              "Goodreads" = {
                urls = [
                  {
                    template = "https://www.goodreads.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "https://www.goodreads.com/favicon.ico";
                definedAliases = ["@goodreads"];
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
            userChrome = ''
              @import "firefox-gnome-theme/userChrome.css";
              @import "firefox-gnome-theme/theme/colors/dark.css";
            '';
            userContent = ''
              @import "firefox-gnome-theme/userContent.css";
            '';
            search.force = true;
            extensions = {
              packages = with inputs.firefox-addons.packages."x86_64-linux"; [
                private-grammar-checker-harper
                vimium
                refined-github
                ublock-origin
                sponsorblock
                youtube-shorts-block
                awesome-rss
                passff
                dearrow
                return-youtube-dislikes
                # skip-redirect
                wayback-machine
              ];
              # Custom addons available in overlay if needed:
              # ] ++ (with pkgs.firefox-addons-custom; [
              #   tech-stack
              #   github-lines-of-code
              #   conventional-comments
              # ]);
            };
          };
        };
      };
    })

    (lib.mkIf config.modules.firefox.default {
      home-manager.users.nu = {...}: {
        home = {
          sessionVariables.BROWSER = "firefox";
        };
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