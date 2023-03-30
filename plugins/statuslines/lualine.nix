{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.lualine;
  helpers = import ../helpers.nix {inherit lib;};

  mkSeparatorsOption = {
    leftDefault ? " ",
    rightDefault ? " ",
    name,
  }: (
    helpers.mkNullOrOption
    (types.submodule {
      options = {
        left = helpers.defaultNullOpts.mkStr leftDefault "Left separator";
        right = helpers.defaultNullOpts.mkStr rightDefault "Right separator";
      };
    })
    "${name} separtors."
  );

  mkComponentOptions = defaultName:
    helpers.mkNullOrOption
    (types.listOf (types.oneOf [
      types.str
      (types.submodule {
        options = {
          name = mkOption {
            type = types.either types.str helpers.rawType;
            description = "Component name or function";
            default = defaultName;
          };

          icons_enabled = helpers.defaultNullOpts.mkBool true ''
            Enables the display of icons alongside the component.
          '';

          icon = helpers.mkNullOrOption types.str ''
            Defines the icon to be displayed in front of the component.
          '';

          separator = mkSeparatorsOption {name = "Component";};

          color = helpers.mkNullOrOption (types.attrsOf types.str) ''
            Defines a custom color for the component.
          '';

          padding =
            helpers.defaultNullOpts.mkNullable
            (
              types.either
              types.int
              (types.submodule {
                options = {
                  left = mkOption {
                    type = types.int;
                    description = "left padding";
                  };
                  right = mkOption {
                    type = types.int;
                    description = "left padding";
                  };
                };
              })
            )
            "1"
            "Adds padding to the left and right of components.";

          extraConfig = mkOption {
            type = types.attrs;
            default = {};
            description = "extra options for the component";
          };
        };
      })
    ]))
    "";

  mkEmptySectionOption = name:
    helpers.mkCompositeOption name {
      lualine_a = mkComponentOptions "";
      lualine_b = mkComponentOptions "";
      lualine_c = mkComponentOptions "";
      lualine_x = mkComponentOptions "";
      lualine_y = mkComponentOptions "";
      lualine_z = mkComponentOptions "";
    };
in {
  options = {
    plugins.lualine = {
      enable = mkEnableOption "lualine";

      package = helpers.mkPackageOption "lualine" pkgs.vimPlugins.lualine-nvim;

      iconsEnabled = mkOption {
        type = types.bool;
        description = "Whether to enable/disable icons for all components.";
        default = true;
      };

      theme = helpers.defaultNullOpts.mkStr "auto" "The theme to use for lualine-nvim.";

      componentSeparators = mkSeparatorsOption {
        leftDefault = "";
        rightDefault = "";
        name = "component";
      };

      sectionSeparators = mkSeparatorsOption {
        leftDefault = "";
        rightDefault = "";
        name = "section";
      };

      disabledFiletypes =
        helpers.mkNullOrOption
        (types.submodule {
          options = {
            statusline = helpers.defaultNullOpts.mkNullable (types.str) "[]" ''
              Only ignores the ft for statusline.
            '';

            winbar = helpers.defaultNullOpts.mkNullable (types.str) "[]" ''
              Only ignores the ft for winbar.
            '';
          };
        })
        "Filetypes to disable lualine for.";

      ignoreFocus = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" ''
        If current filetype is in this list it'll always be drawn as inactive statusline and the
        last window will be drawn as active statusline.

        For example if you don't want statusline of your file tree / sidebar window to have active
        statusline you can add their filetypes here.
      '';

      alwaysDivideMiddle = helpers.defaultNullOpts.mkBool true ''
        When set to true, left sections i.e. 'a','b' and 'c' can't take over the entire statusline
        even if neither of 'x', 'y' or 'z' are present.
      '';

      globalstatus = helpers.defaultNullOpts.mkBool false ''
        Enable global statusline (have a single statusline at bottom of neovim instead of one for
        every window).
        This feature is only available in neovim 0.7 and higher.
      '';

      refresh =
        helpers.mkNullOrOption
        (types.submodule {
          options = {
            statusline = helpers.defaultNullOpts.mkInt 1000 "Refresh time for the status line (ms)";

            tabline = helpers.defaultNullOpts.mkInt 1000 "Refresh time for the tabline (ms)";

            winbar = helpers.defaultNullOpts.mkInt 1000 "Refresh time for the winbar (ms)";
          };
        })
        ''
          Sets how often lualine should refresh it's contents (in ms).
          The refresh option sets minimum time that lualine tries to maintain between refresh.
          It's not guarantied if situation arises that lualine needs to refresh itself before this
          time it'll do it.
        '';

      sections =
        helpers.mkNullOrOption
        (types.submodule {
          options = {
            lualine_a = mkComponentOptions "mode";
            lualine_b = mkComponentOptions "branch";
            lualine_c = mkComponentOptions "filename";

            lualine_x = mkComponentOptions "encoding";
            lualine_y = mkComponentOptions "progress";
            lualine_z = mkComponentOptions "location";
          };
        })
        "Sections configuration";

      inactiveSections =
        helpers.mkCompositeOption "Inactive Sections configuration"
        (types.submodule {
          options = {
            lualine_a = mkComponentOptions "";
            lualine_b = mkComponentOptions "";
            lualine_c = mkComponentOptions "filename";
            lualine_x = mkComponentOptions "location";
            lualine_y = mkComponentOptions "";
            lualine_z = mkComponentOptions "";
          };
        });

      tabline = mkEmptySectionOption "Tabline configuration";

      winbar = mkEmptySectionOption "Winbar configuration";

      inactiveWinbar = mkEmptySectionOption "Inactive Winbar configuration";

      extensions = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = ''[ "fzf" ]'';
        description = "list of enabled extensions";
      };
    };
  };
  config = let
    processComponent = x:
      (
        if isAttrs x
        then processTableComponent
        else id
      )
      x;
    processTableComponent = {
      name,
      icons_enabled,
      icon,
      separator,
      color,
      padding,
      extraConfig,
    }:
      mergeAttrs
      {
        "@" = name;
        inherit icons_enabled icon separator color padding;
      }
      extraConfig;
    processSections = sections: mapAttrs (_: mapNullable (map processComponent)) sections;
    setupOptions = {
      options = {
        icons_enabled = cfg.iconsEnabled;
        theme = cfg.theme;
        section_separators = cfg.sectionSeparators;
        component_separators = cfg.componentSeparators;
        disabled_filetypes = cfg.disabledFiletypes;
        always_divide_middle = cfg.alwaysDivideMiddle;
        globalstatus = cfg.globalstatus;
        refresh = cfg.refresh;
      };

      sections = mapNullable processSections cfg.sections;
      inactive_sections = mapNullable processSections cfg.inactiveSections;
      tabline = mapNullable processSections cfg.tabline;
      winbar = mapNullable processSections cfg.winbar;
      inactive_winbar = mapNullable processSections cfg.inactiveWinbar;
      extensions = cfg.extensions;
    };
  in
    mkIf cfg.enable {
      extraPlugins =
        [cfg.package]
        ++ (optional cfg.iconsEnabled pkgs.vimPlugins.nvim-web-devicons);
      extraPackages = [pkgs.git];
      extraConfigLua = ''require("lualine").setup(${helpers.toLuaObject setupOptions})'';
    };
}
