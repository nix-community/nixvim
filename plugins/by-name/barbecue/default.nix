{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "barbecue";
  packPathName = "barbecue.nvim";
  package = "barbecue-nvim";
  description = "Visual Studio Code inspired breadcrumbs plugin.";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: added 2024-09-03 remove after 24.11
  optionsRenamedToSettings = [
    "attachNavic"
    "createAutocmd"
    "includeBuftypes"
    "excludeFiletypes"
    [
      "modifiers"
      "dirname"
    ]
    [
      "modifiers"
      "basename"
    ]
    "showDirname"
    "showBasename"
    "showModified"
    "modified"
    "showNavic"
    "leadCustomSection"
    "customSection"
    "theme"
    "contextFollowIconColor"
    [
      "symbols"
      "modified"
    ]
    [
      "symbols"
      "ellipsis"
    ]
    [
      "symbols"
      "separator"
    ]
    "kinds"
  ];

  settingsOptions = {
    attach_navic = defaultNullOpts.mkBool true ''
      Whether to attach navic to language servers automatically.
    '';

    create_autocmd = defaultNullOpts.mkBool true ''
      Whether to create winbar updater autocmd.
    '';

    include_buftypes = defaultNullOpts.mkListOf lib.types.str [ "" ] ''
      Buftypes to enable winbar in.
    '';

    exclude_filetypes =
      defaultNullOpts.mkListOf lib.types.str
        [
          "netrw"
          "toggleterm"
        ]
        ''
          Filetypes not to enable winbar in.
        '';

    modifiers = {
      dirname = defaultNullOpts.mkStr ":~:." ''
        Filename modifiers applied to dirname.

        See: `:help filename-modifiers`
      '';

      basename = defaultNullOpts.mkStr "" ''
        Filename modifiers applied to basename.

        See: `:help filename-modifiers`
      '';
    };

    show_dirname = defaultNullOpts.mkBool true ''
      Whether to display path to file.
    '';

    show_basename = defaultNullOpts.mkBool true ''
      Whether to display file name.
    '';

    show_modified = defaultNullOpts.mkBool false ''
      Whether to replace file icon with the modified symbol when buffer is modified.
    '';

    modified =
      defaultNullOpts.mkLuaFn
        ''
          function(bufnr)
          	return vim.bo[bufnr].modified
          end
        ''
        ''
          Get modified status of file.
          NOTE: This can be used to get file modified status from SCM (e.g. git)
        '';

    show_navic = defaultNullOpts.mkBool true ''
      Whether to show/use navic in the winbar.
    '';

    lead_custom_section =
      defaultNullOpts.mkLuaFn
        ''
          function()
            return " "
          end
        ''
        ''
          Get leading custom section contents.
          NOTE: This function shouldn't do any expensive actions as it is run on each render.
        '';

    custom_section =
      defaultNullOpts.mkLuaFn
        ''
          function()
            return " "
          end
        ''
        ''
          Get custom section contents.
          NOTE: This function shouldn't do any expensive actions as it is run on each render.
        '';

    theme = defaultNullOpts.mkStr "auto" ''
      Theme to be used for generating highlight groups dynamically.
    '';

    context_follow_icon_color = defaultNullOpts.mkBool false ''
      Whether context text should follow its icon's color.
    '';

    symbols = {
      modified = defaultNullOpts.mkStr "●" ''
        Modification indicator.
      '';

      ellipsis = defaultNullOpts.mkStr "…" ''
        Truncation indicator.
      '';

      separator = defaultNullOpts.mkStr "" ''
        Entry separator.
      '';
    };

    kinds = lib.mapAttrs (name: default: defaultNullOpts.mkStr default "icon for ${name}.") {
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
}
