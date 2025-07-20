{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.freshrss = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable FreshRSS RSS aggregator";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.freshrss.enable {
      # SOPS secret for FreshRSS password
      sops.secrets.freshrss = {
        sopsFile = ../secrets.yaml;
        owner = "freshrss";
        group = "freshrss";
        mode = "0400";
      };

      # Clean start for FreshRSS - remove stale state
      systemd.services.freshrss-clean = {
        description = "Clean FreshRSS data directory for fresh start";
        wantedBy = ["freshrss-config.service"];
        before = ["freshrss-config.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          # Complete FreshRSS data directory cleanup for truly fresh start
          if [ -d "${config.services.freshrss.dataDir}" ]; then
            # Remove everything except the directory itself
            rm -rf "${config.services.freshrss.dataDir}"/*
            rm -rf "${config.services.freshrss.dataDir}"/.*  2>/dev/null || true
          fi
          
          # Recreate basic directory structure
          mkdir -p "${config.services.freshrss.dataDir}"/{data,cache,users,favicons,extensions-data,tokens,PubSubHubbub,fever}
          
          # Ensure proper ownership
          chown -R freshrss:freshrss "${config.services.freshrss.dataDir}"
          chmod -R 755 "${config.services.freshrss.dataDir}"
          
          echo "FreshRSS data directory completely cleaned and reset"
        '';
      };

      services.freshrss = {
        enable = true;
        package = pkgs.freshrss;
        authType = "form";
        baseUrl = "https://rss.xavwe.dev";
        defaultUser = "nu";
        passwordFile = config.sops.secrets.freshrss.path;
        language = "en";
        webserver = "nginx";
        virtualHost = "rss.xavwe.dev";
        database = {
          type = "sqlite";
          name = "freshrss";
          user = "freshrss";
        };
        # Add some useful extensions
        extensions = with pkgs.freshrss-extensions; [
          youtube
          reading-time
        ];
      };

      # Generate OPML file with all feeds
      environment.etc."freshrss/feeds.opml" = {
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <opml version="2.0">
            <head>
              <title>Newsboat Feeds Export</title>
            </head>
            <body>
              <outline title="Tech Blogs" text="Tech Blogs">
                <outline type="rss" text="Vaxry Blog" title="Vaxry Blog" xmlUrl="https://blog.vaxry.net/feed" />
                <outline type="rss" text="Simon Willison" title="Simon Willison" xmlUrl="https://simonwillison.net/atom/everything/" />
                <outline type="rss" text="Drew DeVault" title="Drew DeVault" xmlUrl="https://drewdevault.com/blog/index.xml" />
                <outline type="rss" text="Luke Smith" title="Luke Smith" xmlUrl="https://lukesmith.xyz/index.xml" />
                <outline type="rss" text="David Kriesel" title="David Kriesel" xmlUrl="https://www.dkriesel.com/feed.php?linkto=current&amp;content=html&amp;mode=blogtng&amp;blog=blog-de" />
              </outline>
              <outline title="YouTube Tech" text="YouTube Tech">
                <outline type="rss" text="Sami" title="Sami" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UCNFFrCzvkeF4CIAkE5sv3WA" />
                <outline type="rss" text="Philipp Lackner" title="Philipp Lackner" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UCKNTZMRHPLXfqlbdOI7mCkg" />
                <outline type="rss" text="Beyond Fireship" title="Beyond Fireship" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UC2Xd-TjJByJyK2w1zNwY0zQ" />
                <outline type="rss" text="ThePrimeagen" title="ThePrimeagen" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw" />
                <outline type="rss" text="TheVimeagen" title="TheVimeagen" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UCVk4b-svNJoeytrrlOixebQ" />
                <outline type="rss" text="Mental Outlaw" title="Mental Outlaw" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UC7YOGHUfC1Tb6E4pudI9STA" />
                <outline type="rss" text="IBM" title="IBM" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UCKWaEZ-_VweaEx1j62do_vQ" />
              </outline>
              <outline title="Study" text="Study">
                <outline type="rss" text="Ruby Granger" title="Ruby Granger" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UC6a8lp6vaCMhUVXPyynhjUA" />
                <outline type="rss" text="UnJaded Jade" title="UnJaded Jade" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UC4-uObu-mfafJyxxZFEwbvQ" />
              </outline>
              <outline title="Engineering" text="Engineering">
                <outline type="rss" text="The Engineering Mindset" title="The Engineering Mindset" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=UCk0fGHsCEzGig-rSzkfCjMw" />
              </outline>
            </body>
          </opml>
        '';
        mode = "0644";
      };


      # Override nginx virtual host to listen on internal port for Traefik
      services.nginx.virtualHosts."rss.xavwe.dev" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 8081;
          }
        ];
      };
    })
  ];
}