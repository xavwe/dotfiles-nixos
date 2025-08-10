{inputs}: final: prev: let
  # Generic function for creating Calibre plugins from release ZIP files
  mkCalibrePlugin = {
    pname,
    version,
    url,
    sha256,
    meta ? {},
  }:
    final.stdenv.mkDerivation {
      inherit pname version;

      src = final.fetchurl {
        inherit url sha256;
      };

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        # Create plugin directory and copy the ZIP file
        mkdir -p $out/share/calibre-plugins
        cp $src $out/share/calibre-plugins/${pname}.zip

        runHook postInstall
      '';

      meta = with final.lib;
        {
          platforms = platforms.all;
        }
        // meta;
    };
in {
  btop-gpu = prev.stdenv.mkDerivation rec {
    pname = "btop";
    version = "1.4.4";

    src = final.fetchFromGitHub {
      owner = "aristocratos";
      repo = "btop";
      rev = "v${version}";
      sha256 = "sha256-4H9UjewJ7UFQtTQYwvHZL3ecPiChpfT6LEZwbdBCIa0=";
    };

    nativeBuildInputs = [prev.makeWrapper];
    buildInputs = [
      prev.ncurses
      prev.pciutils
    ];

    makeFlags = ["GPU_SUPPORT=true"];

    installPhase = ''
      mkdir -p $out/bin
      cp bin/btop $out/bin/
    '';
  };

  ccusage = final.buildNpmPackage rec {
    pname = "ccusage";
    version = "15.3.1";

    src = final.fetchzip {
      url = "https://registry.npmjs.org/ccusage/-/ccusage-${version}.tgz";
      hash = "sha256-y3Vg8BIeBYUrGCijs9MZe5mDrhuTzmlUOju8HZct/FU=";
    };

    npmDepsHash = "sha256-3n0JlwuPlp7NKRbTvvxdzbS5u/R/07XatIEKr7S9Y64=";
    forceEmptyCache = true;

    postPatch = ''
            cat > package-lock.json << 'EOF'
      {
        "name": "ccusage",
        "version": "15.3.1",
        "lockfileVersion": 3,
        "requires": true,
        "packages": {
          "": {
            "name": "ccusage",
            "version": "15.3.1"
          }
        }
      }
      EOF
    '';

    nativeBuildInputs = with final; [makeWrapper];

    dontNpmBuild = true;
    dontNpmInstall = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib/node_modules/ccusage
      cp -r * $out/lib/node_modules/ccusage/
      makeWrapper ${final.nodejs}/bin/node $out/bin/ccusage \
        --add-flags "$out/lib/node_modules/ccusage/dist/index.js"
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "A CLI tool for analyzing Claude Code usage from local JSONL files";
      homepage = "https://github.com/ryoppippi/ccusage";
      license = licenses.mit;
      platforms = platforms.all;
      mainProgram = "ccusage";
    };
  };

  claude-trace = final.stdenv.mkDerivation rec {
    pname = "claude-trace";
    version = "1.0.3";

    src = final.fetchzip {
      url = "https://registry.npmjs.org/@mariozechner/claude-trace/-/claude-trace-${version}.tgz";
      hash = "sha256-cbTb37Th0t182CMRVNdyHbquzEHLcn0/WMdeRscxKuM=";
    };

    nativeBuildInputs = with final; [makeWrapper];

    dontBuild = true;

    installPhase = ''
            runHook preInstall
            mkdir -p $out/bin $out/lib/node_modules/@mariozechner/claude-trace
            cp -r * $out/lib/node_modules/@mariozechner/claude-trace/

            # Create a Node.js wrapper that directly executes the Claude binary
            cat > $out/lib/node_modules/@mariozechner/claude-trace/dist/claude-node-wrapper.js << 'EOF'
      #!/usr/bin/env node
      const fs = require("fs");

      // This wrapper directly executes the Claude Node.js binary to allow network interception
      // The interceptor must run in the same process as Claude for fetch/HTTP patching to work

      const claudePath = "${final.unfree.claude-code}/bin/claude";
      const args = process.argv.slice(2);

      // Set environment variables for Claude
      process.env.DISABLE_AUTOUPDATER = '1';

      function findClaudeJSPath(scriptPath) {
        if (!fs.existsSync(scriptPath)) {
          return null;
        }

        const scriptContent = fs.readFileSync(scriptPath, 'utf8');

        // Look for exec lines that point to either Node.js or another script
        const execMatches = scriptContent.match(/exec\s+(?:-a\s+[^\s]+\s+)?"([^"]+)"/g) || [];

        for (const match of execMatches) {
          const pathMatch = match.match(/exec\s+(?:-a\s+[^\s]+\s+)?"([^"]+)"/);
          if (pathMatch) {
            const execPath = pathMatch[1];
            if (execPath.endsWith('.js')) {
              return execPath;
            } else if (execPath.includes('node')) {
              // This is a node execution, look for the JS file in the arguments
              const argsMatch = scriptContent.match(/exec\s+(?:-a\s+[^\s]+\s+)?"[^"]+"\s+(.+)/);
              if (argsMatch) {
                const nodeArgs = argsMatch[1];
                const jsFileMatch = nodeArgs.match(/(\S+\.js)/);
                if (jsFileMatch) {
                  return jsFileMatch[1];
                }
              }
            } else {
              // This might be another wrapper script, recurse
              const nestedPath = findClaudeJSPath(execPath);
              if (nestedPath) {
                return nestedPath;
              }
            }
          }
        }

        return null;
      }

      // Find the actual Claude JS file
      const claudeJSPath = findClaudeJSPath(claudePath);

      if (claudeJSPath) {
        // Set up process.argv to match what Claude expects
        process.argv = [process.argv[0], claudeJSPath, ...args];

        // Directly import and execute the Claude module (ESM)
        import(claudeJSPath).catch(error => {
          console.error("Error loading Claude module:", error);
          process.exit(1);
        });
      } else {
        console.error("Could not determine Claude Node.js module path");
        process.exit(1);
      }
      EOF

            chmod +x $out/lib/node_modules/@mariozechner/claude-trace/dist/claude-node-wrapper.js

            # Patch cli.js to use our Node.js wrapper instead of the bash script
            sed -i 's|const claudePath = getClaudeAbsolutePath();|const claudePath = path.join(__dirname, "claude-node-wrapper.js");|g' \
              $out/lib/node_modules/@mariozechner/claude-trace/dist/cli.js

            # Create wrapper that properly handles ES modules
            makeWrapper ${final.nodejs}/bin/node $out/bin/claude-trace \
              --add-flags "$out/lib/node_modules/@mariozechner/claude-trace/dist/cli.js" \
              --set NODE_PATH "$out/lib/node_modules"

            runHook postInstall
    '';

    meta = with final.lib; {
      description = "Record all your interactions with Claude Code as you develop your projects";
      homepage = "https://github.com/badlogic/lemmy/tree/main/apps/claude-trace";
      license = licenses.mit;
      platforms = platforms.all;
      mainProgram = "claude-trace";
    };
  };

  extract = inputs.extract.packages.x86_64-linux.default;

  workspace-diagnostics-nvim = final.vimUtils.buildVimPlugin {
    pname = "workspace-diagnostics-nvim";
    version = "unstable-2025-01-08";
    src = final.fetchFromGitHub {
      owner = "artemave";
      repo = "workspace-diagnostics.nvim";
      rev = "60f9175b2501ae3f8b1aba9719c0df8827610c8e";
      sha256 = "sha256-jSpKaKnGyip/nzqU52ypWLgoCtvccYN+qb5jzlwAnd4=";
    };
  };

  calibre-plugin-worddumb = mkCalibrePlugin {
    pname = "WordDumb";
    version = "3.33.3";
    url = "https://github.com/xxyzz/WordDumb/releases/download/v3.33.3/worddumb-v3.33.3.zip";
    sha256 = "sha256-tbT8l86x6enY2+3n0Rr8WBEp59AnSImrItkq0krFr0s=";

    meta = {
      description = "A Calibre plugin that generates Word Wise and X-Ray files for Kindle e-books";
      homepage = "https://github.com/xxyzz/WordDumb";
      license = final.lib.licenses.gpl3Plus;
    };
  };

  calibre-plugin-epubsplit = mkCalibrePlugin {
    pname = "EpubSplit";
    version = "3.12.0";
    url = "https://github.com/JimmXinu/EpubSplit/releases/download/v3.12.0/EpubSplit.zip";
    sha256 = "sha256-B2cfPekrJUMJDA0aBPkCZ9Gfa0gP1I64XXr8JvycuQ8=";

    meta = {
      description = "A Calibre plugin to split EPUB files into separate volumes";
      homepage = "https://github.com/JimmXinu/EpubSplit";
      license = final.lib.licenses.asl20;
    };
  };

  # DeDRM tools come as a multi-plugin package, we need to extract individual plugins
  calibre-plugin-dedrm = final.stdenv.mkDerivation {
    pname = "calibre-plugin-dedrm";
    version = "10.0.3";

    src = final.fetchurl {
      url = "https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip";
      sha256 = "sha256-hknjDvsMJunMoRMd9MnQLVHsy1Ao05bM6Ffw+nWmKEk=";
    };

    nativeBuildInputs = [final.unzip];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Extract the downloaded ZIP
      unzip -q $src

      # Create output directory
      mkdir -p $out/share/calibre-plugins

      # The DeDRM release already contains individual plugin ZIP files
      # Just copy them directly
      cp DeDRM_plugin.zip $out/share/calibre-plugins/DeDRM.zip
      cp Obok_plugin.zip $out/share/calibre-plugins/Obok.zip

      runHook postInstall
    '';

    meta = {
      description = "DeDRM tools for removing DRM from various ebook formats";
      homepage = "https://github.com/noDRM/DeDRM_tools";
      license = final.lib.licenses.gpl3Plus;
    };
  };

  calibre-plugin-epubmerge = mkCalibrePlugin {
    pname = "EpubMerge";
    version = "3.2.0";
    url = "https://github.com/JimmXinu/EpubMerge/releases/download/v3.2.0/EpubMerge.zip";
    sha256 = "sha256-GH6JE7bnnytdOocNtSnh5ENV5cEr7vM6BRyJC8uTijU=";

    meta = {
      description = "A Calibre plugin to merge multiple EPUB files into a single volume";
      homepage = "https://github.com/JimmXinu/EpubMerge";
      license = final.lib.licenses.asl20;
    };
  };

  rofi-nerdfont = final.stdenv.mkDerivation rec {
    pname = "rofi-nerdfont";
    version = "unstable-2025-08-10";

    src = final.fetchFromGitHub {
      owner = "mikamo3";
      repo = "rofi-nerd-fonts-icons";
      rev = "2ff62d8";
      hash = "sha256-fspr/ehrPYxX7bRFuC7TG9O2F/PpswiTz0jK8hqUVZY=";
    };

    nativeBuildInputs = [ final.makeWrapper ];

    buildInputs = with final; [
      python3
      python3.pkgs.cssutils
      python3.pkgs.requests
      rofi-wayland
      wl-clipboard
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp main.py $out/bin/rofi-nerdfont
      chmod +x $out/bin/rofi-nerdfont
      
      wrapProgram $out/bin/rofi-nerdfont \
        --prefix PATH : ${final.lib.makeBinPath [ final.rofi-wayland final.wl-clipboard ]} \
        --prefix PYTHONPATH : "$PYTHONPATH"
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "Rofi script for searching and copying Nerd Font icons";
      homepage = "https://github.com/mikamo3/rofi-nerd-fonts-icons";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [];
    };
  };

  literata = final.stdenv.mkDerivation rec {
    pname = "literata";
    version = "3.103";

    src = final.fetchzip {
      url = "https://github.com/googlefonts/literata/releases/download/${version}/${version}.zip";
      hash = "sha256-XwwvyzwO2uhi1Bay9HtB75j1QfAJR4TMETgy/zyvwZ0=";
      stripRoot = false;
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/truetype
      find . -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;

      runHook postInstall
    '';

    meta = with final.lib; {
      description = "A serif typeface designed for ebooks and optimized for reading";
      homepage = "https://github.com/googlefonts/literata";
      license = licenses.ofl;
      platforms = platforms.all;
    };
  };

  rofi-nerdy = let
    lockFile = final.stdenv.mkDerivation {
      pname = "rofi-nerdy-lock";
      version = "0.0.7";

      src = final.fetchFromGitHub {
        owner = "rolv-apneseth";
        repo = "rofi-nerdy";
        rev = "v0.0.7";
        sha256 = "sha256-Sfo9p/4aqR6DRo7mXihQpn0MvVCFPh/izNQiVEzk/LM=";
      };

      nativeBuildInputs = [ final.cargo final.cacert ];

      installPhase = ''
        cargo generate-lockfile
        cp Cargo.lock $out
      '';

      outputHashAlgo = "sha256";
      outputHash = "sha256-V9wM6FQHmsfJlGwotPtfk6DHjbiQgrni1tqeOtkk9so=";
      outputHashMode = "flat";
    };
  in
    final.rustPlatform.buildRustPackage rec {
      pname = "rofi-nerdy";
      version = "0.0.7";

      src = final.fetchFromGitHub {
        owner = "rolv-apneseth";
        repo = "rofi-nerdy";
        rev = "v${version}";
        sha256 = "sha256-Sfo9p/4aqR6DRo7mXihQpn0MvVCFPh/izNQiVEzk/LM=";
      };

      cargoLock.lockFile = lockFile;

      postPatch = ''
        cp ${lockFile} Cargo.lock
      '';

      nativeBuildInputs = with final; [
        pkg-config
        just
        rofi-wayland
      ];

      buildInputs = with final; [
        glib
        cairo
        pango
      ];

      installPhase = ''
        runHook preInstall
        just --set PKGDIR "$out" install
        runHook postInstall
      '';

      meta = with final.lib; {
        description = "Nerd font icon selector plugin for rofi";
        homepage = "https://github.com/Rolv-Apneseth/rofi-nerdy";
        license = licenses.agpl3Plus;
        platforms = platforms.linux;
      };
    };
}
