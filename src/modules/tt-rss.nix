{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.tt-rss = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable TT-RSS RSS aggregator";
    };

    feeds = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf (lib.types.submodule {
        options = {
          title = lib.mkOption {
            type = lib.types.str;
            description = "Feed title";
          };
          url = lib.mkOption {
            type = lib.types.str;
            description = "Feed URL";
          };
          description = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Feed description";
          };
        };
      }));
      default = {
        "Tech Blogs" = [
          { title = "Vaxry Blog"; url = "https://blog.vaxry.net/feed"; }
          { title = "Simon Willison"; url = "https://simonwillison.net/atom/everything/"; }
          { title = "Drew DeVault"; url = "https://drewdevault.com/blog/index.xml"; }
          { title = "Luke Smith"; url = "https://lukesmith.xyz/index.xml"; }
          { title = "David Kriesel"; url = "https://www.dkriesel.com/feed.php?linkto=current&content=html&mode=blogtng&blog=blog-de"; }
        ];
        "YouTube Tech" = [
          { title = "Sami"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCNFFrCzvkeF4CIAkE5sv3WA"; }
          { title = "Philipp Lackner"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCKNTZMRHPLXfqlbdOI7mCkg"; }
          { title = "Beyond Fireship"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2Xd-TjJByJyK2w1zNwY0zQ"; }
          { title = "ThePrimeagen"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw"; }
          { title = "TheVimeagen"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCVk4b-svNJoeytrrlOixebQ"; }
          { title = "Mental Outlaw"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7YOGHUfC1Tb6E4pudI9STA"; }
          { title = "IBM"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCKWaEZ-_VweaEx1j62do_vQ"; }
        ];
        "Study" = [
          { title = "Ruby Granger"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC6a8lp6vaCMhUVXPyynhjUA"; }
          { title = "UnJaded Jade"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC4-uObu-mfafJyxxZFEwbvQ"; }
        ];
        "Engineering" = [
          { title = "The Engineering Mindset"; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCk0fGHsCEzGig-rSzkfCjMw"; }
        ];
      };
      description = "RSS feeds organized by category";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.tt-rss.enable {
      # TT-RSS in single user mode doesn't need external password configuration

      services.tt-rss = {
        enable = true;
        selfUrlPath = "https://rss.xavwe.dev";
        database = {
          type = "pgsql";
          createLocally = true;
        };
        # Enable single user mode for simplicity
        singleUserMode = true;
        virtualHost = "rss.xavwe.dev";
        # Configure update daemon
        updateDaemon.commandFlags = "--feeds --quiet";
        # Configure for external API access
        extraConfig = ''
          define('SINGLE_USER_MODE', true);
          define('API_ENABLED', true);
          define('API_USER_ONLY', false);
          define('SIMPLE_UPDATE_MODE', false);
          define('ENABLE_REGISTRATION', false);
          define('REG_NOTIFY_ADDRESS', "");
          define('REG_MAX_USERS', 1);
        '';
      };

      # Generate OPML file dynamically from feeds configuration
      environment.etc."tt-rss/feeds.opml" = let
        generateOutlines = categoryName: feeds:
          lib.concatMapStringsSep "\n                " (feed: 
            ''<outline type="rss" text="${lib.escapeXML feed.title}" title="${lib.escapeXML feed.title}" xmlUrl="${lib.escapeXML feed.url}" />''
          ) feeds;
        
        generateCategories = lib.concatStringsSep "\n              " (lib.mapAttrsToList (categoryName: feeds: ''
          <outline title="${lib.escapeXML categoryName}" text="${lib.escapeXML categoryName}">
                ${generateOutlines categoryName feeds}
              </outline>''
        ) config.modules.tt-rss.feeds);
      in {
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <opml version="2.0">
            <head>
              <title>TT-RSS Feeds Export</title>
            </head>
            <body>
              ${generateCategories}
            </body>
          </opml>
        '';
        mode = "0644";
      };

      # Service to set up feeds using TT-RSS API
      systemd.services.tt-rss-setup-feeds = {
        description = "Declaratively setup RSS feeds in TT-RSS";
        after = ["tt-rss.service"];
        wants = ["tt-rss.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = with pkgs; [ curl jq ];
        script = let
          # Generate feed setup commands using TT-RSS API
          setupCommands = lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList (categoryName: feeds:
            map (feed: ''
              echo "Adding feed: ${feed.title} -> ${feed.url}"
              curl -s -X POST "https://rss.xavwe.dev/api/" \
                -H "Content-Type: application/json" \
                -d '{
                  "op": "subscribeToFeed",
                  "feed_url": "${feed.url}",
                  "category_id": 0,
                  "login": "admin",
                  "password": ""
                }' || echo "Feed add failed, continuing..."
            '') feeds
          ) config.modules.tt-rss.feeds));
        in ''
          set -eu
          
          echo "Waiting for TT-RSS to be ready..."
          sleep 30
          
          # Wait for TT-RSS web interface
          for i in {1..30}; do
            if curl -sf "https://rss.xavwe.dev" >/dev/null 2>&1; then
              echo "TT-RSS is ready"
              break
            fi
            echo "Waiting for TT-RSS... ($i/30)"
            sleep 5
          done
          
          echo "Setting up feeds..."
          ${setupCommands}
          
          echo "Feed setup completed"
        '';
      };

      # Alternative: Create a SQL initialization script that runs after TT-RSS setup
      systemd.services.tt-rss-init-feeds = {
        description = "Initialize TT-RSS with feeds via SQL";
        after = ["tt-rss.service" "postgresql.service"];
        wants = ["tt-rss.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "tt_rss";
          Group = "tt_rss";
        };
        path = with pkgs; [ postgresql ];
        script = let
          allFeeds = lib.flatten (lib.mapAttrsToList (categoryName: feeds:
            map (feed: { inherit (feed) title url; category = categoryName; }) feeds
          ) config.modules.tt-rss.feeds);
          
          sqlCommands = lib.concatMapStringsSep "\n" (feed: ''
            -- Add category if not exists
            INSERT INTO ttrss_feed_categories (title, owner_uid) 
            VALUES ('${feed.category}', 1) 
            ON CONFLICT (title, owner_uid) DO NOTHING;
            
            -- Add feed
            INSERT INTO ttrss_feeds (feed_url, title, cat_id, owner_uid, update_interval) 
            SELECT '${feed.url}', '${builtins.replaceStrings ["'"] ["''"] feed.title}', 
                   COALESCE((SELECT id FROM ttrss_feed_categories WHERE title = '${feed.category}' AND owner_uid = 1), 0),
                   1, 0
            ON CONFLICT (feed_url, owner_uid) DO NOTHING;
          '') allFeeds;
        in ''
          set -eu
          
          echo "Waiting for database to be ready..."
          sleep 20
          
          # Wait for database connection
          for i in {1..20}; do
            if psql -d tt_rss -c "SELECT 1;" >/dev/null 2>&1; then
              echo "Database is ready"
              break
            fi
            echo "Waiting for database... ($i/20)"
            sleep 3
          done
          
          echo "Adding feeds to database..."
          psql -d tt_rss -v ON_ERROR_STOP=1 <<'EOF'
          ${sqlCommands}
          EOF
          
          echo "Feeds added to database successfully"
        '';
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