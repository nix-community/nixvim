# Contributing (and hacking onto) nixvim

This document is mainly for contributors to nixvim, but it can also be useful for extending nixvim.

## Submitting a change

In order to submit a change you must be careful of several points:

- The code must be properly formatted. This can be done through `nix fmt`.
- The tests must pass. This can be done through `nix flake check --all-systems` (this also checks formatting).
- The change should try to avoid breaking existing configurations.
- If the change introduces a new feature it should add tests for it (see the architecture section for details).
- The commit title should be consistent with our style. This usually looks like "plugins/<name>: fixed some bug",
  you can browse the commit history of the files you're editing to see previous commit messages.

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

1. Add a file in the correct sub-directory of [`plugins`](plugins).

- Most plugins should be added to [`plugins/by-name/<name>`](plugins/by-name).
  Plugins in `by-name` are automatically imported 🚀
- Occasionally, you may wish to add a plugin to a directory outside of `by-name`, such as [`plugins/colorschemes`](plugins/colorschemes).
  If so, you will also need to add your plugin to [`plugins/default.nix`](plugins/default.nix) to ensure it gets imported.
  Note: the imports list is sorted and grouped. In vim, you can usually use `V` (visual-line mode) with the `:sort` command to achieve the desired result.

2. The vast majority of plugins fall into one of those two categories:

- _vim plugins_: They are configured through **global variables** (`g:plugin_foo_option` in vimscript and `vim.g.plugin_foo_option` in lua).\
  For those, you should use the `lib.nixvim.plugins.mkVimPlugin`.\
  -> See [this plugin](plugins/by-name/direnv/default.nix) for an example.
- _neovim plugins_: They are configured through a `setup` function (`require('plugin').setup({opts})`).\
  For those, you should use the `lib.nixvim.plugins.mkNeovimPlugin`.\
  -> See the [template](plugins/TEMPLATE.nix).

