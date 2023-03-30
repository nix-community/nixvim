{
  lib,
  pkgs,
  config,
  ...
} @ args:
with lib; let
  defaultFuzzyFinder = "skim";
  helpers = import ../helpers.nix args;
in {
  options.plugins.openscad = {
    enable = mkEnableOption "openscad.nvim, a plugin to manage OpenSCAD files";

    package = helpers.mkPackageOption "openscad.nvim" pkgs.vimPlugins.openscad-nvim;

    fuzzyFinder =
      helpers.defaultNullOpts.mkEnum ["skim" "fzf"] defaultFuzzyFinder
      "fuzzy finder to find documentation";

    cheatsheetWindowBlend = helpers.defaultNullOpts.mkNullable (types.ints.between 0 100) "15" "";

    loadSnippets = helpers.defaultNullOpts.mkBool false "";

    autoOpen = helpers.defaultNullOpts.mkBool false "";

    keymaps = {
      enable = mkEnableOption "keymaps for openscad";

      cheatsheetToggle = helpers.defaultNullOpts.mkStr "<Enter>" "Toggle cheatsheet window";

      helpTrigger = helpers.defaultNullOpts.mkStr "<A-h>" "Fuzzy find help resource";

      helpManualTrigger =
        helpers.defaultNullOpts.mkStr "<A-m>"
        "Open offline openscad manual in pdf via zathura";

      execOpenSCADTrigger = helpers.defaultNullOpts.mkStr "<A-o>" "Open file in OpenSCAD";

      topToggle =
        helpers.defaultNullOpts.mkStr "<A-c>"
        "toggle htop filtered for openscad processes";
    };
  };

  config = let
    cfg = config.plugins.openscad;
    fuzzyFinder =
      if isNull cfg.fuzzyFinder
      then defaultFuzzyFinder
      else cfg.fuzzyFinder;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins;
        [cfg.package]
        ++ (optional (fuzzyFinder == "skim") skim-vim)
        ++ (optional (fuzzyFinder == "fzf") fzf-vim);

      extraConfigLua = ''
        require('openscad')
      '';

      globals = mkMerge [
        {
          openscad_fuzzy_finder = cfg.fuzzyFinder;
          openscad_cheatsheet_window_blend = cfg.cheatsheetWindowBlend;
          openscad_load_snippets = cfg.loadSnippets;
        }
        (mkIf cfg.keymaps.enable {
          openscad_default_mappings = true;
          openscad_cheatsheet_toggle_key = cfg.keymaps.cheatsheetToggle;
          openscad_help_trig_key = cfg.keymaps.helpTrigger;
          openscad_help_manual_trig_key = cfg.keymaps.helpManualTrigger;
          openscad_exec_openscad_trig_key = cfg.keymaps.execOpenSCADTrigger;
          openscad_top_toggle = cfg.keymaps.topToggle;
        })
      ];
    };
}
