{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.plugins.treesitter-textobjects =
    let
      disable = helpers.defaultNullOpts.mkListOf types.str [ ] ''
        List of languages to disable this module for.
      '';

      mkKeymapsOption =
        desc:
        helpers.defaultNullOpts.mkAttrsOf (
          with types;
          either str (submodule {
            options = {
              query = mkOption {
                type = str;
                description = "";
                example = "@class.inner";
              };

              queryGroup = helpers.mkNullOrOption str ''
                You can also use captures from other query groups like `locals.scm`
              '';

              desc = helpers.mkNullOrOption str ''
                You can optionally set descriptions to the mappings (used in the `desc`
                parameter of `nvim_buf_set_keymap`) which plugins like _which-key_ display.
              '';
            };
          })
        ) { } desc;
    in
    lib.nixvim.plugins.neovim.extraOptionsOptions
    // {
      enable = mkEnableOption "treesitter-textobjects (requires plugins.treesitter.enable to be true)";

      package = lib.mkPackageOption pkgs "treesitter-textobjects" {
        default = [
          "vimPlugins"
          "nvim-treesitter-textobjects"
        ];
      };

      select = {
        enable = helpers.defaultNullOpts.mkBool false ''
          Text object selection:

          Define your own text objects mappings similar to `ip` (inner paragraph) and `ap`
          (a paragraph).
        '';

        inherit disable;

        lookahead = helpers.defaultNullOpts.mkBool false ''
          Whether or not to look ahead for the textobject.
        '';

        keymaps = mkKeymapsOption ''
          Map of keymaps to a tree-sitter query (`(function_definition) @function`) or capture
          group (`@function.inner`).
        '';

        selectionModes =
          helpers.defaultNullOpts.mkAttrsOf
            (
              with types;
              enum [
                "v"
                "V"
                "<c-v>"
              ]
            )
            { }
            ''
              Map of capture group to `v`(charwise), `V`(linewise), or `<c-v>`(blockwise), choose a
              selection mode per capture, default is `v`(charwise).
            '';

        includeSurroundingWhitespace = helpers.defaultNullOpts.mkStrLuaFnOr types.bool false ''
          `true` or `false`, when `true` textobjects are extended to include preceding or
          succeeding whitespace.

          Can also be a function which gets passed a table with the keys `query_string`
          (`@function.inner`) and `selection_mode` (`v`) and returns `true` of `false`.

          If you set this to `true` (default is `false`) then any textobject is extended to
          include preceding or succeeding whitespace.
          Succeeding whitespace has priority in order to act similarly to eg the built-in `ap`.
        '';
      };

      swap = {
        enable = helpers.defaultNullOpts.mkBool false ''
          Swap text objects:

          Define your own mappings to swap the node under the cursor with the next or previous one,
          like function parameters or arguments.
        '';

        inherit disable;

        swapNext = mkKeymapsOption ''
          Map of keymaps to a list of tree-sitter capture groups (`{@parameter.inner}`).
          Capture groups that come earlier in the list are preferred.
        '';

        swapPrevious = mkKeymapsOption ''
          Same as `swapNext`, but it will swap with the previous text object.
        '';
      };

      move = {
        enable = helpers.defaultNullOpts.mkBool false ''
          Go to next/previous text object~

          Define your own mappings to jump to the next or previous text object.
          This is similar to `|]m|`, `|[m|`, `|]M|`, `|[M|` Neovim's mappings to jump to the next or
          previous function.
        '';

        inherit disable;

        setJumps = helpers.defaultNullOpts.mkBool true "Whether to set jumps in the jumplist.";

        gotoNextStart = mkKeymapsOption ''
          Map of keymaps to a list of tree-sitter capture groups (`{@function.outer,
          @class.outer}`).
          The one that starts closest to the cursor will be chosen, preferring row-proximity to
          column-proximity.
        '';

        gotoNextEnd = mkKeymapsOption ''
          Same as `gotoNextStart`, but it jumps to the start of the text object.
        '';

        gotoPreviousStart = mkKeymapsOption ''
          Same as `gotoNextStart`, but it jumps to the previous text object.
        '';

        gotoPreviousEnd = mkKeymapsOption ''
          Same as `gotoNextEnd`, but it jumps to the previous text object.
        '';

        gotoNext = mkKeymapsOption ''
          Will go to either the start or the end, whichever is closer.
          Use if you want more granular movements.
          Make it even more gradual by adding multiple queries and regex.
        '';

        gotoPrevious = mkKeymapsOption ''
          Will go to either the start or the end, whichever is closer.
          Use if you want more granular movements.
          Make it even more gradual by adding multiple queries and regex.
        '';
      };

      lspInterop = {
        enable = helpers.defaultNullOpts.mkBool false "LSP interop.";

        border = helpers.defaultNullOpts.mkEnumFirstDefault [
          "none"
          "single"
          "double"
          "rounded"
          "solid"
          "shadow"
        ] "Define the style of the floating window border.";

        peekDefinitionCode = mkKeymapsOption ''
          Show textobject surrounding definition as determined using Neovim's built-in LSP in a
          floating window.
          Press the shortcut twice to enter the floating window
          (when https://github.com/neovim/neovim/pull/12720 or its successor is merged).
        '';

        floatingPreviewOpts = helpers.defaultNullOpts.mkAttrsOf types.anything { } ''
          Options to pass to `vim.lsp.util.open_floating_preview`.
          For example, `maximum_height`.
        '';
      };
    };

  config =
    let
      cfg = config.plugins.treesitter-textobjects;
    in
    mkIf cfg.enable {
      warnings = lib.nixvim.mkWarnings "plugins.treesitter-textobjects" {
        when = !config.plugins.treesitter.enable;
        message = "This plugin needs treesitter to function as intended.";
      };

      extraPlugins = [ cfg.package ];

      plugins.treesitter.settings.textobjects =
        with cfg;
        let
          processKeymapsOpt =
            keymapsOptionValue:
            helpers.ifNonNull' keymapsOptionValue (
              mapAttrs (
                key: mapping:
                if isString mapping then
                  mapping
                else
                  {
                    inherit (mapping) query;
                    query_group = mapping.queryGroup;
                    inherit (mapping) desc;
                  }
              ) keymapsOptionValue
            );
        in
        {
          select = with select; {
            inherit enable disable lookahead;
            keymaps = processKeymapsOpt keymaps;
            selection_modes = selectionModes;
            include_surrounding_whitespace = includeSurroundingWhitespace;
          };
          swap = with swap; {
            inherit enable disable;
            swap_next = processKeymapsOpt swapNext;
            swap_previous = processKeymapsOpt swapPrevious;
          };
          move = with move; {
            inherit enable disable;
            set_jumps = setJumps;
            goto_next_start = processKeymapsOpt gotoNextStart;
            goto_next_end = processKeymapsOpt gotoNextEnd;
            goto_previous_start = processKeymapsOpt gotoPreviousStart;
            goto_previous_end = processKeymapsOpt gotoPreviousEnd;
            goto_next = processKeymapsOpt gotoNext;
            goto_previous = processKeymapsOpt gotoPrevious;
          };
          lsp_interop = with lspInterop; {
            inherit enable border;
            peek_definition_code = processKeymapsOpt peekDefinitionCode;
            floating_preview_opts = floatingPreviewOpts;
          };
        }
        // cfg.extraOptions;
    };
}
