# Frequently Asked Questions

## How do I use a plugin not implemented in nixvim

Using a plugin not supported by nixvim, but packaged in nixpkgs is straightforward:

- Register the plugin through `extraPlugins`: `extraPlugins = [pkgs.vimPlugins."<plugin name>"]`.
- Configure the plugin through `extraConfigLua`: `extraConfigLua = "require('my-plugin').setup({foo = "bar"})";`

## How do I use a plugin not yet merged into Nixvim or temporarily modify one

Copy the module expression formatted like this into a file:

```nix
{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  # ...
}
```

Import it into your Nixvim configuration and configure it:

```nix
{
  # Remove this `programs.nixvim` wrapper for standalone configurations
  programs.nixvim = {
    # You could also substitute the filename with the module expression
    imports = [ ./my-plugin.nix ];

    plugins.my-plugin.enable = true;
  };
}
```

## How do I use a plugin not packaged in nixpkgs

This is straightforward too, you can add the following to `extraPlugins` for a plugin hosted on GitHub:

```nix
{
  extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
    name = "my-plugin";
    src = pkgs.fetchFromGitHub {
        owner = "<owner>";
        repo = "<repo>";
        rev = "<commit hash>";
        hash = "<nix NAR hash>";
    };
  })];
}
```

The [nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#managing-plugins-with-vim-packages) has more information on this.

## How do I solve `error: collision between .... and ....`

This sort of issue can occur when the `performance.combinePlugins.enable` option is set and two plugins
have a file with the same name. In order to fix this issue the `performance.combinePlugins.standalonePlugins`
option may be used to isolate one of the conflicting plugins.

## How do I solve "`<name>` cannot be found in `pkgs`"

When using Nixvim, it is possible to encounter errors about something not being found in `pkgs`. For example:

```
 … while evaluating the attribute 'optionalValue.value'

   at /nix/store/XXX-source/lib/modules.nix:868:5:
    867|
    868|     optionalValue =
       |     ^
    869|       if isDefined then { value = mergedValue; }

 … while evaluating a branch condition

   at /nix/store/XXX-source/lib/modules.nix:869:7:
    868|     optionalValue =
    869|       if isDefined then { value = mergedValue; }
       |       ^
    870|       else {};

 … while evaluating the option `plugins.<name>.package':

 (stack trace truncated; use '--show-trace' to show the full, detailed trace)

 error: <name> cannot be found in pkgs
```

This usually means one of few things:
- You are using `follows` on `inputs.nixvim` causing Nixvim to have an unexpected version of Nixpkgs.
- The nixpkgs version is not in line with Nixvim (for example nixpkgs nixos-25.11 is used with Nixvim master)
- The nixpkgs unstable version used with Nixvim is not recent enough.

When building Nixvim using flakes, we usually recommend _not_ declaring a `follows` for `inputs.nixvim`.
This is so that Nixvim is built against the same nixpkgs revision we're using in our test suite.

[standalone]: ../platforms/standalone.md

## How do I create multiple aliases for a single keymap

You could use the builtin [`map`] function (or similar) to do something like this:

```nix
{
  keymaps =
    (builtins.map (key: {
      inherit key;
      action = "<some-action>";
      options.desc = "My cool keymapping";
    }) ["<key-1>" "<key-2>" "<key-3>"])
    ++ [
      # Other keymaps...
    ];
}
```

This maps a list of keys into a list of similar [`keymaps`]. It is equivalent to:

```nix
{
  keymaps = [
    {
      key = "<key-1>";
      action = "<some-action>";
      options.desc = "My cool keymapping";
    }
    {
      key = "<key-2>";
      action = "<some-action>";
      options.desc = "My cool keymapping";
    }
    {
      key = "<key-3>";
      action = "<some-action>";
      options.desc = "My cool keymapping";
    }
    # Other keymaps...
  ];
}
```

[`map`]: https://nixos.org/manual/nix/stable/language/builtins#builtins-map
[`keymaps`]: ../keymaps

## How to use system provided binaries instead of Nixvim provided ones

There are a number of plugins that install extra packages using `nix`, but this can cause issues.
For example enabling `plugins.treesitter` could add `gcc` to the PATH of neovim, and this could break workflows that rely on the system provided compiler.

Most plugins that install packages also provide a `xxxPackage` option that can be set to `null` to skip the installation of the package.
For example `plugin.treesitter` provides the `gccPackage` option.
