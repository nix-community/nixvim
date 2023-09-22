{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.plugins.navic;
  helpers = import ../helpers.nix { inherit lib; };
  mkListStr = helpers.defaultNullOpts.mkNullable (types.listOf types.str);
  percentageType = types.ints.between 0 100;
  mkPercentageOpt = default: helpers.defaultNullOpts.mkNullable percentageType (toString default);
in
{
  options.plugins.navic =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-navbuddy";

      package = helpers.mkPackageOption "nvim-navbuddy" pkgs.vimPlugins.nvim-navbuddy;

      window = {
        border = helpers.defaultNullOpts.mkBorder "rounded" "double" "solid" "none" ''
          "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
          starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
        '';

        size =
          helpers.defaultNullOpts.mkNullable
            (
              with types;
              either
                percentageType
                (submodule {
                  options = {
                    height = mkPercentageOpt 40 "The height size (in %).";

                    width = mkPercentageOpt 100 "The width size (in %).";
                  };
                })
            )
            "60"
            "The size of the window.";

        position =
          helpers.defaultNullOpts.mkNullable
            (
              with types;
              either
                percentageType
                (submodule {
                  options = {
                    height = mkPercentageOpt 40 "The height size (in %).";

                    width = mkPercentageOpt 100 "The width size (in %).";
                  };
                })
            )
            "50";

        scrolloff = helpers.defaultNullOpts.mkInt null ''
          scrolloff value within navbuddy window
        '';

        sections = {
          left = {
            size = helpers.defaultNullOpts.mkStr "20%";
            border = helpers.defaultNullOpts.mkBorder "rounded" "double" "solid" "none" null ''
              "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
              starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
            '';
          };

          mid = {
            size = helpers.defaultNullOpts.mkStr "40%";
            border = helpers.defaultNullOpts.mkBorder "rounded" "double" "solid" "none" null ''
              "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
              starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
            '';
          };

          right = {
            border = helpers.defaultNullOpts.mkBorder "rounded" "double" "solid" "none" null ''
              "rounded", "double", "solid", "none"  or an array with eight chars building up the border in a clockwise fashion
              starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
            '';
            preview = helpers.defaultNullOpts.mkEnum [ "leaf" "always" "never" ] "leaf" ''
              Right section can show previews too.
                    Options: "leaf", "always" or "never"
            '';
          };
        };
      };

      nodeMarkers = {
        enabled = true;
        icons = {
          leaf = helpers.defaultNullOpts.mkStr "  " ''
            The icon to use for leaf nodes.
          '';

          leaf_selected = helpers.defaultNullOpts.mkStr " → " ''
            The icon to use for selected leaf node.
          '';
          branch = helpers.defaultNullOpts.mkStr "  " ''
            The icon to use for branch nodes.
          '';
        };
      };

      icons =
        mapAttrs
          (
            name: default:
              default "icon for ${name}."
          )
          {
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

      mapping = {
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

      };

      lsp = {
        autoAttach = helpers.defaultNullOpts.mkBool false ''
          If set to true, you don't need to manually use attach function
        '';

        preference = helpers.defaultNullOpts.mkListStr null ''
          list of lsp server names in order of preference
        '';
      };

      sourceBuffer = {
        followNode = helpers.defaultNullOpts.mkBool true "Keep the current node in focus on the source buffer";
        highlight = helpers.defaultNullOpts.mkBool true "Highlight the currently focused node";
        reorient = helpers.defaultNullOpts.mkEnum [ "smart" "top" "mid" "none" ] "smart" ''
          Right section can show previews too.
                Options: "leaf", "always" or "never"
        '';
        scrolloff = helpers.defaultNullOpts.mkInt null ''
          scrolloff value when navbuddy is open
        '';
      };
    };

  config =
    let
      setupOptions = with cfg;
        {
          inherit
            window
            icons
            mapping
            ;
          node_markers = nodeMarkers;
          use_default_mapping = useDefaultMapping;
          lsp = with lsp; {
            auto_attach = autoAttach;
            inherit preference;
          };
          source_buffer = sourceBuffer;
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require('nvim-navbuddy').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