3. Add the necessary arguments when calling either [`mkNeovimPlugin`](#mkneovimplugin) or [`mkVimPlugin`](#mkvimplugin)

#### `mkNeovimPlugin`

The `mkNeovimPlugin` function provides a standardize way to create a `Neovim` plugin.
This is intended to be used with lua plugins that have a `setup` function,
although it is flexible enough to be used with similar variants of plugins.
A template plugin can be found in (plugins/TEMPLATE.nix)[https://github.com/nix-community/nixvim/blob/main/plugins/TEMPLATE.nix].

| Parameter                    | Description                                                                                                                                                                                                                                          | Required | Default Value                                                                                   |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ----------------------------------------------------------------------------------------------- |
| **name**                     | The name of the plugin.                                                                                                                                                                                                                              | Yes      | N/A                                                                                             |
| **url**                      | The URL of the plugin's repository.                                                                                                                                                                                                                  | Yes      | `package` parameter's `meta.homepage`                                                           |
| **callSetup**                | Indicating whether to call the setup function. Useful when `setup` function needs customizations.                                                                                                                                                    | No       | `true`                                                                                          |
| **colorscheme**              | The name of the colorscheme.                                                                                                                                                                                                                         | No       | `name` parameter                                                                                |
| **configLocation**           | The option location where the lua configuration should be installed. Nested option locations can be represented as a list. The location can also be wrapped using `lib.mkBefore`, `lib.mkAfter`, or `lib.mkOrder`.                                   | No       | `"extraConfigLuaPre"` if `isColorscheme` then `extraConfigLuaPre`, otherwise `"extraConfigLua"` |
| **deprecateExtraOptions**    | Indicating whether to deprecate the `extraOptions` attribute. Mainly used for old plugins.                                                                                                                                                           | No       | `false`                                                                                         |
| **description**              | A brief description of the plugin. Can also be used for non-normative documentation, warnings, tips and tricks.                                                                                                                                      | No       | `null`                                                                                          |
| **extraConfig**              | Additional configuration for the plugin. Either an attrset, a function accepting `cfg`, or a function accepting `cfg` and `opts`.                                                                                                                    | No       | `{}`                                                                                            |
| **extraOptions**             | Module options for the plugin, to be added _outside_ of the `settings` option. These should be Nixvim-specific options.                                                                                                                              | No       | `{}`                                                                                            |
| **extraPackages**            | Extra packages to include.                                                                                                                                                                                                                           | No       | `[]`                                                                                            |
| **extraPlugins**             | Extra plugins to include.                                                                                                                                                                                                                            | No       | `[]`                                                                                            |
| **hasLuaConfig**             | Indicating whether the plugin generates lua configuration code (and thus should have a `luaConfig` option).                                                                                                                                          | No       | `true`                                                                                          |
| **hasSettings**              | Indicating whether the plugin has settings. A `settings` option will be created if true.                                                                                                                                                             | No       | `true`                                                                                          |
| **imports**                  | Additional modules to import.                                                                                                                                                                                                                        | No       | `[]`                                                                                            |
| **isColorscheme**            | Indicating whether the plugin is a colorscheme.                                                                                                                                                                                                      | No       | `false`                                                                                         |
| **moduleName**               | The Lua name for the plugin.                                                                                                                                                                                                                         | No       | `name` parameter                                                                                |
| **maintainers**              | Maintainers for the plugin.                                                                                                                                                                                                                          | No       | `[]`                                                                                            |
| **optionsRenamedToSettings** | Options that have been renamed and move to the `settings` attribute.                                                                                                                                                                                 | No       | `[]`                                                                                            |
| **packPathName**             | The name of the plugin directory in [packpath](https://neovim.io/doc/user/options.html#'packpath'), usually the plugin's github repo name. E.g. `"foo-bar.nvim"`.                                                                                    | No       | `name` parameter                                                                                |
| **package**                  | The nixpkgs package attr for this plugin. Can be a string, a list of strings, a module option, or any derivation. For example, "foo-bar-nvim" for `pkgs.vimPlugins.foo-bar-nvim`, or `[ "hello" "world" ]` will be referenced as `pkgs.hello.world`. | No       | `name` parameter                                                                                |
| **settingsDescription**      | A description of the settings provided to the `setup` function.                                                                                                                                                                                      | No       | `"Options provided to the require('${moduleName}')${setup} function."`                          |
| **settingsExample**          | An example configuration for the plugin's settings. See [Writing option examples].                                                                                                                                                                   | No       | `null`                                                                                          |
| **settingsOptions**          | Options representing the plugin's settings. This is optional because `settings` is a "freeform" option. See [Declaring plugin options].                                                                                                              | No       | `{}`                                                                                            |
| **setup**                    | The setup function for the plugin.                                                                                                                                                                                                                   | No       | `".setup"`                                                                                      |

##### Functionality

The `mkNeovimPlugin` function generates a Nix module that:

1. Defines the plugin's metadata, including maintainers, description, and URL.
2. Sets up options for enabling the plugin, specifying the package, and configuring settings and Lua configuration.

##### Example Usage

```nix
mkNeovimPlugin {
  name = "example-plugin";
  maintainers = [ lib.maintainers.user ];
  url = "https://github.com/example/example-plugin";
  description = "An example Neovim plugin";
  settingsOptions = {
    option1 = lib.mkOption {
      type = lib.types.str;
      default = "default-value";
      description = "An example option";
    };
  };
}
```

This example defines a Neovim plugin named `example-plugin` with specified maintainers, URL, description, settings options, and additional configuration. `package` will be 'example-plugin'
thanks to package referring to the `name` attribute.

See the [template](plugins/TEMPLATE.nix) for a starting point.

Here's a simple plugin using `mkNeovimPlugin` for reference: [lsp_lines.nvim](plugins/by-name/lsp-lines/default.nix).

#### `mkVimPlugin`

The `mkVimPlugin` function provides a standardized way to create a `Vim` plugin.
This is intended to be used with traditional vim plugins, usually written in viml.
Such plugins are usually configured via vim globals, but often have no configurable options at all.

| Parameter                    | Description                                                                                                                                                                                                                                        | Required | Default Value                         |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------- |
| **name**                     | The name of the Vim plugin.                                                                                                                                                                                                                        | Yes      | N/A                                   |
| **url**                      | The URL of the plugin repository.                                                                                                                                                                                                                  | Yes      | `package` parameter's `meta.homepage` |
| **colorscheme**              | The name of the colorscheme.                                                                                                                                                                                                                       | No       | `name` parameter                      |
| **deprecateExtraConfig**     | Flag to deprecate extra configuration.                                                                                                                                                                                                             | No       | `false`                               |
| **description**              | A description of the plugin. Can also be used for non-normative documentation, warnings, tips and tricks.                                                                                                                                          | No       | `null`                                |
| **extraConfig**              | Extra configuration for the plugin. Either an attrset, a function accepting `cfg`, or a function accepting `cfg` and `opts`.                                                                                                                       | No       | `{}`                                  |
| **extraOptions**             | Extra options for the plugin.                                                                                                                                                                                                                      | No       | `{}`                                  |
| **extraPackages**            | Extra packages to include.                                                                                                                                                                                                                         | No       | `[]`                                  |
| **extraPlugins**             | Extra plugins to include.                                                                                                                                                                                                                          | No       | `[]`                                  |
| **globalPrefix**             | Global prefix for the settings.                                                                                                                                                                                                                    | No       | `""`                                  |
| **imports**                  | A list of imports for the plugin.                                                                                                                                                                                                                  | No       | `[]`                                  |
| **isColorscheme**            | Flag to indicate if the plugin is a colorscheme.                                                                                                                                                                                                   | No       | `false`                               |
| **maintainers**              | The maintainers of the plugin.                                                                                                                                                                                                                     | No       | `[]`                                  |
| **optionsRenamedToSettings** | List of options renamed to settings.                                                                                                                                                                                                               | No       | `[]`                                  |
| **packPathName**             | The name of the plugin directory in [packpath](https://neovim.io/doc/user/options.html#'packpath'), usually the plugin's github repo name. E.g. `"foo-bar.vim"`.                                                                                   | No       | `name` parameter                      |
| **package**                  | The nixpkgs package attr for this plugin. Can be a string, a list of strings, a module option, or any derivation. For example, "foo-bar-vim" for `pkgs.vimPlugins.foo-bar-vim`, or `[ "hello" "world" ]` will be referenced as `pkgs.hello.world`. | No       | `name` parameter                      |
| **settingsExample**          | Example settings for the plugin. See [Writing option examples].                                                                                                                                                                                    | No       | `null`                                |
| **settingsOptions**          | Options representing the plugin's settings. This is optional because `settings` is a "freeform" option. See [Declaring plugin options].                                                                                                            | No       | `{}`                                  |

##### Functionality

The `mkVimPlugin` function generates a Nix module that:

1. Defines the plugin's metadata, including maintainers, description, and URL.
2. Sets up options for enabling the plugin, specifying the package, and configuring settings and extra configuration.

##### Example Usage

```nix
mkVimPlugin {
  name = "example-plugin";
  url = "https://github.com/example/plugin";
  maintainers = [ lib.maintainers.user ];
  description = "An example Vim plugin.";
  globalPrefix = "example_";
}
```

Simple vim plugins already implemented:

- [earthly.vim](https://github.com/nix-community/nixvim/blob/6f210158b03b01a1fd44bf3968165e6da80635ce/plugins/by-name/earthly/default.nix)
- [vim-nix](https://github.com/nix-community/nixvim/blob/6f210158b03b01a1fd44bf3968165e6da80635ce/plugins/by-name/nix/default.nix)

All the plugins are located under the `plugins` folder. If you want which plugins are defined as vim plugins, follow these steps:

```bash
# Ensure you are in the nixvim directory
cd nixvim

# Either setup nix-direnv, or manually enter a devshell using:
nix develop

# List all created plugins with `mkVimPlugin`
list-plugins -k vim
```

#### Writing option examples

Module options have first-class support for "examples" that are included automatically in documentation.

For example this option will render something like:

> # foo
>
> Some string
>
> **Default**: `null` \
> **Example**: `"Hello, world!"`

```nix
foo = lib.mkOption {
  type = lib.types.nullOr lib.types.str;
  description = "Some string";
  default = null;
  example = "Hello, world!";
}
```

Because [`mkVimPlugin`] and [`mkNeovimPlugin`] abstract away creation of the `settings` option, they provide a `settingsExample` argument. It is highly recommended to use this to provide an example for the plugin's `settings`.

Although `lib.nixvim.defaultNullOpts` helper functions don't usually support defining an example, each function offers a "prime variant" (e.g. `defaultNullOpts.mkString` has `defaultNullOpts.mkString'`) which accept nearly any argument you could use with `lib.mkOption`.
See [Declaring plugin options].

Most of the time you will set `example` to a nix value and the module system will render it using `lib.generators.toPretty`.
However, sometimes the example you wish to show would benefit from a specific formatting, may include function application or use of nix operators, or may benefit from some non-code explanation.
In that scenario, you should use `lib.literalExpression` or `lib.literalMD`.

You can use `lib.literalExpression` to write an example that is manually rendered by you. E.g. if your example needs to include expressions like `lib.nixvim.mkRaw "foo"`, you could use:

```nix
example = lib.literalExpression ''
  {
    foo = lib.nixvim.mkRaw "foo";
  }
''
```

Another example where `literalExpression` is beneficial is when your example includes multi-line strings.
If you allow the module system to render your example itself using `lib.generators.toPretty`, then multi-line strings will be rendered as a "normal" string literal, with `\n` used to represent line-breaks.
Note that to include a `''` literal within a nix indented string, you should use `'''`. E.g:

```nix
example = lib.literalExpression ''
  {
    long-string = '''
      This string
      spans over
      several lines!
    ''';
  }
''
```

On very rare occasions, you may wish to include some non-code text within your example. This can be done by wrapping a markdown string with `lib.literalMD`.
E.g:

`````nix
example = lib.literalMD ''
  This will render as normal text.

  Markdown formatting is **supported**!

  ```nix
  This will render as nix code.
  ```
''
`````

See also: [Writing NixOS Modules: Option Declarations](https://nixos.org/manual/nixos/unstable/#sec-option-declarations) (NixOS Manual).

#### Declaring plugin options

> [!CAUTION]
> Declaring `settings`-options is **not required**, because the `settings` option is a freeform type.
>
> While `settings` options can be helpful for documentation and type-checking purposes, this is a double-edged sword because we have to ensure the options are correctly typed and documented to avoid unnecessary restrictions or confusion.
>
> We usually recommend **not** declaring `settings` options, however there are exceptions where the trade-off is worth it.

> [!TIP]
> Learn more about the [RFC 42](https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md) which motivated this new approach.

If you feel having nix options for some of the upstream plugin options adds value and is worth the maintenance cost, you can declare these in `settingsOptions`.

Take care to ensure option names exactly match the upstream plugin's option names (without `globalsPrefix`, if used).
You must also ensure that the option type is permissive enough to avoid unnecessarily restricting config definitions.
If unsure, you can forego declaring the option or use a permissive type such as `lib.types.anything`.

There are a number of helpers added into `lib` that can help you correctly implement them:

- `lib.nixvim.defaultNullOpts.{mkBool,mkInt,mkStr,...}`: This family of helpers takes a default value and a description, and sets the Nix default to `null`.
  These are the main functions you should use to define options.
- `lib.nixvim.defaultNullOpts.<name>'`: These "prime" variants of the above helpers do the same thing, but expect a "structured" attrs argument.
  This allows more flexibility in what arguments are passed through to the underlying `lib.mkOption` call.
- `lib.types.rawLua`: A type to represent raw lua code. The values are of the form `{ __raw = "<code>";}`.

The resulting `settings` attrs will be directly translated to `lua` and will be forwarded the plugin:

- Using globals (`vim.g.<globalPrefix><option-name>`) for plugins using `mkVimPlugin`
- Using the `require('<plugin>').setup(<options>)` function for the plugins using `mkNeovimPlugin`

In either case, you don't need to bother implementing this part. It is done automatically.

### Tests

Most of the tests of nixvim consist of creating a neovim derivation with the supplied nixvim configuration, and then try to execute neovim to check for any output. All output is considered to be an error.

The tests are located in the [tests/test-sources](tests/test-sources) directory, and should be added to a file in the same hierarchy than the repository. For example if a plugin is defined in `./plugins/ui/foo.nix` the test should be added in `./tests/test-sources/ui/foo.nix`.

Tests can either be a simple attribute set, or a function taking `{pkgs}` as an input. The keys of the set are configuration names, and the values are a nixvim configuration.

You can specify the special `test` attribute in the configuration that will not be interpreted by nixvim, but only the test runner. The following keys are available:

- `test.runNvim`: Set to `false` to avoid launching nvim with this configuration and simply build the configuration.

> [!TIP]
> A single test can be run with `nix develop --command tests --interactive`. This launches the testing suite in interactive mode, allowing you to easily search for and select specific tests to run.

> [!WARNING]
> Running the entire test suite locally is not necessary in most cases. Instead, you may find it more efficient to focus on specific tests relevant to your changes, as Continuous Integration (CI) will run the full test suite on any Pull Requests (PRs) you open. This ensures comprehensive coverage without requiring the full suite to be run locally every time.

The full test suite can still be run locally with `nix flake check --all-systems` if needed.

There are a second set of tests, unit tests for nixvim itself, defined in `tests/lib-tests.nix` that use the `pkgs.lib.runTests` framework.

If you want to speed up tests, we have set up a Cachix for nixvim.
This way, only tests whose dependencies have changed will be re-run, speeding things up
considerably. To use it, just install cachix and run `cachix use nix-community`.

[`mkVimPlugin`]: #mkvimplugin
[`mkNeovimPlugin`]: #mkneovimplugin
[Writing option examples]: #writing-option-examples
[Declaring plugin options]: #declaring-plugin-options
