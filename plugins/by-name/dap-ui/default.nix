{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.nixvim) defaultNullOpts;

  mkSizeOption = lib.nixvim.mkNullOrOption (with types; either int (numbers.between 0.0 1.0));

  mkKeymapOptions =
    name:
    lib.mapAttrs (
      key: default:
      defaultNullOpts.mkNullable (with types; either str (listOf str)) default "Map `${key}` for ${name}"
    );

  elementOption = types.submodule {
    options = {
      id = lib.nixvim.mkNullOrOption types.str "Element ID.";

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
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-ui";
  moduleName = "dapui";
  packPathName = "nvim-dap-ui";
  package = "nvim-dap-ui";
  description = "A UI for nvim-dap.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    controls = {
      enabled = defaultNullOpts.mkBool true "Enable controls";

      element = defaultNullOpts.mkEnumFirstDefault [
        "repl"
        "scopes"
        "stacks"
        "watches"
        "breakpoints"
        "console"
      ] "Element to show the controls on.";

      icons = lib.mapAttrs (name: icon: defaultNullOpts.mkStr icon "The icon for ${name}.") {
        disconnect = "";
        pause = "";
        play = "";
        run_last = "";
        step_into = "";
        step_over = "";
        step_out = "";
        step_back = "";
        terminate = "";
      };
    };

    element_mappings = lib.nixvim.mkNullOrOption (types.attrsOf (
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

    expand_lines = defaultNullOpts.mkBool true "Expand current line to hover window if larger than window size.";

    floating = {
      max_height = mkSizeOption "Maximum height of the floating window.";

      max_width = mkSizeOption "Maximum width of the floating window.";

      border = defaultNullOpts.mkBorder "single" "dap-ui floating window" "";

      mappings = lib.nixvim.mkNullOrOption (types.submodule {
        options = mkKeymapOptions "dap-ui floating" {
          close = [
            "<ESC>"
            "q"
          ];
        };
      }) "Keys to trigger actions in elements.";
    };

    force_buffers = defaultNullOpts.mkBool true "Prevents other buffers being loaded into dap-ui windows.";

    icons = {
      collapsed = defaultNullOpts.mkStr "" "";
      current_frame = defaultNullOpts.mkStr "" "";
      expanded = defaultNullOpts.mkStr "" "";
    };

    layouts = defaultNullOpts.mkListOf layoutOption [
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

    mappings = lib.nixvim.mkNullOrOption (types.submodule {
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
      indent = defaultNullOpts.mkInt 1 "Default indentation size.";

      max_type_length = lib.nixvim.mkNullOrOption types.int "Maximum number of characters to allow a type name to fill before trimming.";

      max_value_lines = defaultNullOpts.mkInt 100 "Maximum number of lines to allow a value to fill before trimming.";
    };

    select_window = defaultNullOpts.mkLuaFn null ''
      A function which returns a window to be used for opening buffers such as a stack frame location.
    '';
  };

  # NOTE: Renames added in https://github.com/nix-community/nixvim/pull/2897 (2025-01-26)
  deprecateExtraOptions = true;
  imports = [ ./deprecations.nix ];
}
