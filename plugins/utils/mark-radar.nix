{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.plugins.mark-radar;
  helpers = import ../helpers.nix {inherit lib;};
  optionWarnings = import ../../lib/option-warnings.nix args;
  basePluginPath = ["plugins" "mark-radar"];
in {
  # Those renames were done on 03-24-2023
  imports = [
    (optionWarnings.mkRenamedOption {
      option = basePluginPath ++ ["highlight_background"];
      newOption = basePluginPath ++ ["backgroundHighlight"];
    })
    (optionWarnings.mkRenamedOption {
      option = basePluginPath ++ ["background_highlight_group"];
      newOption = basePluginPath ++ ["backgroundHighlightGroup"];
    })
    (optionWarnings.mkRenamedOption {
      option = basePluginPath ++ ["highlight_group"];
      newOption = basePluginPath ++ ["highlightGroup"];
    })
    (optionWarnings.mkRenamedOption {
      option = basePluginPath ++ ["set_default_keybinds"];
      newOption = basePluginPath ++ ["setDefaultMappings"];
    })
  ];

  options.plugins.mark-radar =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "mark-radar";

      package = helpers.mkPackageOption "mark-radar" pkgs.vimPlugins.mark-radar-nvim;

      setDefaultMappings =
        helpers.defaultNullOpts.mkBool true
        "Whether to set default mappings.";

      highlightGroup =
        helpers.defaultNullOpts.mkStr "RadarMark"
        "The name of the highlight group to use.";

      backgroundHighlight =
        helpers.defaultNullOpts.mkBool true
        "Whether to highlight the background.";

      backgroundHighlightGroup =
        helpers.defaultNullOpts.mkStr "RadarBackground"
        "The name of the highlight group to use for the background.";
    };

  config = let
    setupOptions =
      {
        set_default_mappings = cfg.setDefaultMappings;
        highlight_group = cfg.highlightGroup;
        background_highlight = cfg.backgroundHighlight;
        background_highlight_group = cfg.backgroundHighlightGroup;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("mark-radar").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
