{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.miniflux = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Miniflux RSS aggregator";
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
          {
            title = "Vaxry Blog";
            url = "https://blog.vaxry.net/feed";
          }
          {
            title = "Simon Willison";
            url = "https://simonwillison.net/atom/everything/";
          }
          {
            title = "Drew DeVault";
            url = "https://drewdevault.com/blog/index.xml";
          }
          {
            title = "Luke Smith";
            url = "https://lukesmith.xyz/index.xml";
          }
          {
            title = "David Kriesel";
            url = "https://www.dkriesel.com/feed.php?linkto=current&content=html&mode=blogtng&blog=blog-de";
          }
        ];
        "YouTube Tech" = [
          {
            title = "Sami";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCNFFrCzvkeF4CIAkE5sv3WA";
          }
          {
            title = "Philipp Lackner";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCKNTZMRHPLXfqlbdOI7mCkg";
          }
          {
            title = "Beyond Fireship";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2Xd-TjJByJyK2w1zNwY0zQ";
          }
          {
            title = "ThePrimeagen";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw";
          }
          {
            title = "TheVimeagen";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCVk4b-svNJoeytrrlOixebQ";
          }
          {
            title = "Mental Outlaw";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7YOGHUfC1Tb6E4pudI9STA";
          }
          {
            title = "IBM";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCKWaEZ-_VweaEx1j62do_vQ";
          }
        ];
        "Study" = [
          {
            title = "Ruby Granger";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC6a8lp6vaCMhUVXPyynhjUA";
          }
          {
            title = "UnJaded Jade";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC4-uObu-mfafJyxxZFEwbvQ";
          }
        ];
        "Engineering" = [
          {
            title = "The Engineering Mindset";
            url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCk0fGHsCEzGig-rSzkfCjMw";
          }
        ];
      };
      description = "RSS feeds organized by category";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.miniflux.enable {
      # SOPS secret for Miniflux admin password (reuse FreshRSS password)
      sops.secrets.freshrss = {
        sopsFile = ../secrets.yaml;
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # Create runtime directory for miniflux credentials
      systemd.tmpfiles.rules = [
        "d /run/miniflux 0755 root root -"
      ];

      # Create admin credentials file for Miniflux
      systemd.services.miniflux-create-credentials = {
        description = "Create Miniflux admin credentials file";
        before = ["miniflux.service"];
        wantedBy = ["multi-user.target"];
        after = ["sops-nix.service"];
        wants = ["sops-nix.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
          Group = "root";
        };
        script = ''
          cat > /run/miniflux/admin-credentials <<EOF
          ADMIN_USERNAME=nu
          ADMIN_PASSWORD=$(cat ${config.sops.secrets.freshrss.path})
          EOF
          chmod 644 /run/miniflux/admin-credentials

          # Also create a user-readable password file for newsboat
          mkdir -p /run/user/1000/miniflux
          tr -d '\n' < ${config.sops.secrets.freshrss.path} > /run/user/1000/miniflux/password
          chown nu:users /run/user/1000/miniflux/password
          chmod 600 /run/user/1000/miniflux/password
        '';
      };

      # PostgreSQL database for Miniflux
      services.postgresql = {
        enable = true;
        ensureDatabases = ["miniflux"];
        ensureUsers = [
          {
            name = "miniflux";
            ensureDBOwnership = true;
          }
        ];
      };

      services.miniflux = {
        enable = true;
        adminCredentialsFile = "/run/miniflux/admin-credentials";
        config = {
          LISTEN_ADDR = "127.0.0.1:8082";
          BASE_URL = "https://rss.xavwe.dev";
          CREATE_ADMIN = 1;
          CLEANUP_FREQUENCY = "48";
          CLEANUP_ARCHIVE_READ_DAYS = "60";
          CLEANUP_ARCHIVE_UNREAD_DAYS = "180";
        };
      };

      # Ensure miniflux service waits for credentials file
      systemd.services.miniflux = {
        after = ["miniflux-create-credentials.service"];
        wants = ["miniflux-create-credentials.service"];
      };

      # Service to create categories and add feeds declaratively
      systemd.services.miniflux-setup-feeds = {
        description = "Declaratively setup RSS feeds in Miniflux";
        after = ["miniflux.service" "postgresql.service" "miniflux-create-credentials.service"];
        wants = ["miniflux.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
          Group = "root";
        };
        path = with pkgs; [curl jq miniflux];
        script = let
          # Generate commands to create categories and add feeds
          categoryCommands = lib.concatStringsSep "\n" (lib.mapAttrsToList (categoryName: feeds: ''
              echo "Creating category: ${categoryName}"
              CATEGORY_ID=$(curl -s -u "nu:$(cat ${config.sops.secrets.freshrss.path})" \
                -X POST "http://127.0.0.1:8082/v1/categories" \
                -H "Content-Type: application/json" \
                -d '{"title": "${categoryName}"}' | jq -r '.id // empty')

              if [ -z "$CATEGORY_ID" ]; then
                # Category might already exist, try to get it
                CATEGORY_ID=$(curl -s -u "nu:$(cat ${config.sops.secrets.freshrss.path})" \
                  -X GET "http://127.0.0.1:8082/v1/categories" | jq -r '.[] | select(.title == "${categoryName}") | .id')
              fi

              echo "Category '${categoryName}' ID: $CATEGORY_ID"

              ${lib.concatMapStringsSep "\n" (feed: ''
                  echo "Adding feed: ${feed.title} -> ${feed.url}"
                  RESPONSE=$(curl -s -u "nu:$(cat ${config.sops.secrets.freshrss.path})" \
                    -X POST "http://127.0.0.1:8082/v1/feeds" \
                    -H "Content-Type: application/json" \
                    -d '{
                      "feed_url": "${feed.url}",
                      "category_id": '"$CATEGORY_ID"',
                      "title": "${builtins.replaceStrings ["\""] ["\\\""] feed.title}"
                    }')
                  echo "Response: $RESPONSE"
                '')
                feeds}
            '')
            config.modules.miniflux.feeds);
        in ''
          set -eu

          echo "Waiting for Miniflux to be ready..."
          for i in {1..30}; do
            if curl -sf "http://127.0.0.1:8082/healthcheck" >/dev/null 2>&1; then
              echo "Miniflux is ready"
              break
            fi
            echo "Waiting for Miniflux... ($i/30)"
            sleep 5
          done

          # Test authentication first
          echo "Testing authentication..."
          AUTH_TEST=$(curl -s -u "nu:$(cat ${config.sops.secrets.freshrss.path})" \
            "http://127.0.0.1:8082/v1/me" | jq -r '.username // "failed"')
          echo "Auth test result: $AUTH_TEST"

          if [ "$AUTH_TEST" = "nu" ]; then
            echo "Authentication successful, setting up feeds..."
            ${categoryCommands}
            echo "Feed setup completed"
          else
            echo "Authentication failed, skipping feed setup"
            exit 1
          fi
        '';
      };

      # Nginx reverse proxy configuration for Traefik
      services.nginx.virtualHosts."rss.xavwe.dev" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 8081;
          }
        ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:8082";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    })
  ];
}
