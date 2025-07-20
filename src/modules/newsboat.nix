{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.newsboat = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use newsboat";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.newsboat.enable {
      home-manager.users.nu = {...}: {
        programs.newsboat = {
          enable = true;
          # Connect to FreshRSS via Google Reader API
          urls = [];
          extraConfig = ''
            # FreshRSS API configuration
            urls-source "freshrss"
            freshrss-url "https://rss.xavwe.dev/api/greader.php"
            freshrss-login "admin"
            freshrss-password "admin123"
            freshrss-flag-share "a"
            freshrss-flag-star "s"

            # Key bindings
            bind-key j down
            bind-key k up
            bind-key j down feedlist
            bind-key k up feedlist
            bind-key j next articlelist
            bind-key k prev articlelist
            bind-key J next-feed articlelist
            bind-key K prev-feed articlelist
            bind-key j down article
            bind-key k up article

            # Macro to open in mpv with floating window (https://www.reddit.com/r/commandline/comments/mqkqig/comment/mzp3jvw/)
            macro p set browser "mpv --ontop --no-border --force-window --autofit=500x280 --geometry=-15-10 %u"; open-in-browser ; set browser "$BROWSER %u"

            color background          color7     color0
            color listnormal          color240      color0
            color listnormal_unread   color7      color0
            color listfocus           color240   color8
            color listfocus_unread    color7   color8
            color info                color8     color0
            color article             color223   color0

            # highlights
            highlight article "^(Feed|Link):.*$" color11 default bold
            highlight article "^(Title|Date|Author):.*$" color11 default bold
            highlight article "https?://[^ ]+" color2 default underline
            highlight article "\\[[0-9]+\\]" color2 default bold
            highlight article "\\[image\\ [0-9]+\\]" color2 default bold
            highlight feedlist "^─.*$" color6 color6 bold
          '';
        };
      };
    })
  ];
}
