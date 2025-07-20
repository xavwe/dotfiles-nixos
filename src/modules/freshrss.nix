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

      # Service to enable API globally
      systemd.services.freshrss-enable-api = {
        description = "Enable FreshRSS API globally";
        after = ["freshrss-config.service"];
        before = ["freshrss-import-feeds.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = with pkgs; [ systemd ];
        script = ''
          # Create config.local.php to enable API
          cat > "${config.services.freshrss.dataDir}/config.local.php" <<EOF
          <?php
          return array(
            'api_enabled' => true,
          );
          EOF
          
          # Ensure proper ownership
          chown freshrss:freshrss "${config.services.freshrss.dataDir}/config.local.php"
          chmod 644 "${config.services.freshrss.dataDir}/config.local.php"
          
          echo "FreshRSS API enabled globally"
          
          # Restart PHP-FPM to reload configuration
          systemctl restart phpfpm-freshrss.service
        '';
      };

      # Generate OPML file dynamically from feeds configuration
      environment.etc."freshrss/feeds.opml" = let
        generateOutlines = categoryName: feeds:
          lib.concatMapStringsSep "\n                " (feed: 
            ''<outline type="rss" text="${lib.escapeXML feed.title}" title="${lib.escapeXML feed.title}" xmlUrl="${lib.escapeXML feed.url}" />''
          ) feeds;
        
        generateCategories = lib.concatStringsSep "\n              " (lib.mapAttrsToList (categoryName: feeds: ''
          <outline title="${lib.escapeXML categoryName}" text="${lib.escapeXML categoryName}">
                ${generateOutlines categoryName feeds}
              </outline>''
        ) config.modules.freshrss.feeds);
      in {
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <opml version="2.0">
            <head>
              <title>FreshRSS Feeds Export</title>
            </head>
            <body>
              ${generateCategories}
            </body>
          </opml>
        '';
        mode = "0644";
      };

      # Service to configure API and import feeds
      systemd.services.freshrss-import-feeds = {
        description = "Configure FreshRSS API and import RSS feeds from OPML";
        after = ["freshrss-config.service"];
        wants = ["freshrss-config.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "freshrss";
          Group = "freshrss";
        };
        path = with pkgs; [ php gnused ];
        script = ''
          set -eu
          
          # Wait for FreshRSS to be fully initialized
          echo "Waiting for FreshRSS to be ready..."
          while [ ! -f "${config.services.freshrss.dataDir}/users/${config.services.freshrss.defaultUser}/config.php" ]; do
            sleep 2
          done
          
          echo "FreshRSS is ready, configuring API and importing feeds..."
          
          # Enable API access directly in user config file
          USER_CONFIG="${config.services.freshrss.dataDir}/users/${config.services.freshrss.defaultUser}/config.php"
          echo "Enabling API access in user configuration..."
          
          # Check if API access is already enabled
          if ! grep -q "allow_api_access" "$USER_CONFIG"; then
            # Add API access configuration
            sed -i "/return array (/a\\
            \\t'allow_api_access' => true," "$USER_CONFIG"
          else
            # Update existing configuration
            sed -i "s/'allow_api_access' => false/'allow_api_access' => true/" "$USER_CONFIG"
          fi
          
          # Copy FreshRSS to a writable location temporarily for CLI operations
          TEMP_DIR=$(mktemp -d)
          cp -r "${config.services.freshrss.package}"/* "$TEMP_DIR/"
          chmod -R u+w "$TEMP_DIR"
          
          # Change to temp directory and set up symlinks to actual data
          cd "$TEMP_DIR"
          rm -rf data && ln -sf "${config.services.freshrss.dataDir}" data
          
          # Set API password for the user (force update)
          echo "Setting API password..."
          php ./cli/update-user.php --user "${config.services.freshrss.defaultUser}" --api-password "$(cat ${config.sops.secrets.freshrss.path})"
          
          # Verify API password was set
          echo "Verifying API setup..."
          php ./cli/user-info.php --user "${config.services.freshrss.defaultUser}"
          
          # Import feeds from the generated OPML file
          echo "Importing feeds from OPML..."
          php ./cli/import-for-user.php \
            --user "${config.services.freshrss.defaultUser}" \
            --filename "/etc/freshrss/feeds.opml"
          
          # Clean up
          rm -rf "$TEMP_DIR"
          
          echo "API configured and feeds imported successfully"
        '';
        environment = {
          # Set the data directory so FreshRSS CLI can find the configuration
          FRESHRSS_DATA_PATH = config.services.freshrss.dataDir;
        };
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