# Adding Calibre Plugins

This guide explains how to add new Calibre plugins to the NixOS configuration.

## Overview

The Calibre plugin system uses official release ZIP files from GitHub to ensure compatibility and match the standard user installation experience. All plugins are automatically installed when the Calibre module is enabled.

## Plugin Architecture

### Current Plugins

The system currently includes these plugins:
- **WordDumb** - Generates Word Wise and X-Ray files for Kindle e-books
- **EpubSplit** - Splits EPUB files into separate volumes  
- **DeDRM** - Removes DRM from various ebook formats
- **Obok** - Removes DRM from Kobo ebooks
- **EpubMerge** - Merges multiple EPUB files into a single volume

### Plugin Types

**Standard Plugins**: Single ZIP file from GitHub releases
**Multi-Plugin Packages**: Like DeDRM_tools that contain multiple plugins

## Adding a New Standard Plugin

### Step 1: Find the Official Release

1. Go to the plugin's GitHub repository
2. Navigate to the Releases page
3. Find the latest release with a ZIP file
4. Copy the direct download URL

Example: `https://github.com/author/plugin/releases/download/v1.0.0/plugin.zip`

### Step 2: Add to Package Overlay

Edit `src/overlays/packages.nix` and add your plugin:

```nix
calibre-plugin-myplugin = mkCalibrePlugin {
  pname = "MyPlugin";
  version = "1.0.0";
  url = "https://github.com/author/plugin/releases/download/v1.0.0/plugin.zip";
  sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Use fake hash first

  meta = {
    description = "Description of what the plugin does";
    homepage = "https://github.com/author/plugin";
    license = final.lib.licenses.mit; # Choose appropriate license
  };
};
```

### Step 3: Get the Correct Hash

Build the plugin to get the real hash:

```bash
nix build .#nixosConfigurations.newton-desktop.pkgs.calibre-plugin-myplugin
```

Nix will fail and show the correct hash. Replace the fake hash with the real one.

### Step 4: Add to Installation List

Edit `src/modules/calibre.nix` and add your plugin to the installation list:

```nix
plugins=(
  "WordDumb:${pkgs.calibre-plugin-worddumb}:WordDumb.zip"
  "EpubSplit:${pkgs.calibre-plugin-epubsplit}:EpubSplit.zip"
  "DeDRM:${pkgs.calibre-plugin-dedrm}:DeDRM.zip"
  "Obok:${pkgs.calibre-plugin-dedrm}:Obok.zip"
  "EpubMerge:${pkgs.calibre-plugin-epubmerge}:EpubMerge.zip"
  "MyPlugin:${pkgs.calibre-plugin-myplugin}:MyPlugin.zip"  # Add this line
)
```

### Step 5: Test the Installation

```bash
# Build the system to verify everything works
nix build .#nixosConfigurations.newton-desktop.config.system.build.toplevel

# Run flake check to validate
nix run .#test

# Deploy if everything looks good
nix run .#deploy -- switch newton-desktop
```

## Adding Multi-Plugin Packages

Some plugins like DeDRM_tools contain multiple plugins in one release. For these:

### Custom Derivation Approach

Instead of using `mkCalibrePlugin`, create a custom derivation:

```nix
calibre-plugin-multipack = final.stdenv.mkDerivation {
  pname = "calibre-plugin-multipack";
  version = "1.0.0";
  
  src = final.fetchurl {
    url = "https://github.com/author/multipack/releases/download/v1.0.0/multipack.zip";
    sha256 = "sha256-...";
  };

  nativeBuildInputs = [ final.unzip ];
  
  dontUnpack = true;
  dontBuild = true;
  
  installPhase = ''
    runHook preInstall
    
    # Extract the downloaded ZIP
    unzip -q $src
    
    # Create output directory
    mkdir -p $out/share/calibre-plugins
    
    # Handle the specific structure of this multi-plugin package
    # This varies by package - check the contents first
    cp Plugin1.zip $out/share/calibre-plugins/Plugin1.zip
    cp Plugin2.zip $out/share/calibre-plugins/Plugin2.zip
    
    runHook postInstall
  '';

  meta = {
    description = "Multi-plugin package description";
    homepage = "https://github.com/author/multipack";
    license = final.lib.licenses.gpl3Plus;
  };
};
```

