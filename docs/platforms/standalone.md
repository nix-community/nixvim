# Standalone Usage

Standalone usage refers to using Nixvim directly as a package,
rather than through the [NixOS], [Home Manager], or [nix-darwin] modules.

In this mode, Nixvim configurations are evaluated explicitly using [`evalNixvim`][evalNixvim].

[NixOS]: ./nixos.md
[Home Manager]: ./hm.md
[nix-darwin]: ./darwin.md
[evalNixvim]: ../lib/nixvim/modules/index.md#lib.nixvim.modules.evalNixvim

## Options

When used standalone, Nixvim's options are available directly, without any prefix/namespace.
This is unlike the other modules which typically use a `programs.nixvim.*` prefix.

There are **no** standalone-specific options available.

## Evaluating a configuration

When used standalone, Nixvim configurations are evaluated using `nixvim.lib.evalNixvim`.

```nix
configuration = nixvim.lib.evalNixvim {
  inherit system;
  modules = [ ./config ];
};
```

The result is a Nix module-system configuration.

```
modules
  ↓
evalNixvim
  ↓
configuration
```

Notable attributes include:
- `config`: The nested attribute set of all merged option values.
- `options`: The nested attribute set of all option declarations.
- `type`: A module system type.
  See [upstream docs][evalModules-type].
- `extendModules`: Extends the current configuration with additional modules.
  See [upstream docs][extendModules].

For more information, see Nixpkgs' [`evalModules` output][evalModules-output] docs. \
See the [lib.nixvim.modules] reference for complete API documentation.

## Building a package

Nixvim exposes build outputs through the evaluated configuration.
The wrapped Neovim package is available as `configuration.config.build.package`.

For example:

```nix
{
  packages.${system}.default = configuration.config.build.package;
}
```

## Building tests

A test derivation is available as `configuration.config.build.test`.
It can be used to smoke-test your Nixvim configuration.

For example, as a flake check:

```nix
{
  checks.${system}.default = configuration.config.build.test;
}
```

## Extending a configuration

Configurations can be extended using `extendModules`.

```nix
let
  base = nixvim.lib.evalNixvim {
    inherit system;

    modules = [
      {
        extraConfigLua = "-- first stage";
      }
    ];
  };

  extended = base.extendModules {
    modules = [
      {
        extraConfigLua = "-- second stage";
      }
    ];
  };
in
extended.config.build.package
```

See the upstream [`lib.evalModules` → `extendModules`][extendModules] documentation.

## Accessing configuration values

Evaluated option values are available through `config`.

For example:

```nix
configuration.config.colorschemes.gruvbox.enable
⇒ true
```

This can be useful when other parts of your NixOS, Home Manager, or nix-darwin configuration need access to values defined by Nixvim.

## Accessing options

Module options are available through `options`.

This can be useful when configuring `nixd`:

```nix
{
  plugins.lsp.servers.nixd = {
    enable = true;

    settings.options.nixvim.expr =
      ''(builtins.getFlake "/path/to/flake").packages.${system}.default.options'';
  };
}
```

Package outputs also expose `config` and `options` through passthru attributes.

## Using in another configuration

Here is an example of integrating a standalone configuration into a NixOS or Home Manager configuration.

The example assumes the standalone configuration is exported as the `default` package of a flake named `nixvim-config`.

```nix
{ inputs, system, ... }:
{
  # NixOS
  environment.systemPackages = [
    inputs.nixvim-config.packages.${system}.default
  ];

  # Home Manager
  home.packages = [
    inputs.nixvim-config.packages.${system}.default
  ];
}
```

[lib.nixvim.modules]: ../lib/nixvim/modules/index.md
[evalModules-output]: https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules
[evalModules-type]: https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules-return-value-type
[extendModules]: https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules-return-value-extendModules
