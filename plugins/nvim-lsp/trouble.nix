{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.plugins.trouble;
  helpers = import ../helpers.nix {inherit lib;};
in
  with lib; {
    options.plugins.trouble =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "trouble.nvim";

        package = helpers.mkPackageOption "trouble-nvim" pkgs.vimPlugins.trouble-nvim;

        position = helpers.defaultNullOpts.mkEnum ["top" "left" "right" "bottom"] "bottom" ''
          Position of the list
        '';

        height = helpers.defaultNullOpts.mkInt 10 ''
          Height of the trouble list when position is top or bottom
        '';

        width = helpers.defaultNullOpts.mkInt 50 "Width of the list when position is left or right";

        icons = helpers.defaultNullOpts.mkBool true "Use devicons for filenames";

        mode =
          helpers.defaultNullOpts.mkEnum
          [
            "workspace_diagnostics"
            "document_diagnostics"
            "quickfix"
            "lsp_references"
            "loclist"
          ]
          "workspace_diagnostics"
          "Use devicons for filenames";

        foldOpen = helpers.defaultNullOpts.mkStr "" "Icon used for open folds";

        foldClosed = helpers.defaultNullOpts.mkStr "" "Icon used for closed folds";

        group = helpers.defaultNullOpts.mkBool true "Group results by file";

        padding = helpers.defaultNullOpts.mkBool true "Add an extra new line on top of the list";

        # key mappings for actions in the trouble list
        # map to {} to remove a mapping, for example:
        # close = {}
        actionKeys =
          mapAttrs
          (
            action: config:
              helpers.defaultNullOpts.mkNullable
              (with types; either str (listOf str))
              config.default
              config.description
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
              default = "[ \"<cr>\" \"<tab>\" ]";
              description = "Jump to the diagnostic or open / close folds";
            };
            openSplit = {
              default = "[ \"<c-x>\" ]";
              description = "Open buffer in new split";
            };
            openVsplit = {
              default = "[ \"<c-v>\" ]";
              description = "Open buffer in new vsplit";
            };
            openTab = {
              default = "[ \"<c-t>\" ]";
              description = "Open buffer in new tab";
            };
            jumpClose = {
              default = "[ \"o\" ]";
              description = "Jump to the diagnostic and close the list";
            };
            toggleMode = {
              default = "m";
              description = "toggle between 'workspace' and 'document' diagnostics mode";
            };
            togglePreview = {
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
            closeFolds = {
              default = "[ \"zM\" \"zm\" ]";
              description = "Close all folds";
            };
            openFolds = {
              default = "[ \"zR\" \"zr\" ]";
              description = "Open all folds";
            };
            toggleFold = {
              default = "[ \"zA\" \"za\" ]";
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

        indentLines = helpers.defaultNullOpts.mkBool true ''
          Add an indent guide below the fold icons.
        '';

        autoOpen = helpers.defaultNullOpts.mkBool false ''
          Automatically open the list when you have diagnostics.
        '';

        autoClose = helpers.defaultNullOpts.mkBool false ''
          Automatically close the list when you have no diagnostics.
        '';

        autoPreview = helpers.defaultNullOpts.mkBool true ''
          Automatically preview the location of the diagnostic.
          <esc> to close preview and go back to last window.
        '';

        autoFold = helpers.defaultNullOpts.mkBool false ''
          Automatically fold a file trouble list at creation.
        '';

        autoJump =
          helpers.defaultNullOpts.mkNullable
          (types.listOf types.str)
          "[ \"lsp_definitions\" ]"
          "For the given modes, automatically jump if there is only a single result.";

        # icons / text used for a diagnostic
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

        useDiagnosticSigns = helpers.defaultNullOpts.mkBool false ''
          Enabling this will use the signs defined in your lsp client
        '';
      };

    config = mkIf cfg.enable {
      extraConfigLua = let
        options =
          {
            inherit
              (cfg)
              position
              height
              width
              icons
              mode
              ;
            fold_open = cfg.foldOpen;
            fold_closed = cfg.foldClosed;
            inherit (cfg) group padding;
            action_keys = with cfg.actionKeys; {
              inherit close cancel refresh jump;
              open_split = openSplit;
              open_vsplit = openVsplit;
              open_tab = openTab;
              jump_close = jumpClose;
              toggle_mode = toggleMode;
              toggle_preview = togglePreview;
              inherit hover preview;
              close_folds = closeFolds;
              open_folds = openFolds;
              toggle_fold = toggleFold;
              inherit next;
            };
            indent_lines = cfg.indentLines;
            auto_open = cfg.autoOpen;
            auto_close = cfg.autoClose;
            auto_preview = cfg.autoPreview;
            auto_fold = cfg.autoFold;
            auto_jump = cfg.autoJump;
            inherit signs;
            use_diagnostic_signs = cfg.useDiagnosticSigns;
          }
          // cfg.extraOptions;
      in ''
        require('trouble').setup(${helpers.toLuaObject options})
      '';

      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        nvim-web-devicons
      ];
    };
  }
