{
  lib,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ts-autotag";
  moduleName = "nvim-ts-autotag";
  package = "nvim-ts-autotag";
  description = "Use treesitter to auto close and auto rename a html tag.";

  maintainers = [ maintainers.GaetanLepage ];

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.ts-autotag" {
      when = !config.plugins.treesitter.enable;
      message = "This plugin needs treesitter to function as intended.";
    };
  };

  settingsOptions =
    let
      opts = {
        enable_close = lib.nixvim.defaultNullOpts.mkBool true ''
          Whether or not to auto close tags.
        '';

        enable_rename = lib.nixvim.defaultNullOpts.mkBool true ''
          Whether or not to auto rename paired tags.
        '';

        enable_close_on_slash = lib.nixvim.defaultNullOpts.mkBool true ''
          Whether or not to auto close tags when a `/` is inserted.
        '';
      };
    in
    {
      inherit opts;

      aliases = lib.nixvim.defaultNullOpts.mkAttrsOf types.str {
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

      per_filetype = lib.nixvim.defaultNullOpts.mkAttrsOf (types.submodule {
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