Then add each plugin separately to the installation list:

```nix
plugins=(
  # ... existing plugins ...
  "Plugin1:${pkgs.calibre-plugin-multipack}:Plugin1.zip"
  "Plugin2:${pkgs.calibre-plugin-multipack}:Plugin2.zip"
)
```

## Plugin Installation Details

### How It Works

1. **Package Build**: Nix downloads the official ZIP and stores it in `/nix/store`
2. **Home Manager Activation**: Script runs during system activation
3. **Plugin Installation**: Uses `calibre-customize -a` to install ZIP files
4. **Deduplication**: Checks if plugin is already installed before installing

### Installation Command

The system uses Calibre's official plugin installation command:
```bash
calibre-customize -a /path/to/plugin.zip
```

This matches exactly what users do when installing plugins manually.

### Verification

To verify plugins are installed correctly:

```bash
# List all installed plugins
calibre-customize --list-plugins

# Check specific plugin
calibre-customize --list-plugins | grep "PluginName"
```

## Troubleshooting

### Plugin Not Installing

1. **Check ZIP structure**: Plugin ZIP must contain `__init__.py` at the root level
2. **Verify URL**: Ensure the download URL points to the actual ZIP file
3. **Hash mismatch**: Re-run build to get the correct hash
4. **Plugin name**: Ensure the detection name matches what Calibre reports

### Build Failures

1. **Invalid URL**: Check that the release URL is accessible
2. **Missing dependencies**: Add required `nativeBuildInputs` for multi-plugin packages
3. **Permission issues**: Ensure the ZIP file downloads correctly

### Plugin Conflicts

1. **Duplicate names**: Ensure plugin names in the installation list are unique
2. **Version conflicts**: Some plugins may conflict with others

## Best Practices

### Plugin Selection

- **Use official releases**: Always prefer GitHub releases over Git commits
- **Check compatibility**: Ensure plugin works with the Calibre version in nixpkgs
- **Review code**: Only install plugins from trusted sources

### Maintenance

- **Regular updates**: Check for new plugin releases periodically
- **Test changes**: Always test plugin additions before deployment
- **Document changes**: Update this guide when adding new plugin types

### Naming Conventions

- **Package names**: Use `calibre-plugin-pluginname` format
- **Detection names**: Use the exact name that appears in `calibre-customize --list-plugins`
- **ZIP filenames**: Keep original names when possible for clarity

## Example: Complete Plugin Addition

Here's a complete example of adding the "PluginExample" plugin:

1. **Research**: Found PluginExample v2.1.0 at https://github.com/example/PluginExample/releases/download/v2.1.0/PluginExample.zip

2. **Add to overlay** (`src/overlays/packages.nix`):
```nix
calibre-plugin-pluginexample = mkCalibrePlugin {
  pname = "PluginExample";
  version = "2.1.0";
  url = "https://github.com/example/PluginExample/releases/download/v2.1.0/PluginExample.zip";
  sha256 = "sha256-abc123..."; # Real hash after building

  meta = {
    description = "Example plugin for demonstration";
    homepage = "https://github.com/example/PluginExample";
    license = final.lib.licenses.mit;
  };
};
```

3. **Add to installation** (`src/modules/calibre.nix`):
```nix
"PluginExample:${pkgs.calibre-plugin-pluginexample}:PluginExample.zip"
```

4. **Test and deploy**:
```bash
nix run .#test
nix run .#deploy -- switch newton-desktop
```

The plugin system is designed to be simple, reliable, and match the standard Calibre user experience while providing the benefits of declarative NixOS configuration management.