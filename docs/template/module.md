# Module Template

This document provides a template and guidelines for creating new modules in this NixOS configuration.

## Template

Here's the standard template for a new module:

```nix
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.<module-name> = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use <module-name>";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.<module-name>.enable {
      # Your configuration here
    })
  ];
}
```

## Example: Simple Package Installation

For a simple package installation module:

```nix
{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.example = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use example";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.example.enable {
      home-manager.users.nu = {...}: {
        home.packages = with pkgs; [
          example-package
        ];
      };
    })
  ];
}
```

## Guidelines

1. **Parameter Order**: Always use this exact parameter order:
   - `inputs`
   - `lib`
   - `config`
   - `pkgs`
   - `home-manager`
   - other parameters as needed

2. **Options Structure**:
   - Use `options.modules.<module-name>`
   - Always include an `enable` option
   - Add descriptive text for each option

3. **Configuration Structure**:
   - Wrap all configuration in `lib.mkMerge`
   - Use `lib.mkIf config.modules.<module-name>.enable` to conditionally apply
   - Place home-manager configuration under `home-manager.users.nu`

4. **Naming**:
   - Module file names should match the package/program name (kebab case)
   - Use kebab-case for multi-word module names (e.g., `tor-browser`)
   - Option names should be descriptive and follow camelCase

5. **Comments**:
   - Document any complex configuration or special cases