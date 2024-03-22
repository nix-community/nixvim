# Contributing (and hacking onto) nixvim

This document is mainly for contributors to nixvim, but it can also be useful for extending nixvim.

## Submitting a change

In order to submit a change you must be careful of several points:

- The code must be properly formatted. This can be done through `nix fmt`.
- The tests must pass. This can be done through `nix flake check --all-systems` (this also checks formatting).
- The change should try to avoid breaking existing configurations.
- If the change introduces a new feature it should add tests for it (see the architecture section for details).

## Nixvim Architecture

Nixvim is mainly built around `pkgs.neovimUtils.makeNeovimConfig`.
This function takes a list of plugins (and a few other misc options), and generates a configuration for neovim.
This can then be passed to `pkgs.wrapNeovimUnstable` to generate a derivation that bundles the plugins, extra programs and the lua configuration.

All the options that nixvim expose end up in those three places. This is done in the `modules/output.nix` file.

The guiding principle of nixvim is to only add to the `init.lua` what the user added to the configuration. This means that we must trim out all the options that were not set.

This is done by making most of the options of the type `types.nullOr ....`, and not setting any option that is null.

### Plugin configurations

Most of nixvim is dedicated to wrapping neovim plugins such that we can configure them in Nix.
To add a new plugin you need to do the following.

1. Add a file in the correct sub-directory of [plugins](plugins). This depends on your exact plugin.

The vast majority of plugins fall into one of those two categories:
- _vim plugins_: They are configured through **global variables** (`g:plugin_foo_option` in vimscript and `vim.g.plugin_foo_option` in lua).\
  For those, you should use the `helpers.vim-plugin.mkVimPlugin`.\
  -> See [this plugin](plugins/utils/direnv.nix) for an example.
- _neovim plugins_: They are configured through a `setup` function (`require('plugin').setup({opts})`).\
  For those, you should use the `helpers.neovim-plugin.mkNeovimPlugin`.\
  -> See the [template](plugins/TEMPLATE.nix).

2. Add the necessary parameters for the `mkNeovimPlugin`/`mkVimPlugin`:
  - `name`: The name of the plugin. The resulting nixvim module will have `plugins.<name>` as a path.\
    For a plugin named `foo-bar.nvim`, set this to `foo-bar` (subject to exceptions).
  - `originalName`: The "real" name of the plugin (i.e. `foo-bar.nvim`). This is used mostly in documentation.
  - `defaultPackage`: The nixpkgs package for this plugin (e.g. `pkgs.vimPlugins.foo-bar-nvim`).
  - `maintainers`: Register yourself as a maintainer for this plugin:
    - `[lib.maintainers.JosephFourier]` if you are already registered as a [`nixpkgs` maintainer](https://github.com/NixOS/nixpkgs/blob/master/maintainers/maintainer-list.nix)
    - `[helpers.maintainers.GaspardMonge]` otherwise. (Also add yourself to [`maintainers.nix`](lib/maintainers.nix))
  - `settingsOptions`: All or some (only the most important ones) option declarations for this plugin settings.\
    See below for more information
  - `settingsExample`: An example of what could the `settings` attrs look like.

#### Declaring plugin options

You will then need to add Nix options for all (or some) of the upstream plugin options.
These option declarations should be in `settingsOptions` and their names should match exactly the upstream plugin.
There are a number of helpers to help you correctly implement them:

- `helpers.defaultNullOpts.{mkBool,mkInt,mkStr,...}`: This family of helpers takes a default value and a description, and sets the Nix default to `null`. These are the main functions you should use to define options.
- `helpers.defaultNullOpts.mkNullable`: This takes a type, a default and a description. This is useful for more complex options.
- `helpers.nixvimTypes.rawLua`: A type to represent raw lua code. The values are of the form `{ __raw = "<code>";}`. This should not be used if the option can only be raw lua code, `mkLua`/`mkLuaFn` should be used in this case.

The resulting `settings` attrs will be directly translated to `lua` and will be forwarded the plugin:
- Using globals (`vim.g.<globalPrefix><option-name>`) for plugins using `mkVimPlugin`
- Using the `require('<plugin>').setup()` function for the plugins using `mkNeovimPlugin`

In either case, you don't need to bother implementing this part. It is done automatically.

> [!NOTE]
> Learn more about the [RFC 42](https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md) which motivated this new approach.


### Tests

Most of the tests of nixvim consist of creating a neovim derivation with the supplied nixvim configuration, and then try to execute neovim to check for any output. All output is considered to be an error.

The tests are located in the [tests/test-sources](tests/test-sources) directory, and should be added to a file in the same hierarchy than the repository. For example if a plugin is defined in `./plugins/ui/foo.nix` the test should be added in `./tests/test-sources/ui/foo.nix`.

Tests can either be a simple attribute set, or a function taking `{pkgs}` as an input. The keys of the set are configuration names, and the values are a nixvim configuration.

You can specify the special `tests` attribute in the configuration that will not be interpreted by nixvim, but only the test runner. The following keys are available:

- `tests.dontRun`: avoid launching this test, simply build the configuration.

The tests are then runnable with `nix flake check --all-systems`.

There are a second set of tests, unit tests for nixvim itself, defined in `tests/lib-tests.nix` that use the `pkgs.lib.runTests` framework.

If you want to speed up tests, we have set up a Cachix for nixvim.
This way, only tests whose dependencies have changed will be re-run, speeding things up
considerably. To use it, just install cachix and run `cachix use nix-community`.
