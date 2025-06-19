{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "trouble";
  packPathName = "trouble.nvim";
  package = "trouble-nvim";
  description = "A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.";

  maintainers = [ lib.maintainers.loicreynier ];

  # TODO introduced 2024-03-15: remove 2024-05-15
  optionsRenamedToSettings = [
    "autoClose"
    "autoFold"
    "autoOpen"
    "autoJump"
    "autoPreview"
    "foldClosed"
    "foldOpen"
    "group"
    "height"
    "icons"
    "indentLines"
    "mode"
    "padding"
    "position"
    "width"
    "useDiagnosticSigns"

    [
      "actionKeys"
      "cancel"
    ]
    [
      "actionKeys"
      "close"
    ]
    [
      "actionKeys"
      "closeFolds"
    ]
    [
      "actionKeys"
      "hover"
    ]
    [
      "actionKeys"
      "jump"
    ]
    [
      "actionKeys"
      "jumpClose"
    ]
    [
      "actionKeys"
      "next"
    ]
    [
      "actionKeys"
      "openFolds"
    ]
    [
      "actionKeys"
      "openSplit"
    ]
    [
      "actionKeys"
      "openTab"
    ]
    [
      "actionKeys"
      "openVsplit"
    ]
    [
      "actionKeys"
      "previous"
    ]
    [
      "actionKeys"
      "refresh"
    ]
    [
      "actionKeys"
      "toggleFold"
    ]
    [
      "actionKeys"
      "toggleMode"
    ]
    [
      "actionKeys"
      "togglePreview"
    ]
    [
      "signs"
      "error"
    ]
    [
      "signs"
      "hint"
    ]
    [
      "signs"
      "other"
    ]
    [
      "signs"
      "warning"
    ]
  ];

  settingsOptions = {
    auto_close = defaultNullOpts.mkBool false ''
      Automatically close the list when you have no diagnostics.
    '';

    auto_preview = defaultNullOpts.mkBool true ''
      Automatically preview the location of the diagnostic.
      `<esc>` to close preview and go back to last window.
    '';

    auto_refresh = defaultNullOpts.mkBool false ''
      Automatically refresh when open.
    '';

    auto_jump = defaultNullOpts.mkBool false ''
      Auto jump to the item when there's only one.
    '';

    focus = defaultNullOpts.mkBool false ''
      Focus the window when opened.
    '';

    restore = defaultNullOpts.mkBool true ''
      Restores the last location in the list when opening.
    '';

    follow = defaultNullOpts.mkBool true ''
      Follow the current item.
    '';

    indent_guides = defaultNullOpts.mkBool true ''
      Add indent guides.
    '';

    max_items = defaultNullOpts.mkUnsignedInt 200 ''
      Limit the number of items that can be displayed per section.
    '';

    multiline = defaultNullOpts.mkBool true ''
      Render multi-line messages.
    '';

    pinned = defaultNullOpts.mkBool false ''
      Whether the opened trouble window will be bound to the current buffer.
    '';

    warn_no_results = defaultNullOpts.mkBool true ''
      Show a warning when there are no results.
    '';

    open_no_results = defaultNullOpts.mkBool false ''
      Open the trouble window when there are no results.
    '';

    win = defaultNullOpts.mkAttrsOf lib.types.anything { } ''
      Window options for the results window. Can be a split or a floating window.

      See `|nvim_open_win()|`.
    '';

    preview =
      defaultNullOpts.mkAttrsOf lib.types.anything
        {
          type = "main";
          scratch = true;
        }
        ''
          Window options for the preview window.

          See `|nvim_open_win()|`.
        '';

    keys =
      defaultNullOpts.mkAttrsOf lib.types.anything
        {
          "?" = "help";
          r = "refresh";
          R = "toggle_refresh";
          q = "close";
          o = "jump_close";
          "<esc>" = "cancel";
          "<cr>" = "jump";
          "<2-leftmouse>" = "jump";
          "<c-s>" = "jump_split";
          "<c-v>" = "jump_vsplit";
          "}" = "next";
          "]]" = "next";
          "{" = "prev";
          "[[" = "prev";
          dd = "delete";
          d = {
            action = "delete";
            mode = "v";
          };
          i = "inspect";
          p = "preview";
          P = "toggle_preview";
          zo = "fold_open";
          zO = "fold_open_recursive";
          zc = "fold_close";
          zC = "fold_close_recursive";
          za = "fold_toggle";
          zA = "fold_toggle_recursive";
          zm = "fold_more";
          zM = "fold_close_all";
          zr = "fold_reduce";
          zR = "fold_open_all";
          zx = "fold_update";
          zX = "fold_update_all";
          zn = "fold_disable";
          zN = "fold_enable";
          zi = "fold_toggle_enable";
          gb = {
            action.__raw = ''
              function(view)
                view:filter({ buf = 0 }, { toggle = true })
              end
            '';
            desc = "Toggle Current Buffer Filter";
          };
          s = {
            action.__raw = ''
              function(view)
                 local f = view:get_filter("severity")
                 local severity = ((f and f.filter.severity or 0) + 1) % 5
                 view:filter({ severity = severity }, {
                   id = "severity",
                   template = "{hl:Title}Filter:{hl} {severity}",
                   del = severity == 0,
                 })
              end
            '';
            desc = "Toggle Severity Filter";
          };
        }
        ''
          Key mappings can be set to the name of a builtin action,
          or you can define your own custom action.
        '';

    modes =
      defaultNullOpts.mkAttrsOf lib.types.anything
        {
          lsp_references = {
            params = {
              include_declaration = true;
            };
          };
          lsp_base = {
            params = {
              include_current = false;
            };
          };
          symbols = {
            desc = "document symbols";
            mode = "lsp_document_symbols";
            focus = false;
            win = {
              position = "right";
            };
            filter = {
              "not" = {
                ft = "lua";
                kind = "Package";
              };
              any = {
                ft = [
                  "help"
                  "markdown"
                ];
                kind = [
                  "Class"
                  "Constructor"
                  "Enum"
                  "Field"
                  "Function"
                  "Interface"
                  "Method"
                  "Module"
                  "Namespace"
                  "Package"
                  "Property"
                  "Struct"
                  "Trait"
                ];
              };
            };
          };
        }
        ''
          Customize the various builtin modes or define your own.
        '';

    icons = defaultNullOpts.mkAttrsOf lib.types.anything {
      indent = {
        top = "│ ";
        middle = "├╴";
        last = "└╴";
        fold_open = " ";
        fold_closed = " ";
        ws = "  ";
      };
      folder_closed = " ";
      folder_open = " ";
      kinds = {
        Array = " ";
        Boolean = "󰨙 ";
        Class = " ";
        Constant = "󰏿 ";
        Constructor = " ";
        Enum = " ";
        EnumMember = " ";
        Event = " ";
        Field = " ";
        File = " ";
        Function = "󰊕 ";
        Interface = " ";
        Key = " ";
        Method = "󰊕 ";
        Module = " ";
        Namespace = "󰦮 ";
        Null = " ";
        Number = "󰎠 ";
        Object = " ";
        Operator = " ";
        Package = " ";
        Property = " ";
        String = " ";
        Struct = "󰆼 ";
        TypeParameter = " ";
        Variable = "󰀫 ";
      };
    } "Define custom icons.";
  };

  extraConfig = cfg: {
    # TODO: introduced 2024-10-12: remove after 24.11
    warnings =
      let
        definedOpts = lib.filter (opt: lib.hasAttrByPath (lib.toList opt) cfg.settings) [
          "action_keys"
          "position"
          "height"
          "width"
          "mode"
          "fold_open"
          "fold_close"
          "group"
          "padding"
          "cycle_results"
          "indent_lines"
          "win_config"
          "include_declaration"
          "signs"
          "use_diagnostic_signs"
        ];
      in
      lib.nixvim.mkWarnings "plugins.trouble" {
        when = definedOpts != [ ];
        message = ''
          The following v2 settings options are no longer supported in v3:
          ${lib.concatMapStringsSep "\n" (opt: "  - ${lib.showOption (lib.toList opt)}") definedOpts}
        '';
      };

    # TODO: added 2024-09-20 remove after 24.11
    plugins.web-devicons = lib.mkIf (
      !(
        config.plugins.mini.enable
        && config.plugins.mini.modules ? icons
        && config.plugins.mini.mockDevIcons
      )
    ) { enable = lib.mkOverride 1490 true; };
  };
}
