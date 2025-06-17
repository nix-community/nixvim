{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ts-autotag";
  packPathName = "nvim-ts-autotag";
  moduleName = "nvim-ts-autotag";
  package = "nvim-ts-autotag";
  description = "Use treesitter to auto close and auto rename a html tag.";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-06-17: remove 2024-08-17
  deprecateExtraOptions = true;
  imports =
    map
      (
        optionName:
        mkRemovedOptionModule
          [
            "plugins"
            "ts-autotag"
            optionName
          ]
          ''
            The `ts-autotag` plugin is no longer configured using `nvim-treesitter.configs`.
            Please, refer to upstream documentation:
            https://github.com/windwp/nvim-ts-autotag#setup
          ''
      )
      [
        "filetypes"
        "skipTags"
      ];

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.ts-autotag" {
      when = !config.plugins.treesitter.enable;
      message = "This plugin needs treesitter to function as intended.";
    };
  };

  settingsOptions =
    let
      opts = {
        enable_close = helpers.defaultNullOpts.mkBool true ''
          Whether or not to auto close tags.
        '';

        enable_rename = helpers.defaultNullOpts.mkBool true ''
          Whether or not to auto rename paired tags.
        '';

        enable_close_on_slash = helpers.defaultNullOpts.mkBool true ''
          Whether or not to auto close tags when a `/` is inserted.
        '';
      };
    in
    {
      inherit opts;

      aliases = helpers.defaultNullOpts.mkAttrsOf types.str {
        "astro" = "html";
        "eruby" = "html";
        "vue" = "html";
        "htmldjango" = "html";
        "markdown" = "html";
        "php" = "html";
        "twig" = "html";
        "blade" = "html";
        "javascriptreact" = "typescriptreact";
        "javascript.jsx" = "typescriptreact";
        "typescript.tsx" = "typescriptreact";
        "javascript" = "typescriptreact";
        "typescript" = "typescriptreact";
        "rescript" = "typescriptreact";
        "handlebars" = "glimmer";
        "hbs" = "glimmer";
        "rust" = "rust";
      } "Filetype aliases.";

      per_filetype = helpers.defaultNullOpts.mkAttrsOf (types.submodule {
        freeformType = with types; attrsOf anything;
        options = opts;
      }) { } "Per filetype config overrides.";
    };

  settingsExample = {
    opts = {
      enable_close = true;
      enable_rename = true;
      enable_close_on_slash = false;
    };
    per_filetype = {
      html = {
        enable_close = false;
      };
    };
  };
}
