# Frequently Asked Questions

## How do I use a plugin not implemented in nixvim

Using a plugin not supported by nixvim, but packaged in nixpkgs is straightforward:

- Register the plugin through `extraPlugins`: `extraPlugins = [pkgs.vimPlugins."<plugin name>"]`.
- Configure the plugin through `extraConfigLua`: `extraConfigLua = "require('my-plugin').setup({foo = "bar"})";`

## How do I use a plugin not packaged in nixpkgs

This is straightforward too, you can add the following to `extraPlugins` for a plugin hosted on GitHub:

```nix
extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
    name = "my-plugin";
    src = pkgs.fetchFromGitHub {
        owner = "<owner>";
        repo = "<repo>";
        rev = "<commit hash>";
        hash = "<nix NAR hash>";
    };
})];
```

The [nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#managing-plugins-with-vim-packages) has more information on this.

## How do I solve `<name>` missing

When using NixVim it is possible to encounter an error of the type `attribute 'name' missing`, for example it could look like:

```
       (stack trace truncated; use '--show-trace' to show the full trace)

       error: attribute 'haskell-scope-highlighting-nvim' missing

       at /nix/store/k897af00nzlz4ylxr5vakzpcvh6m3rnn-source/plugins/languages/haskell-scope-highlighting.nix:12:22:

           11|     originalName = "haskell-scope-highlighting.nvim";
           12|     defaultPackage = pkgs.vimPlugins.haskell-scope-highlighting-nvim;
             |                      ^
           13|
```

This usually means one of two things:
- The nixpkgs version is not in line with NixVim (for example nixpkgs nixos-24.05 is used with NixVim master)
- The nixpkgs unstable version used with NixVim is not recent enough.

## How do I create multiple aliases for a single keymap

You could use the builtin [`map`] function (or similar) to do something like this:

```nix
keymaps =
  (builtins.map (key: {
    inherit key;
    action = "<some-action>";
    options.desc = "My cool keymapping";
  }) ["<key-1>" "<key-2>" "<key-3>"])
  ++ [
    # Other keymaps...
  ];
```

This maps a list of keys into a list of similar [`keymaps`]. It is equivalent to:

```nix
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
```

[`map`]: https://nixos.org/manual/nix/stable/language/builtins#builtins-map
[`keymaps`]: ../keymaps

## How to use system provided binaries instead of nixvim provided ones

There are a number of plugins that install extra packages using `nix`, but this can cause issues.
For example enabling `plugins.treesitter` could add `gcc` to the PATH of neovim, and this could break workflows that rely on the system provided compiler.

Most plugins that install packages also provide a `xxxPackage` option that can be set to `null` to skip the installation of the package.
For example `plugin.treesitter` provides the `gccPackage` option.
