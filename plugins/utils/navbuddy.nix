{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.navic;
  helpers = import ../helpers.nix {inherit lib;};
  mkListStr = helpers.defaultNullOpts.mkNullable (types.listOf types.str);
in {
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

        # TODO: how to do attribute set here or string ?
        size = helpers.defaultNullOpts.mkStr "60%" ''
          Or table format example: { height = "40%", width = "100%"}
        '';

        # TODO: see above
        position = helpers.defaultNullOpts.mkStr "50%" ''
          Or table format example: { height = "40%", width = "100%"}
        '';

        scrolloff = helpers.defaultNullOpts.mkStr null ''
          Or table format example: { height = "40%", width = "100%"}
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
            preview = helpers.defaultNullOpts.mkEnum ["leaf" "always" "never"] "leaf" ''
              Right section can show previews too.
                    Options: "leaf", "always" or "never"
            '';
          };
        };
      };

      node_markers = {
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

      use_default_mapping = helpers.defaultNullOpts.mkBool true ''
        If set to false, only mappings set by user are set. Else default mappings are used for keys that are not set by user
      '';

      lsp = {
        autoAttach = helpers.defaultNullOpts.mkBool false ''
          If set to true, you don't need to manually use attach function
        '';

        preference = helpers.defaultNullOpts.mkListStr null ''
          list of lsp server names in order of preference
        '';
      };

      separator = " > " ''
        Icon to separate items. to use between items.
      '';

      depthLimit = helpers.defaultNullOpts.mkInt 0 ''
        Maximum depth of context to be shown. If the context hits this depth limit, it is truncated.
      '';

      depthLimitIndicator = helpers.defaultNullOpts.mkStr ".." ''
        Icon to indicate that depth_limit was hit and the shown context is truncated.
      '';

      safeOutput = helpers.defaultNullOpts.mkBool true ''
        Sanitize the output for use in statusline and winbar.
      '';

      lazyUpdateContext = helpers.defaultNullOpts.mkBool false ''
        If true, turns off context updates for the "CursorMoved" event.
      '';

      click = helpers.defaultNullOpts.mkBool false ''
        Single click to goto element, double click to open nvim-navbuddy on the clicked element.
      '';
    };

  config = let
    setupOptions = with cfg;
      {
        inherit
          icons
          highlight
          separator
          click
          ;
        lsp = with lsp; {
          auto_attach = autoAttach;
          inherit preference;
        };
        depth_limit = depthLimit;
        safe_output = safeOutput;
        lazy_update_context = lazyUpdateContext;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('nvim-navbuddy').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
