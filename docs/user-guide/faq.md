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
