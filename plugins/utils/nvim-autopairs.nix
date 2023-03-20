{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.nvim-autopairs;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.nvim-autopairs =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-autopairs";

      package = helpers.mkPackageOption "nvim-autopairs" pkgs.vimPlugins.nvim-autopairs;

      pairs = helpers.mkNullOrOption (types.attrsOf types.str) "Characters to pair up";

      disabledFiletypes =
        helpers.defaultNullOpts.mkNullable
        (types.listOf types.str)
        ''[ "TelescopePrompt" "spectre_panel" ]''
        "Disabled filetypes";

      disableInMacro = helpers.defaultNullOpts.mkBool false ''
        Disable when recording or executing a macro.
      '';

      disableInVisualblock = helpers.defaultNullOpts.mkBool false ''
        Disable when insert after visual block mode.
      '';

      disableInReplaceMode = helpers.defaultNullOpts.mkBool true "Disable in replace mode.";

      ignoredNextChar = helpers.defaultNullOpts.mkStr "[=[[%w%%%'%[%\"%.%`%$]]=]" ''
        Regexp to ignore if it matches the next character.
      '';

      enableMoveright = helpers.defaultNullOpts.mkBool true "Enable moveright.";

      enableAfterQuote = helpers.defaultNullOpts.mkBool true "Add bracket pairs after quote.";

      enableCheckBracketLine = helpers.defaultNullOpts.mkBool true "Check bracket in same line.";

      enableBracketInQuote = helpers.defaultNullOpts.mkBool true "Enable bracket in quote.";

      enableAbbr = helpers.defaultNullOpts.mkBool false "Trigger abbreviation.";

      breakUndo = helpers.defaultNullOpts.mkBool true "Switch for basic rule break undo sequence.";

      checkTs = helpers.defaultNullOpts.mkBool false "Use treesitter to check for a pair.";

      tsConfig = helpers.mkNullOrOption (types.nullOr types.attrs) ''
        Configuration for TreeSitter.

        Default:
        ```
        {
          lua = [ "string" "source" ];
          javascript = [ "string" "template_string" ];
        };
        ```
      '';

      mapCr = helpers.defaultNullOpts.mkBool true "Map the <CR> key to confirm the completion.";

      mapBs = helpers.defaultNullOpts.mkBool true "Map the <BS> key to delete the pair.";

      mapCH = helpers.defaultNullOpts.mkBool false "Map the <C-h> key to delete a pair.";

      mapCW = helpers.defaultNullOpts.mkBool false "Map the <C-w> key to delete a pair if possible.";
    };

  config = let
    options =
      {
        pairs_map = cfg.pairs;

        disable_filetype = cfg.disabledFiletypes;
        disable_in_macro = cfg.disableInMacro;
        disable_in_visualblock = cfg.disableInVisualblock;
        disable_in_replace_mode = cfg.disableInReplaceMode;
        ignored_next_char =
          helpers.ifNonNull' cfg.ignoredNextChar
          (helpers.mkRaw cfg.ignoredNextChar);
        enable_moveright = cfg.enableMoveright;
        enable_afterquote = cfg.enableAfterQuote;
        enable_check_bracket_line = cfg.enableCheckBracketLine;
        enable_bracket_in_quote = cfg.enableBracketInQuote;
        enable_abbr = cfg.enableAbbr;
        break_undo = cfg.breakUndo;
        check_ts = cfg.checkTs;
        map_cr = cfg.mapCr;
        map_bs = cfg.mapBs;
        map_c_h = cfg.mapCH;
        map_c_w = cfg.mapCW;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      plugins.treesitter.enable = mkIf (cfg.checkTs == true) true;

      extraConfigLua = ''
        require('nvim-autopairs').setup(${helpers.toLuaObject options})
      '';
    };
}
