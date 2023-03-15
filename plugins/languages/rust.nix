{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.rust-tools;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.rust-tools =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "rust tools plugins";
      package = helpers.mkPackageOption "rust-tools" pkgs.vimPlugins.rust-tools-nvim;
      serverPackage = mkOption {
        type = types.package;
        default = pkgs.rust-analyzer;
        description = "Package to use for rust-analyzer";
      };

      executor =
        helpers.defaultNullOpts.mkEnumFirstDefault ["termopen" "quickfix"]
        "how to execute terminal commands";

      onInitialized =
        helpers.defaultNullOpts.mkStr "null"
        ''
          Callback to execute once rust-analyzer is done initializing the workspace
          The callback receives one parameter indicating the `health` of the server:
          "ok" | "warning" | "error"
        '';

      reloadWorkspaceFromCargoToml = helpers.defaultNullOpts.mkBool true ''
        Automatically call RustReloadWorkspace when writing to a Cargo.toml file.
      '';

      inlayHints = helpers.mkCompositeOption "inlay hints" {
        auto = helpers.defaultNullOpts.mkBool true "automatically set inlay hints (type hints)";

        onlyCurrentLine = helpers.defaultNullOpts.mkBool false "Only show for current line";

        showParameterHints =
          helpers.defaultNullOpts.mkBool true
          "whether to show parameter hints with the inlay hints or not";

        parameterHintsPrefix =
          helpers.defaultNullOpts.mkStr "<- "
          "prefix for parameter hints";

        otherHintsPrefix =
          helpers.defaultNullOpts.mkStr "=> "
          "prefix for all the other hints (type, chaining)";

        maxLenAlign =
          helpers.defaultNullOpts.mkBool false
          "whether to align to the length of the longest line in the file";

        maxLenAlignPadding =
          helpers.defaultNullOpts.mkInt 1
          "padding from the left if max_len_align is true";

        rightAlign =
          helpers.defaultNullOpts.mkBool false
          "whether to align to the extreme right or not";

        rightAlignPadding =
          helpers.defaultNullOpts.mkInt 7
          "padding from the right if right_align is true";

        highlight = helpers.defaultNullOpts.mkStr "Comment" "The color of the hints";
      };

      hoverActions = helpers.mkCompositeOption "hover actions" {
        border =
          helpers.defaultNullOpts.mkNullable (types.listOf (types.listOf types.str))
          ''
            [
              [ "╭" "FloatBorder" ]
              [ "─" "FloatBorder" ]
              [ "╮" "FloatBorder" ]
              [ "│" "FloatBorder" ]
              [ "╯" "FloatBorder" ]
              [ "─" "FloatBorder" ]
              [ "╰" "FloatBorder" ]
              [ "│" "FloatBorder" ]
            ]
          ''
          "the border that is used for the hover window. see vim.api.nvim_open_win()";

        maxWidth =
          helpers.defaultNullOpts.mkNullable types.int "null"
          "Maximal width of the hover window. null means no max.";

        maxHeight =
          helpers.defaultNullOpts.mkNullable types.int "null"
          "Maximal height of the hover window. null means no max.";

        autoFocus =
          helpers.defaultNullOpts.mkBool false
          "whether the hover action window gets automatically focused";
      };

      crateGraph = helpers.mkCompositeOption "create graph" {
        backend = helpers.defaultNullOpts.mkStr "x11" ''
          Backend used for displaying the graph
          see: https://graphviz.org/docs/outputs/
        '';

        output =
          helpers.defaultNullOpts.mkStr "null"
          "where to store the output, nil for no output stored";

        full = helpers.defaultNullOpts.mkBool true ''
          true for all crates.io and external crates, false only the local crates
        '';

        enabledGraphvizBackends =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) "null"
          ''
            List of backends found on: https://graphviz.org/docs/outputs/
            Is used for input validation and autocompletion
          '';
      };

      server =
        helpers.mkCompositeOption "server"
        {
          standalone = helpers.defaultNullOpts.mkBool true ''
            standalone file support
            setting it to false may improve startup time
          '';
        }
        // (import ../nvim-lsp/language-servers/rust-analyzer-config.nix lib);
    };
  config = mkIf cfg.enable {
    extraPlugins = with pkgs.vimPlugins; [nvim-lspconfig cfg.package];
    extraPackages = [cfg.serverPackage];

    plugins.lsp.postConfig = let
      options =
        {
          tools = {
            executor =
              helpers.ifNonNull' cfg.executor
              (helpers.mkRaw "require(${rust-tools.executors}).${cfg.executor}");

            on_initialized =
              helpers.ifNonNull' cfg.onInitialized
              (helpers.mkRaw cfg.onInitialized);

            reload_workspace_from_cargo_toml = cfg.reloadWorkspaceFromCargoToml;
            inlay_hints = with cfg.inlayHints;
              helpers.ifNonNull' cfg.inlayHints {
                inherit auto;
                only_current_line = onlyCurrentLine;
                show_parameter_hints = showParameterHints;
                parameter_hints_prefix = parameterHintsPrefix;
                other_hints_prefix = otherHintsPrefix;
                max_len_align = maxLenAlign;
                max_len_align_padding = maxLenAlignPadding;
                right_align = rightAlign;
                right_align_padding = rightAlignPadding;
                inherit highlight;
              };

            hover_actions = with cfg.hoverActions;
              helpers.ifNonNull' cfg.hoverActions
              {
                inherit border;
                max_width = maxWidth;
                max_height = maxHeight;
                auto_focus = autoFocus;
              };

            crate_graph = with cfg.crateGraph;
              helpers.ifNonNull' cfg.crateGraph {
                inherit backend output full;
                enabled_graphviz_backends = enabledGraphvizBackends;
              };
          };
          server = with cfg.server;
            helpers.ifNonNull' cfg.server {
              inherit standalone;
              settings.rust-analyzer = lib.filterAttrs (n: v: n != "standalone") cfg.server;
              on_attach = helpers.mkRaw "__lspOnAttach";
            };
        }
        // cfg.extraOptions;
    in ''
      require('rust-tools').setup(${helpers.toLuaObject options})
    '';
  };
}
