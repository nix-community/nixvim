{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.dap.extensions.dap-ui;

  mkSizeOption = helpers.mkNullOrOption (with types; either int (numbers.between 0.0 1.0));

  mkKeymapOptions =
    name:
    mapAttrs (
      key: default:
      helpers.defaultNullOpts.mkNullable (
        with types; either str (listOf str)
      ) default "Map `${key}` for ${name}"
    );

  elementOption = types.submodule {
    options = {
      id = helpers.mkNullOrOption types.str "Element ID.";

      size = mkSizeOption "Size of the element in lines/columns or as proportion of total editor size (0-1).";
    };
  };

  layoutOption = types.submodule {
    options = {
      elements = mkOption {
        default = [ ];
        description = "Elements to display in this layout.";
        type = with types; listOf (either str elementOption);
      };

      size = mkOption {
        default = 10;
        description = "Size of the layout in lines/columns.";
        type = types.int;
      };

      position = mkOption {
        default = "left";
        description = "Which side of editor to open layout on.";
        type = types.enum [
          "left"
          "right"
          "top"
          "bottom"
        ];
      };
    };
  };
in
{
  options.plugins.dap.extensions.dap-ui = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "dap-ui";

    package = lib.mkPackageOption pkgs "dap-ui" {
      default = [
        "vimPlugins"
        "nvim-dap-ui"
      ];
    };

    controls = {
      enabled = helpers.defaultNullOpts.mkBool true "Enable controls";

      element = helpers.defaultNullOpts.mkEnumFirstDefault [
        "repl"
        "scopes"
        "stacks"
        "watches"
        "breakpoints"
        "console"
      ] "Element to show the controls on.";

      icons = {
        disconnect = helpers.defaultNullOpts.mkStr "" "";
        pause = helpers.defaultNullOpts.mkStr "" "";
        play = helpers.defaultNullOpts.mkStr "" "";
        run_last = helpers.defaultNullOpts.mkStr "" "";
        step_into = helpers.defaultNullOpts.mkStr "" "";
        step_over = helpers.defaultNullOpts.mkStr "" "";
        step_out = helpers.defaultNullOpts.mkStr "" "";
        step_back = helpers.defaultNullOpts.mkStr "" "";
        terminate = helpers.defaultNullOpts.mkStr "" "";
      };
    };

    elementMappings = helpers.mkNullOrOption (types.attrsOf (
      types.submodule {
        options = mkKeymapOptions "element mapping overrides" {
          edit = "e";
          expand = [
            "<CR>"
            "<2-LeftMouse>"
          ];
          open = "o";
          remove = "d";
          repl = "r";
          toggle = "t";
        };
      }
    )) "Per-element overrides of global mappings.";

    expandLines = helpers.defaultNullOpts.mkBool true "Expand current line to hover window if larger than window size.";

    floating = {
      maxHeight = mkSizeOption "Maximum height of the floating window.";

      maxWidth = mkSizeOption "Maximum width of the floating window.";

      border = helpers.defaultNullOpts.mkBorder "single" "dap-ui floating window" "";

      mappings = helpers.mkNullOrOption (types.submodule {
        options = mkKeymapOptions "dap-ui floating" {
          close = [
            "<ESC>"
            "q"
          ];
        };
      }) "Keys to trigger actions in elements.";
    };

    forceBuffers = helpers.defaultNullOpts.mkBool true "Prevents other buffers being loaded into dap-ui windows.";

    icons = {
      collapsed = helpers.defaultNullOpts.mkStr "" "";
      current_frame = helpers.defaultNullOpts.mkStr "" "";
      expanded = helpers.defaultNullOpts.mkStr "" "";
    };

    layouts = helpers.defaultNullOpts.mkListOf layoutOption [
      {
        elements = [
          {
            id = "scopes";
            size = 0.25;
          }
          {
            id = "breakpoints";
            size = 0.25;
          }
          {
            id = "stacks";
            size = 0.25;
          }
          {
            id = "watches";
            size = 0.25;
          }
        ];
        position = "left";
        size = 40;
      }
      {
        elements = [
          {
            id = "repl";
            size = 0.5;
          }
          {
            id = "console";
            size = 0.5;
          }
        ];
        position = "bottom";
        size = 10;
      }
    ] "List of layouts for dap-ui.";

    mappings = helpers.mkNullOrOption (types.submodule {
      options = mkKeymapOptions "dap-ui" {
        edit = "e";
        expand = [
          "<CR>"
          "<2-LeftMouse>"
        ];
        open = "o";
        remove = "d";
        repl = "r";
        toggle = "t";
      };
    }) "Keys to trigger actions in elements.";

    render = {
      indent = helpers.defaultNullOpts.mkInt 1 "Default indentation size.";

      maxTypeLength = helpers.mkNullOrOption types.int "Maximum number of characters to allow a type name to fill before trimming.";

      maxValueLines = helpers.defaultNullOpts.mkInt 100 "Maximum number of lines to allow a value to fill before trimming.";
    };

    selectWindow = helpers.defaultNullOpts.mkLuaFn null ''
      A function which returns a window to be used for opening buffers such as a stack frame location.
    '';
  };

  config =
    let
      options =
        with cfg;
        {
          inherit
            controls
            icons
            layouts
            mappings
            ;

          element_mappings = elementMappings;

          floating = with floating; {
            inherit border mappings;
            max_height = maxHeight;
            max_width = maxWidth;
          };

          force_buffers = forceBuffers;

          render = with render; {
            inherit indent;
            max_type_length = maxTypeLength;
            max_value_lines = maxValueLines;
          };

          select_window = selectWindow;
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      plugins.dap = {
        enable = true;

        extensionConfigLua = ''
          require("dapui").setup(${helpers.toLuaObject options});
        '';
      };
    };
}
