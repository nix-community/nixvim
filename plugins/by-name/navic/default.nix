{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "navic";
  moduleName = "nvim-navic";
  package = "nvim-navic";
  description = "Simple winbar/statusline plugin that shows your current code context.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    icons = lib.mapAttrs (name: default: defaultNullOpts.mkStr default "icon for ${name}.") {
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

    lsp = {
      auto_attach = defaultNullOpts.mkBool false ''
        Enable to have nvim-navic automatically attach to every LSP for current buffer. Its disabled by default.
      '';

      preference = defaultNullOpts.mkListOf' {
        type = lib.types.str;
        pluginDefault = [ ];
        example = [
          "clangd"
          "pyright"
        ];
        description = ''
          Table ranking lsp_servers. Lower the index, higher the priority of the server. If there are more than one server attached to a buffer. In the example below will prefer clangd over pyright
        '';
      };
    };

    highlight = defaultNullOpts.mkBool false ''
      If set to true, will add colors to icons and text as defined by highlight groups NavicIcons* (NavicIconsFile, NavicIconsModule.. etc.), NavicText and NavicSeparator.
    '';

    separator = defaultNullOpts.mkStr " > " ''
      Icon to separate items. to use between items.
    '';

    depth_limit = defaultNullOpts.mkInt 0 ''
      Maximum depth of context to be shown. If the context hits this depth limit, it is truncated.
    '';

    depth_limit_indicator = defaultNullOpts.mkStr ".." ''
      Icon to indicate that depth_limit was hit and the shown context is truncated.
    '';

    safe_output = defaultNullOpts.mkBool true ''
      Sanitize the output for use in statusline and winbar.
    '';

    lazy_update_context = defaultNullOpts.mkBool false ''
      If true, turns off context updates for the "CursorMoved" event.
    '';

    click = defaultNullOpts.mkBool false ''
      Single click to goto element, double click to open nvim-navbuddy on the clicked element.
    '';
  };

  settingsExample = {
    lsp = {
      auto_attach = true;
      preference = [
        "clangd"
        "tsserver"
      ];
    };
  };
}
