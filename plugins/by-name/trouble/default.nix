{
  config,
  lib,
  helpers,
  options,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "trouble";
  originalName = "trouble-nvim";
  package = "trouble-nvim";

  maintainers = [ maintainers.loicreynier ];

  # TODO introduced 2024-03-15: remove 2024-05-15
  optionsRenamedToSettings = [
    "autoClose"
    "autoFold"
    "autoOpen"
    "autoJump"
    "autoPreview"
    "foldClosed"
    "foldOpen"
    "group"
    "height"
    "icons"
    "indentLines"
    "mode"
    "padding"
    "position"
    "width"
    "useDiagnosticSigns"

    [
      "actionKeys"
      "cancel"
    ]
    [
      "actionKeys"
      "close"
    ]
    [
      "actionKeys"
      "closeFolds"
    ]
    [
      "actionKeys"
      "hover"
    ]
    [
      "actionKeys"
      "jump"
    ]
    [
      "actionKeys"
      "jumpClose"
    ]
    [
      "actionKeys"
      "next"
    ]
    [
      "actionKeys"
      "openFolds"
    ]
    [
      "actionKeys"
      "openSplit"
    ]
    [
      "actionKeys"
      "openTab"
    ]
    [
      "actionKeys"
      "openVsplit"
    ]
    [
      "actionKeys"
      "previous"
    ]
    [
      "actionKeys"
      "refresh"
    ]
    [
      "actionKeys"
      "toggleFold"
    ]
    [
      "actionKeys"
      "toggleMode"
    ]
    [
      "actionKeys"
      "togglePreview"
    ]
    [
      "signs"
      "error"
    ]
    [
      "signs"
      "hint"
    ]
    [
      "signs"
      "other"
    ]
    [
      "signs"
      "warning"
    ]
  ];

  settingsOptions = {
    position =
      helpers.defaultNullOpts.mkEnum
        [
          "top"
          "left"
          "right"
          "bottom"
        ]
        "bottom"
        ''
          Position of the list.
        '';

    height = helpers.defaultNullOpts.mkInt 10 ''
      Height of the trouble list when position is top or bottom.
    '';

    width = helpers.defaultNullOpts.mkInt 50 ''
      Width of the list when position is left or right.
    '';

    icons = helpers.defaultNullOpts.mkBool true "Use devicons for filenames";

    mode = helpers.defaultNullOpts.mkEnum [
      "workspace_diagnostics"
      "document_diagnostics"
      "quickfix"
      "lsp_references"
      "loclist"
    ] "workspace_diagnostics" "Mode for default list";

    fold_open = helpers.defaultNullOpts.mkStr "" "Icon used for open folds";

    fold_closed = helpers.defaultNullOpts.mkStr "" "Icon used for closed folds";

    group = helpers.defaultNullOpts.mkBool true "Group results by file";

    padding = helpers.defaultNullOpts.mkBool true "Add an extra new line on top of the list";

    cycle_results = helpers.defaultNullOpts.mkBool true "Whether to cycle item list when reaching beginning or end of list";

    action_keys =
      mapAttrs
        (
          action: config:
          helpers.defaultNullOpts.mkNullable (
            with types; either str (listOf str)
          ) config.default config.description
        )
        {
          close = {
            default = "q";
            description = "Close the list";
          };
          cancel = {
            default = "<esc>";
            description = "Cancel the preview and get back to your last window / buffer / cursor";
          };
          refresh = {
            default = "r";
            description = "Manually refresh";
          };
          jump = {
            default = [
              "<cr>"
              "<tab>"
            ];
            description = "Jump to the diagnostic or open / close folds";
          };
          open_split = {
            default = [ "<c-x>" ];
            description = "Open buffer in new split";
          };
          open_vsplit = {
            default = [ "<c-v>" ];
            description = "Open buffer in new vsplit";
          };
          open_tab = {
            default = [ "<c-t>" ];
            description = "Open buffer in new tab";
          };
          jump_close = {
            default = [ "o" ];
            description = "Jump to the diagnostic and close the list";
          };
          toggle_mode = {
            default = "m";
            description = "toggle between 'workspace' and 'document' diagnostics mode";
          };
          toggle_preview = {
            default = "P";
            description = "Toggle auto_preview";
          };
          hover = {
            default = "K";
            description = "Opens a small popup with the full multiline message";
          };
          preview = {
            default = "p";
            description = "Preview the diagnostic location";
          };
          close_folds = {
            default = [
              "zM"
              "zm"
            ];
            description = "Close all folds";
          };
          open_folds = {
            default = [
              "zR"
              "zr"
            ];
            description = "Open all folds";
          };
          toggle_fold = {
            default = [
              "zA"
              "za"
            ];
            description = "Toggle fold of current file";
          };
          previous = {
            default = "k";
            description = "Previous item";
          };
          next = {
            default = "j";
            description = "Next item";
          };
        };

    indent_lines = helpers.defaultNullOpts.mkBool true ''
      Add an indent guide below the fold icons.
    '';

    win_config = helpers.defaultNullOpts.mkAttrsOf types.anything {
      border = "single";
    } "Configuration for floating windows. See `|nvim_open_win()|`.";

    auto_open = helpers.defaultNullOpts.mkBool false ''
      Automatically open the list when you have diagnostics.
    '';

    auto_close = helpers.defaultNullOpts.mkBool false ''
      Automatically close the list when you have no diagnostics.
    '';

    auto_preview = helpers.defaultNullOpts.mkBool true ''
      Automatically preview the location of the diagnostic.
      <esc> to close preview and go back to last window.
    '';

    auto_fold = helpers.defaultNullOpts.mkBool false ''
      Automatically fold a file trouble list at creation.
    '';

    auto_jump = helpers.defaultNullOpts.mkListOf types.str [ "lsp_definitions" ] ''
      For the given modes, automatically jump if there is only a single result.
    '';

    include_declaration = helpers.defaultNullOpts.mkListOf types.str [
      "lsp_references"
      "lsp_implementations"
      "lsp_definitions"
    ] "For the given modes, include the declaration of the current symbol in the results.";

    signs =
      mapAttrs
        (
          diagnostic: default:
          helpers.defaultNullOpts.mkStr default "Icon/text for ${diagnostic} diagnostics."
        )
        {
          error = "";
          warning = "";
          hint = "";
          information = "";
          other = "﫠";
        };

    use_diagnostic_signs = helpers.defaultNullOpts.mkBool false ''
      Enabling this will use the signs defined in your lsp client
    '';
  };

  extraConfig = cfg: {
    # TODO: added 2024-09-20 remove after 24.11
    plugins.web-devicons = mkIf (
      !(
        config.plugins.mini.enable
        && config.plugins.mini.modules ? icons
        && config.plugins.mini.mockDevIcons
      )
    ) { enable = mkOverride 1490 true; };
  };
}
