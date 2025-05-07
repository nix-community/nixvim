{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.plugins.rust-tools;
in
{
  options.plugins.rust-tools = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = lib.mkEnableOption "rust tools plugins";
    package = lib.mkPackageOption pkgs "rust-tools" {
      default = [
        "vimPlugins"
        "rust-tools-nvim"
      ];
    };
    serverPackage = lib.mkPackageOption pkgs "rust-analyzer" {
      nullable = true;
    };

    executor = lib.nixvim.defaultNullOpts.mkEnumFirstDefault [
      "termopen"
      "quickfix"
    ] "how to execute terminal commands";

    onInitialized = lib.nixvim.defaultNullOpts.mkLuaFn null ''
      Callback to execute once rust-analyzer is done initializing the workspace
      The callback receives one parameter indicating the `health` of the server:
      "ok" | "warning" | "error"
    '';

    reloadWorkspaceFromCargoToml = lib.nixvim.defaultNullOpts.mkBool true ''
      Automatically call RustReloadWorkspace when writing to a Cargo.toml file.
    '';

    inlayHints = {
      auto = lib.nixvim.defaultNullOpts.mkBool true "automatically set inlay hints (type hints)";

      onlyCurrentLine = lib.nixvim.defaultNullOpts.mkBool false "Only show for current line";

      showParameterHints = lib.nixvim.defaultNullOpts.mkBool true "whether to show parameter hints with the inlay hints or not";

      parameterHintsPrefix = lib.nixvim.defaultNullOpts.mkStr "<- " "prefix for parameter hints";

      otherHintsPrefix = lib.nixvim.defaultNullOpts.mkStr "=> " "prefix for all the other hints (type, chaining)";

      maxLenAlign = lib.nixvim.defaultNullOpts.mkBool false "whether to align to the length of the longest line in the file";

      maxLenAlignPadding = lib.nixvim.defaultNullOpts.mkUnsignedInt 1 "padding from the left if max_len_align is true";

      rightAlign = lib.nixvim.defaultNullOpts.mkBool false "whether to align to the extreme right or not";

      rightAlignPadding = lib.nixvim.defaultNullOpts.mkInt 7 "padding from the right if right_align is true";

      highlight = lib.nixvim.defaultNullOpts.mkStr "Comment" "The color of the hints";
    };

    hoverActions = {
      border = lib.nixvim.defaultNullOpts.mkBorder [
        [
          "╭"
          "FloatBorder"
        ]
        [
          "─"
          "FloatBorder"
        ]
        [
          "╮"
          "FloatBorder"
        ]
        [
          "│"
          "FloatBorder"
        ]
        [
          "╯"
          "FloatBorder"
        ]
        [
          "─"
          "FloatBorder"
        ]
        [
          "╰"
          "FloatBorder"
        ]
        [
          "│"
          "FloatBorder"
        ]
      ] "rust-tools hover window" "";

      maxWidth = lib.nixvim.defaultNullOpts.mkUnsignedInt null "Maximal width of the hover window. null means no max.";

      maxHeight = lib.nixvim.defaultNullOpts.mkUnsignedInt null "Maximal height of the hover window. null means no max.";

      autoFocus = lib.nixvim.defaultNullOpts.mkBool false "whether the hover action window gets automatically focused";
    };

    crateGraph = {
      backend = lib.nixvim.defaultNullOpts.mkStr "x11" ''
        Backend used for displaying the graph
        see: https://graphviz.org/docs/outputs/
      '';

      output = lib.nixvim.defaultNullOpts.mkStr null "where to store the output, nil for no output stored";

      full = lib.nixvim.defaultNullOpts.mkBool true ''
        true for all crates.io and external crates, false only the local crates
      '';

      enabledGraphvizBackends =
        lib.nixvim.defaultNullOpts.mkNullable (lib.types.listOf lib.types.str) null
          ''
            List of backends found on: https://graphviz.org/docs/outputs/
            Is used for input validation and autocompletion
          '';
    };

    server = {
      standalone = lib.nixvim.defaultNullOpts.mkBool true ''
        standalone file support
        setting it to false may improve startup time
      '';
    } // import ../../lsp/language-servers/rust-analyzer-config.nix lib;
  };
  config = lib.mkIf cfg.enable {
    extraPlugins = [
      config.plugins.lsp.package
      cfg.package
    ];
    extraPackages = [ cfg.serverPackage ];

    plugins.lsp.postConfig =
      let
        options = {
          tools = {
            executor = lib.nixvim.ifNonNull' cfg.executor (
              lib.nixvim.mkRaw "require(${lib.rust-tools.executors}).${cfg.executor}"
            );

            on_initialized = cfg.onInitialized;

            reload_workspace_from_cargo_toml = cfg.reloadWorkspaceFromCargoToml;
            inlay_hints = with cfg.inlayHints; {
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

            hover_actions = with cfg.hoverActions; {
              inherit border;
              max_width = maxWidth;
              max_height = maxHeight;
              auto_focus = autoFocus;
            };

            crate_graph = with cfg.crateGraph; {
              inherit backend output full;
              enabled_graphviz_backends = enabledGraphvizBackends;
            };
          };
          server = {
            inherit (cfg.server) standalone;
            settings.rust-analyzer = lib.filterAttrs (n: v: n != "standalone") cfg.server;
          };
        } // cfg.extraOptions;
      in
      ''
        require('rust-tools').setup(${lib.nixvim.toLuaObject options})
      '';
  };
}
