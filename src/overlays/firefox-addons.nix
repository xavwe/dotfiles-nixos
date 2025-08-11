{inputs}: final: prev: let
  # Create firefox addons that can be used just like the ones from firefox-addons input
  buildFirefoxXpiAddon = {
    pname,
    version,
    addonId,
    url,
    sha256,
    meta ? {},
  }:
    final.stdenv.mkDerivation {
      inherit pname version;

      src = final.fetchurl {
        inherit url sha256;
      };

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';

      meta = with final.lib;
        {
          platforms = platforms.all;
        }
        // meta;
    };
in {
  firefox-addons-custom = {
    # TechStack - Shows tech stack of GitHub repositories
    tech-stack = buildFirefoxXpiAddon {
      pname = "tech-stack";
      version = "1.25";
      addonId = "a778917369@gmail.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4196975/get_tech_stack-1.25.xpi";
      sha256 = "sha256-zU3rzp1oPpZEQ+TAKJeFWnVIPtMmgZrzAghKcKN3M2s=";
      meta = with final.lib; {
        homepage = "https://github.com/Get-Tech-Stack/TechStack";
        description = "Show the tech stack of the GitHub repository you are visiting";
        license = licenses.unfree;
        platforms = platforms.all;
      };
    };

    # GitHub Lines of Code - Shows lines of code for GitHub repositories
    github-lines-of-code = buildFirefoxXpiAddon {
      pname = "github-lines-of-code";
      version = "1.0.3";
      addonId = "{dd48306e-823f-4c70-902a-c7612f8c14fc}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4210054/github_lines_of_code-1.0.3.xpi";
      sha256 = "sha256-oApXOEjYYr/0vgA5k93ZLzYJ4exkopZlC5AVJzif/m4=";
      meta = with final.lib; {
        homepage = "https://github.com/pajecawav/github-lines-of-code";
        description = "Count lines of code in a GitHub project";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };

    # Conventional Comments - Enhances code reviews with standardized comment formatting
    conventional-comments = buildFirefoxXpiAddon {
      pname = "conventional-comments";
      version = "0.2.1";
      addonId = "conventional-comments-addon@pullpo.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/4489240/conventional_comments_pullpo-0.2.1.xpi";
      sha256 = "sha256-hUEXKahmHRFAZEkUVwjTZnsFQHao22Q45pGUA0knW8M=";
      meta = with final.lib; {
        homepage = "https://github.com/pullpo-io/conventional-comments";
        description = "Help format code review comments on GitHub using the Conventional Comments standard";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
  };
}
