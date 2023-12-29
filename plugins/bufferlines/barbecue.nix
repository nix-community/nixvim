{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.barbecue;
  mkListStr = helpers.defaultNullOpts.mkNullable (types.listOf types.str);
in {
  options.plugins.barbecue =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "barbecue-nvim";

      package = helpers.mkPackageOption "barbecue-nvim" pkgs.vimPlugins.barbecue-nvim;

      attachNavic = helpers.defaultNullOpts.mkBool true ''
        Whether to attach navic to language servers automatically.
      '';

      createAutocmd = helpers.defaultNullOpts.mkBool true ''
        Whether to create winbar updater autocmd.
      '';

      includeBuftypes = mkListStr ''[""]'' ''
        Buftypes to enable winbar in.
      '';

      excludeFiletypes = mkListStr ''["netrw" "toggleterm"]'' ''
        Filetypes not to enable winbar in.
      '';

      modifiers = {
        dirname = helpers.defaultNullOpts.mkStr ":~:." ''
          Filename modifiers applied to dirname.

          See: `:help filename-modifiers`
        '';

        basename = helpers.defaultNullOpts.mkStr "" ''
          Filename modifiers applied to basename.

          See: `:help filename-modifiers`
        '';
      };

      showDirname = helpers.defaultNullOpts.mkBool true ''
        Whether to display path to file.
      '';

      showBasename = helpers.defaultNullOpts.mkBool true ''
        Whether to display file name.
      '';

      showModified = helpers.defaultNullOpts.mkBool false ''
        Whether to replace file icon with the modified symbol when buffer is modified.
      '';

      modified =
        helpers.defaultNullOpts.mkLuaFn
        ''
          function(bufnr)
          	return vim.bo[bufnr].modified
          end
        ''
        ''
          Get modified status of file.
          NOTE: This can be used to get file modified status from SCM (e.g. git)
        '';

      showNavic = helpers.defaultNullOpts.mkBool true ''
        Whether to show/use navic in the winbar.
      '';

      leadCustomSection =
        helpers.defaultNullOpts.mkLuaFn
        ''
          function()
            return " "
          end
        ''
        ''
          Get leading custom section contents.
          NOTE: This function shouldn't do any expensive actions as it is run on each render.
        '';

      customSection =
        helpers.defaultNullOpts.mkLuaFn
        ''
          function()
            return " "
          end
        ''
        ''
          Get custom section contents.
          NOTE: This function shouldn't do any expensive actions as it is run on each render.
        '';

      theme = helpers.defaultNullOpts.mkStr "auto" ''
        Theme to be used for generating highlight groups dynamically.
      '';

      contextFollowIconColor = helpers.defaultNullOpts.mkBool false ''
        Whether context text should follow its icon's color.
      '';

      symbols = {
        modified = helpers.defaultNullOpts.mkStr "●" ''
          Modification indicator.
        '';

        ellipsis = helpers.defaultNullOpts.mkStr "…" ''
          Truncation indicator.
        '';

        separator = helpers.defaultNullOpts.mkStr "" ''
          Entry separator.
        '';
      };

      kinds =
        mapAttrs
        (
          name: default:
            helpers.defaultNullOpts.mkStr default "icon for ${name}."
        )
        {
          File = "";
          Module = "";
          Namespace = "";
          Package = "";
          Class = "";
          Method = "";
          Property = "";
          Field = "";
          Constructor = "";
          Enum = "";
          Interface = "";
          Function = "";
          Variable = "";
          Constant = "";
          String = "";
          Number = "";
          Boolean = "";
          Array = "";
          Object = "";
          Key = "";
          Null = "";
          EnumMember = "";
          Struct = "";
          Event = "";
          Operator = "";
          TypeParameter = "";
        };
    };

  config = let
    setupOptions = with cfg;
      {
        attach_navic = attachNavic;
        create_autocmd = createAutocmd;
        include_buftypes = includeBuftypes;
        exclude_filetypes = excludeFiletypes;
        modifiers = {
          inherit
            (modifiers)
            dirname
            basename
            ;
        };
        show_dirname = showDirname;
        show_basename = showBasename;
        show_modified = showModified;
        inherit modified;
        show_navic = showNavic;
        lead_custom_section = leadCustomSection;
        custom_section = customSection;
        inherit theme;
        context_follow_icon_color = contextFollowIconColor;
        symbols = {
          inherit
            (symbols)
            modified
            ellipsis
            separator
            ;
        };
        inherit kinds;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('barbecue').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
