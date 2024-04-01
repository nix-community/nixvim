# Installation

You must use a `nixpkgs` version compatible with the nixvim version you choose.

The `master` branch requires to use a _very recent_ version of nixpkgs unstable.
In order to guarantee the compatibility between nixvim & nixpkgs it is recommended to always update both at the same time.

When using a `stable` version you must use the corresponding nixvim branch, for example `nixos-23.11` when using NixOS 23.11.

Failure to use the correct branch, or an old revision of nixpkgs will likely result in errors of the form `vimPlugins.<name> attribute not found`.

NixVim can be used in four ways:
- As a NixOS module
- As a Home-Manager module
- As a nix-darwin module
- As a standalone derivation

NixVim is also available for nix flakes, or directly through an import.

## Accessing nixvim

For a direct import you can add nixvim to your configuration as follows:
```nix
let 
    nixvim = import (builtins.fetchGit {
        url = "https://github.com/nix-community/nixvim";
        # When using a different channel you can use `ref = "nixos-<version>"` to set it here
    });
in
```

When using flakes you can simply add `nixvim` to the inputs:
```nix
{
    inputs.nixvim = {
        url = "github:nix-community/nixvim";
        # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # outputs...
}

```

## Usage

NixVim can be used standalone or as a module for NixOS, home-manager, or nix-darwin.

When used standalone, a custom NixVim derivation is produced that can be used like any other package.

When used as a module, NixVim can be enabled though `programs.nixvim.enable`.


### Usage as a module (NixOS, home-manager, nix-darwin)

When using NixVim as a module you must import the NixVim module into your module system.
The three imports are:
- `<nixvim>.homeManagerModules.nixvim`
- `<nixvim>.nixosModules.nixvim`
- `<nixvim>.nixDarwinModules.nixvim`

`<nixvim>` refers to the way to access nixvim, depending on how you fetched nixvim as described in the previous section.

The imports can be added as a `imports = [ <nixvim_import> ]` in a configuration file.

You will then be able to enable nixvim through `programs.nixvim.enable = true`, and configure the
options as `programs.nixvim.<path>.<to>.<option> = <value>`.

When you use nixvim as a module, an additional module argument is passed on allowing you to peek through the configuration with `hmConfig`, `nixosConfig`, and `darwinConfig` for home-manager, NixOS, and nix-darwin respectively.
This is useful is you use nixvim both as part of an environment and as standalone.

If using the home-manager module, see [Home Manager Usage](../modules/hm.md) for more information.

### Standalone usage

When using nixvim as a standalone derivation you can use the following functions, located in `<nixvim>.legacyPackages.${system}`:
- `makeNixvim`: This function takes an attribute set of options values as arguments
- `makeNixvimWithModule`: This function takes an attribute set of the form: `{pkgs, extraSpecialArgs, module}`.
  The only required argument is `module`, being a NixOS module. This gives access to the `imports`, `options`, `config` variables, and using functions like `{config, ...}: { ... }`.

There are also some helper functions in `<nixvim>.lib.${system}` like:
- `check.mkTestDerivationFromNixvimModule`, taking the same arguments as `makeNixvimWithModule` and generates a check derivation.
- `check.mkTestDerivationFromNvim`, taking an attribute set of the form `{name = "<derivation name>"; nvim = <nvim derivation>}`. The `nvim` is the standalone derivation provided by NixVim.

The nixvim derivation can then be used like any other package!

For an example, see the [nixvim standalone flake template](https://github.com/nix-community/nixvim/blob/main/templates/simple/flake.nix).

For more information see [Standalone Usage](../modules/standalone.md).
