{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.rust-tools = let
    mkNullableOptionWithDefault = {
      type,
      description,
      default,
    }:
      mkOption {
        type = types.nullOr type;
        default = null;
        description = ''
          ${description}

          default: `${default}`
        '';
      };

    mkNullableBoolDefault = default: description:
      mkNullableOptionWithDefault {
        inherit description;
        type = types.bool;
        default = toString default;
      };

    mkNullableStrDefault = default: description:
      mkNullableOptionWithDefault {
        inherit description;
        type = types.str;
        default = ''"${default}"'';
      };

    mkNullableIntDefault = default: description:
      mkNullableOptionWithDefault {
        inherit description;
        type = types.int;
        default = toString default;
      };
  in {
    enable = mkEnableOption "rust tools plugins";
    package = helpers.mkPackageOption "rust-tools" pkgs.vimPlugins.rust-tools-nvim;
    serverPackage = mkOption {
      type = types.package;
      default = pkgs.rust-analyzer;
      description = "Package to use for rust-analyzer";
    };

    executor = mkNullableOptionWithDefault {
      type = types.enum ["termopen" "quickfix"];
      default = ''"termopen"'';
      description = "how to execute terminal commands";
    };

    onIntialized = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Callback to execute once rust-analyzer is done initializing the workspace
        The callback receives one parameter indicating the `health` of the server:
        "ok" | "warning" | "error"
      '';
    };

    reloadWorkspaceFromCargoToml = mkNullableBoolDefault true ''
      Automatically call RustReloadWorkspace when writing to a Cargo.toml file.
    '';

    inlayHints = {
      auto = mkNullableBoolDefault true "automatically set inlay hints (type hints)";

      onlyCurrentLine = mkNullableBoolDefault false "Only show for current line";

      showParameterHints =
        mkNullableBoolDefault true
        "whether to show parameter hints with the inlay hints or not";

      parameterHintsPrefix = mkNullableStrDefault "<- " "prefix for parameter hints";
      otherHintsPrefix = mkNullableStrDefault "=> " "prefix for all the other hints (type, chaining)";

      maxLenAlign =
        mkNullableBoolDefault false
        "whether to align to the length of the longest line in the file";

      maxLenAlignPadding = mkNullableIntDefault 1 "padding from the left if max_len_align is true";

      rightAlign = mkNullableBoolDefault false "whether to align to the extreme right or not";
      rightAlignPadding = mkNullableIntDefault 7 "padding from the right if right_align is true";

      highlight = mkNullableStrDefault "Comment" "The color of the hints";
    };

    hoverActions = {
      border = mkOption {
        type = types.nullOr types.anything;
        default = null;
        description = ''
          the border that is used for the hover window. see vim.api.nvim_open_win()
        '';
      };

      maxWidth = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Maximal width of the hover window. Nil means no max.";
      };
      maxHeight = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Maximal height of the hover window. Nil means no max.";
      };

      autoFocus = mkNullableBoolDefault false "whether the hover action window gets automatically focused";
    };

    crateGraph = {
      backend = mkNullableStrDefault "x11" ''
        Backend used for displaying the graph
        see: https://graphviz.org/docs/outputs/
      '';

      output = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "where to store the output, nil for no output stored";
      };

      full = mkNullableBoolDefault true ''
        true for all crates.io and external crates, false only the local crates
      '';

      enabledGraphvizBackends = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = ''
          List of backends found on: https://graphviz.org/docs/outputs/
          Is used for input validation and autocompletion
        '';
      };
    };

    server =
      {
        standalone = mkNullableBoolDefault true ''
          standalone file support
          setting it to false may improve startup time
        '';
      }
      // (import ../nvim-lsp/language-servers/rust-analyzer-config.nix lib);
  };
  config = let
    cfg = config.plugins.rust-tools;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [nvim-lspconfig cfg.package];
      extraPackages = [cfg.serverPackage];

      plugins.lsp.postConfig = let
        setupOptions = {
          tools = {
            executor =
              if cfg.executor != null
              then {__raw = ''require("rust-tools.executors").${cfg.executor}'';}
              else null;

            on_initialized =
              if cfg.onIntialized != null
              then {__raw = cfg.onIntialized;}
              else null;

            reload_workspace_from_cargo_toml = cfg.reloadWorkspaceFromCargoToml;
            inlay_hints = let
              cfgIH = cfg.inlayHints;
            in {
              auto = cfgIH.auto;
              only_current_line = cfgIH.onlyCurrentLine;
              show_parameter_hints = cfgIH.showParameterHints;
              parameter_hints_prefix = cfgIH.parameterHintsPrefix;
              other_hints_prefix = cfgIH.otherHintsPrefix;
              max_len_align = cfgIH.maxLenAlign;
              max_len_align_padding = cfgIH.maxLenAlignPadding;
              right_align = cfgIH.rightAlign;
              right_align_padding = cfgIH.rightAlignPadding;
              highlight = cfgIH.highlight;
            };

            hover_actions = let
              cfgHA = cfg.hoverActions;
            in {
              border = cfgHA.border;
              max_width = cfgHA.maxWidth;
              max_height = cfgHA.maxHeight;
              auto_focus = cfgHA.autoFocus;
            };

            crate_graph = let
              cfgCG = cfg.crateGraph;
            in {
              backend = cfgCG.backend;
              output = cfgCG.output;
              full = cfgCG.full;
              enabled_graphviz_backends = cfgCG.enabledGraphvizBackends;
            };
          };
          server = {
            standalone = cfg.server.standalone;
            settings.rust-analyzer = lib.filterAttrs (n: v: n != "standalone") cfg.server;
            on_attach = {__raw = "__lspOnAttach";};
          };
        };
      in ''
        require('rust-tools').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
