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

Most of nixvim is dedicated to wrapping neovim plugin such that we can configure them in Nix.
To add a new plugin you need to do the following.

1.  Add a file in the correct sub-directory of [plugins](plugins). This depends on your exact plugin.
    You will most certainly need the `helpers`, they can be added by doing something like:

    ```nix
    {
      lib,
      pkgs,
      ...
    } @ args:

    let
      helpers = import ../helpers.nix args;
    in {
    }
    ```

2.  Create the minimal options for a new plugin (in `options.plugins.<plug-name>`:

    - `enable = mkEnableOption ...` to toggle the plugin.
    - `package = helpers.mkPackageOption ...` to change the package options.

3.  Add the plugin package to the installed plugins if it is enabled. This can be done with the following:

    ```nix
    {
      config =
        let
          cfg = config.plugins."<plug-name>";

        in lib.mkIf cfg.enable {
          extraPlugins = [cfg.package];

          extraConfigLua = ''
            <plugin configuration if needed>
          '';
        };
    }
    ```

You will then need to add Nix options for all (or most) of the upstream plugin options.
These options should be in `camelCase` (whereas most plugins define their options in `snake_case`), and their names should match exactly (except the case) to the upstream names.
There are a number of helpers to help you correctly implement them:

- `helpers.vim-plugin.mkPlugin`: This helper is useful for simple plugins that are configured through (vim) global variables.
- `helpers.defaultNullOpts.{mkBool,mkInt,mkStr,...}`: This family of helpers takes a default value and a description, and sets the Nix default to `null`. These are the main functions you should use to define options.
- `helpers.defaultNullOpts.mkNullable`: This takes a type, a default and a description. This is useful for more complex options.
- `helpers.nixvimTypes.rawLua`: A type to represent raw lua code. The values are of the form `{ __raw = "<code>";}`. This should not be used if the option can only be raw lua code, `mkLua`/`mkLuaFn` should be used in this case.

You will then need to map the Nix options to lua code. This can be done through `helpers.toLuaObject`. This function takes a Nix expression, and converts it to a lua string.

Because the options may not have the same case (and may require some pre-processing before passing it to `toLuaObject`) most options define a `setupOptions` object of the form:

```nix
{
  some_opt = cfg.someOpt;
  some_raw_opt = helpers.mkRaw cfg.someRawOpt;
  some_meta_opt = with cfg.metaOpt; # metaOpt = { foo = ...; someOtherOpt = ...; };
    {
      inherit foo;
      some_other_opt = someOtherOpt;
    };
}
```

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
