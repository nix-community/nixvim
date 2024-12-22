{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrStr';
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fastaction";
  packPathName = "fastaction.nvim";
  package = "fastaction-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    popup = {
      title = defaultNullOpts.mkStr "Select one of:" ''
        Title of the popup.
      '';

      relative = defaultNullOpts.mkStr "cursor" ''
        Specifies what the popup is relative to.
      '';

      border = defaultNullOpts.mkNullable (with types; either str (listOf str)) "rounded" ''
        Style of the popup border. Can be "single", "double", "rounded", "thick", or a table of
        strings in the format:
        ```nix
          [
            "top left"
            "top"
            "top right"
            "right"
            "bottom right"
            "bottom"
            "bottom left"
            "left"
          ]
        ```
      '';

      hide_cursor = defaultNullOpts.mkBool true ''
        Whether to hide the cursor when the popup is shown.
      '';

      highlight =
        defaultNullOpts.mkAttrsOf types.str
          {
            divider = "FloatBorder";
            key = "MoreMsg";
            title = "Title";
            window = "NormalFloat";
          }
          ''
            Configures the highlights of different aspects of the popup.
          '';

      x_offset = defaultNullOpts.mkInt 0 ''
        Configures the horizontal position of the popup with respect to the relative value.
      '';

      y_offset = defaultNullOpts.mkInt 0 ''
        Configures the vertical position of the popup with respect to the relative value.
      '';
    };

    priority = defaultNullOpts.mkAttrsOf' {
      type =
        with types;
        listOf (submodule {
          freeformType = attrsOf anything;
          options = {
            pattern = mkNullOrStr' {
              example = "organize import";
              description = ''
                Pattern for this code action.
              '';
            };

            key = mkNullOrStr' {
              example = "o";
              description = ''
                Keyboard shortcut for this code action.
              '';
            };

            order = defaultNullOpts.mkUnsignedInt' {
              example = 1;
              pluginDefault = 10;
              description = ''
                Priority for this code action.
              '';
            };
          };
        });
      description = ''
        Specifies the priority and keys to map to patterns matching code actions.
      '';
      pluginDefault = {
        default = [ ];
      };
      example = {
        dart = [
          {
            pattern = "organize import";
            key = "o";
            order = 1;
          }
          {
            pattern = "extract method";
            key = "x";
            order = 2;
          }
          {
            pattern = "extract widget";
            key = "e";
            order = 3;
          }
        ];
      };
    };

    register_ui_select = defaultNullOpts.mkBool false ''
      Determines if the select popup should be registered as a `vim.ui.select` handler.
    '';

    keys =
      defaultNullOpts.mkNullable (with types; either str (listOf str)) "qwertyuiopasdfghlzxcvbnm"
        ''
          Keys to use to map options.
        '';

    dismiss_keys =
      defaultNullOpts.mkListOf types.str
        [
          "j"
          "k"
          "<c-c>"
          "q"
        ]
        ''
          Keys to use to dismiss the popup.
        '';

    override_function = defaultNullOpts.mkRaw "function(_) end" ''
      Override function to map keys to actions.

      ```lua
        fun(params: GetActionConfigParams): ActionConfig | nil
      ```
    '';

    fallback_threshold = defaultNullOpts.mkUnsignedInt 26 ''
      Configures number of options after which fastaction must fallback on `vim.ui.select`.
    '';
  };

  settingsExample = {
    dismiss_keys = [
      "j"
      "k"
      "<c-c>"
      "q"
    ];
    keys = "qwertyuiopasdfghlzxcvbnm";
    popup = {
      border = "rounded";
      hide_cursor = true;
      highlight = {
        divider = "FloatBorder";
        key = "MoreMsg";
        title = "Title";
        window = "NormalFloat";
      };
      title = "Select one of:";
    };
    priority.dart = [
      {
        pattern = "organize import";
        key = "o";
        order = 1;
      }
      {
        pattern = "extract method";
        key = "x";
        order = 2;
      }
      {
        pattern = "extract widget";
        key = "e";
        order = 3;
      }
    ];
    register_ui_select = false;
  };
}
