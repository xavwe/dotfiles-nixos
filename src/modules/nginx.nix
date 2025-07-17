{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.nginx = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nginx web server";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.nginx.enable {
      services.nginx = {
        enable = true;

        # Listen only on localhost:8080 (internal port for Traefik)
        defaultHTTPListenPort = 8080;
        defaultSSLListenPort = 8443;

        # Default server configuration
        virtualHosts = {
          "test.xavwe.dev" = {
            listen = [
              {
                addr = "127.0.0.1";
                port = 8080;
              }
            ];

            locations = {
              "/" = {
                root = "/var/www/html";
                index = "index.html";
              };
            };
          };
        };

        # Enable gzip compression
        commonHttpConfig = ''
          gzip on;
          gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
          gzip_min_length 1000;
        '';
      };

      # Create sample website directory and content
      systemd.tmpfiles.rules = [
        "d /var/www 0755 nginx nginx - -"
        "d /var/www/html 0755 nginx nginx - -"
      ];

      # Create sample index.html
      environment.etc."nginx/html/index.html" = {
        text = ''
          <!DOCTYPE html>
          <html lang="en">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Welcome to Nginx behind Traefik</title>
              <style>
                  body {
                      font-family: Arial, sans-serif;
                      max-width: 800px;
                      margin: 0 auto;
                      padding: 20px;
                      background-color: #f5f5f5;
                  }
                  .container {
                      background-color: white;
                      padding: 30px;
                      border-radius: 10px;
                      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                  }
                  h1 {
                      color: #333;
                      text-align: center;
                  }
                  .status {
                      background-color: #e8f5e8;
                      padding: 15px;
                      border-radius: 5px;
                      margin: 20px 0;
                  }
                  .tech-stack {
                      display: flex;
                      justify-content: space-around;
                      margin: 30px 0;
                  }
                  .tech-item {
                      text-align: center;
                      padding: 20px;
                      background-color: #f8f9fa;
                      border-radius: 5px;
                      flex: 1;
                      margin: 0 10px;
                  }
              </style>
          </head>
          <body>
              <div class="container">
                  <h1>🚀 Welcome to Your NixOS Web Stack!</h1>

                  <div class="status">
                      <strong>✅ Status:</strong> Nginx is running successfully behind Traefik reverse proxy
                  </div>

                  <div class="tech-stack">
                      <div class="tech-item">
                          <h3>🔄 Traefik</h3>
                          <p>Reverse Proxy</p>
                          <p>Ports: 80 → 443</p>
                      </div>
                      <div class="tech-item">
                          <h3>🌐 Nginx</h3>
                          <p>Web Server</p>
                          <p>Internal: 8080</p>
                      </div>
                      <div class="tech-item">
                          <h3>❄️ NixOS</h3>
                          <p>Configuration</p>
                          <p>Declarative Setup</p>
                      </div>
                  </div>

                  <h2>🔧 Configuration Details</h2>
                  <ul>
                      <li><strong>Traefik:</strong> Handles SSL termination and routing</li>
                      <li><strong>Nginx:</strong> Serves content on internal port 8080</li>
                      <li><strong>Firewall:</strong> Only ports 80 and 443 are publicly accessible</li>
                      <li><strong>HTTPS:</strong> Automatic redirect from HTTP to HTTPS</li>
                  </ul>

                  <h2>📊 Access Information</h2>
                  <ul>
                      <li><strong>Website:</strong> <a href="https://test.xavwe.dev">https://test.xavwe.dev</a></li>
                      <li><strong>Traefik Dashboard:</strong> <a href="https://traefik.xavwe.dev">https://traefik.xavwe.dev</a></li>
                  </ul>

                  <p style="text-align: center; margin-top: 30px; color: #666;">
                      This is a sample website served by Nginx behind Traefik on NixOS<br>
                      <strong>Domain:</strong> test.xavwe.dev with Cloudflare DNS challenge
                  </p>
              </div>
          </body>
          </html>
        '';
        mode = "0644";
      };

      # Copy the sample website to the web root
      systemd.services.nginx-setup = {
        description = "Setup Nginx sample website";
        wantedBy = ["nginx.service"];
        before = ["nginx.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          mkdir -p /var/www/html
          cp /etc/nginx/html/index.html /var/www/html/index.html
          chown -R nginx:nginx /var/www
          chmod -R 755 /var/www
        '';
      };

      # Ensure nginx user and group exist
      users.users.nginx = {
        isSystemUser = true;
        group = "nginx";
        home = "/var/www";
      };
      users.groups.nginx = {};
    })
  ];
}
