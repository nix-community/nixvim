{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.navbuddy;

  percentageType = types.ints.between 0 100;
  mkPercentageOpt = default: helpers.defaultNullOpts.mkNullable percentageType (toString default);
in
{
  options.plugins.navbuddy = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "nvim-navbuddy";

    package = lib.mkPackageOption pkgs "nvim-navbuddy" {
      default = [
        "vimPlugins"
        "nvim-navbuddy"
      ];
    };

    window = {
      border = helpers.defaultNullOpts.mkBorder "rounded" "window border" ''
        "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
        starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
      '';

      size = helpers.defaultNullOpts.mkNullable (
        with types;
        either percentageType (submodule {
          options = {
            height = mkPercentageOpt 40 "The height size (in %).";

            width = mkPercentageOpt 100 "The width size (in %).";
          };
        })
      ) 60 "The size of the window.";

      position = helpers.defaultNullOpts.mkNullable (
        with types;
        either percentageType (submodule {
          options = {
            height = mkPercentageOpt 40 "The height size (in %).";

            width = mkPercentageOpt 100 "The width size (in %).";
          };
        })
      ) 50 "The position of the window.";

      scrolloff = helpers.mkNullOrOption types.int ''
        scrolloff value within navbuddy window
      '';

      sections = {
        left = {
          size = mkPercentageOpt 20 "The height size (in %).";

          border = helpers.defaultNullOpts.mkBorder "rounded" "left section border" ''
            "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
            starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
          '';
        };

        mid = {
          size = mkPercentageOpt 40 "The height size (in %).";

          border = helpers.defaultNullOpts.mkBorder "rounded" "mid section border" ''
            "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
            starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
          '';
        };

        right = {
          border = helpers.defaultNullOpts.mkBorder "rounded" "right section border" ''
            "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
            starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
          '';

          preview =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "leaf"
                "always"
                "never"
              ]
              ''
                Right section can show previews too.
                      Options: "leaf", "always" or "never"
              '';
        };
      };
    };

    nodeMarkers = {
      enabled = helpers.defaultNullOpts.mkBool true "Enable node markers.";

      icons = {
        leaf = helpers.defaultNullOpts.mkStr "  " ''
          The icon to use for leaf nodes.
        '';

        leafSelected = helpers.defaultNullOpts.mkStr " → " ''
          The icon to use for selected leaf node.
        '';

        branch = helpers.defaultNullOpts.mkStr "  " ''
          The icon to use for branch nodes.
        '';
      };
    };

    icons = mapAttrs (name: default: helpers.defaultNullOpts.mkStr default "icon for ${name}.") {
      File = "󰈙 ";
      Module = " ";
      Namespace = "󰌗 ";
      Package = " ";
      Class = "󰌗 ";
      Method = "󰆧 ";
      Property = " ";
      Field = " ";
      Constructor = " ";
      Enum = "󰕘";
      Interface = "󰕘";
      Function = "󰊕 ";
      Variable = "󰆧 ";
      Constant = "󰏿 ";
      String = "󰀬 ";
      Number = "󰎠 ";
      Boolean = "◩ ";
      Array = "󰅪 ";
      Object = "󰅩 ";
      Key = "󰌋 ";
      Null = "󰟢 ";
      EnumMember = " ";
      Struct = "󰌗 ";
      Event = " ";
      Operator = "󰆕 ";
      TypeParameter = "󰊄 ";
    };

    useDefaultMapping = helpers.defaultNullOpts.mkBool true ''
      If set to false, only mappings set by user are set. Else default mappings are used for keys that are not set by user
    '';

    keymapsSilent = mkOption {
      type = types.bool;
      description = "Whether navbuddy keymaps should be silent";
      default = false;
    };

    mappings =
      helpers.defaultNullOpts.mkAttrsOf types.str
        {
          "<esc>" = "close";
          "q" = "close";
          "j" = "next_sibling";
          "k" = "previous_sibling";

          "h" = "parent";
          "l" = "children";
          "0" = "root";

          "v" = "visual_name";
          "V" = "visual_scope";

          "y" = "yank_name";
          "Y" = "yank_scope";

          "i" = "insert_name";
          "I" = "insert_scope";

          "a" = "append_name";
          "A" = "append_scope";

          "r" = "rename";

          "d" = "delete";

          "f" = "fold_create";
          "F" = "fold_delete";

          "c" = "comment";

          "<enter>" = "select";
          "o" = "select";
          "J" = "move_down";
          "K" = "move_up";

          "s" = "toggle_preview";

          "<C-v>" = "vsplit";
          "<C-s>" = "hsplit";
        }
        ''
           Actions to be triggered for specified keybindings. It can take either action name i.e `toggle_preview`
          Or it can a `rawLua`.
        '';

    lsp = {
      autoAttach = helpers.defaultNullOpts.mkBool false ''
        If set to true, you don't need to manually use attach function
      '';

      preference = helpers.mkNullOrOption (with types; listOf str) ''
        list of lsp server names in order of preference
      '';
    };

    sourceBuffer = {
      followNode = helpers.defaultNullOpts.mkBool true "Keep the current node in focus on the source buffer";

      highlight = helpers.defaultNullOpts.mkBool true "Highlight the currently focused node";

      reorient =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "smart"
            "top"
            "mid"
            "none"
          ]
          ''
            Right section can show previews too.
            Options: "leaf", "always" or "never"
          '';

      scrolloff = helpers.defaultNullOpts.mkInt null ''
        scrolloff value when navbuddy is open.
      '';
    };
  };

  config =
    let
      setupOptions =
        with cfg;
        {
          inherit window;
          node_markers = with nodeMarkers; {
            inherit enabled;
            icons = with icons; {
              inherit leaf branch;
              leaf_selected = leafSelected;
            };
          };
          inherit icons;
          use_default_mapping = useDefaultMapping;
          lsp = with lsp; {
            auto_attach = autoAttach;
            inherit preference;
          };
          source_buffer = sourceBuffer;
          mappings = helpers.ifNonNull' cfg.mappings (
            mapAttrs (
              key: action: if isString action then helpers.mkRaw "actions.${action}()" else action
            ) mappings
          );
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        local actions = require("nvim-navbuddy.actions")
        require('nvim-navbuddy').setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
