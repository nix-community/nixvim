{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  helpers = import ../../helpers.nix {inherit lib;};
in {
  options.plugins.ts-autotag =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-ts-autotag";

      package = helpers.mkPackageOption "ts-autotag" pkgs.vimPlugins.nvim-ts-autotag;

      filetypes =
        helpers.defaultNullOpts.mkNullable
        (with types; listOf str)
        ''
          [
            "html"
            "javascript"
            "typescript"
            "javascriptreact"
            "typescriptreact"
            "svelte"
            "vue"
            "tsx"
            "jsx"
            "rescript"
            "xml"
            "php"
            "markdown"
            "astro"
            "glimmer"
            "handlebars"
            "hbs"
          ]
        ''
        "Filetypes for which ts-autotag should be enabled.";

      skipTags =
        helpers.defaultNullOpts.mkNullable
        (with types; listOf str)
        ''
          [
            "area"
            "base"
            "br"
            "col"
            "command"
            "embed"
            "hr"
            "img"
            "slot"
            "input"
            "keygen"
            "link"
            "meta"
            "param"
            "source"
            "track"
            "wbr"
            "menuitem"
          ]
        ''
        "Which tags to skip.";
    };

  config = let
    cfg = config.plugins.ts-autotag;
  in
    mkIf cfg.enable {
      warnings = mkIf (!config.plugins.treesitter.enable) [
        "Nixvim: ts-autotag needs treesitter to function as intended"
      ];

      extraPlugins = [cfg.package];

      plugins.treesitter.moduleConfig.autotag =
        {
          enable = true;
          inherit (cfg) filetypes;
          skip_tags = cfg.skipTags;
        }
        // cfg.extraOptions;
    };
}
