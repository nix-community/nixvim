{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts literalLua nestedLiteralLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-starter";
  moduleName = "mini.starter";
  packPathName = "mini.starter";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    autoopen = defaultNullOpts.mkBool true ''
      Whether to open starter buffer on VimEnter. Not opened if Neovim was
      started with intent to show something else (e.g. `nvim foo.txt`).
    '';

    content_hooks = defaultNullOpts.mkListOf types.rawLua (literalLua "nil") ''
      Array of functions to be applied consecutively to initial content.
      Each function should take and return content for Starter buffer.

      Available pre-configured hooks:
      - require("mini.starter").gen_hook.adding_bullet()
      - require("mini.starter").gen_hook.indexing()
      - require("mini.starter").gen_hook.padding()
      - require("mini.starter").gen_hook.aligning()
    '';

    evaluate_single = defaultNullOpts.mkBool false ''
      Whether to evaluate action of single active item.
    '';

    footer = defaultNullOpts.mkStr (literalLua "nil") ''
      Footer to be displayed after items.
      Converted to single string via tostring (use \n to display several lines).
      If function, it is evaluated first.
      If nil (default), default usage help will be shown.
    '';

    header = defaultNullOpts.mkStr (literalLua "nil") ''
      Header to be displayed before items.
      Converted to single string via tostring (use \n to display several lines).
      If function, it is evaluated first.
      If nil (default), polite greeting will be used.
    '';

    items =
      defaultNullOpts.mkListOf
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            action = defaultNullOpts.mkStr null ''
              Function or string for vim.cmd which is executed when item is chosen.
              Empty string results in placeholder "inactive" item.
            '';

            name = defaultNullOpts.mkStr null ''
              String which will be displayed and used for choosing.
            '';

            section = defaultNullOpts.mkStr null ''
              String representing to which section item belongs.
            '';
          };
        })
        (literalLua "nil")
        ''
          Items to be displayed. Should be an array with the following elements:
          - Item: table with action, name, and section keys
          - Function: should return one of these three categories
          - Array: elements of these three types (i.e. item, array, function)

          If nil (default), default items will be used which include:
          - Sessions (if mini.sessions is available)
          - Recent files
          - Builtin actions (edit new buffer, quit)
        '';

    query_updaters = defaultNullOpts.mkStr "abcdefghijklmnopqrstuvwxyz0123456789_-." ''
      Characters to update query. Each character will have special buffer
      mapping overriding your global ones. Be careful to not add : as it
      allows you to go into command mode.
    '';

    silent = defaultNullOpts.mkBool false ''
      Whether to disable showing non-error feedback.
    '';
  };

  settingsExample = {
    autoopen = true;
    content_hooks = [
      (nestedLiteralLua "require(\"mini.starter\").gen_hook.adding_bullet()")
      (nestedLiteralLua "require(\"mini.starter\").gen_hook.indexing('all', { 'Builtin actions' })")
      (nestedLiteralLua "require(\"mini.starter\").gen_hook.aligning('center', 'center')")
    ];
    evaluate_single = true;
    header = ''
      ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
      ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
      ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
    '';
    items = [
      (nestedLiteralLua "require(\"mini.starter\").sections.builtin_actions()")
      (nestedLiteralLua "require(\"mini.starter\").sections.recent_files(10, false)")
      (nestedLiteralLua "require(\"mini.starter\").sections.recent_files(10, true)")
      (nestedLiteralLua "require(\"mini.starter\").sections.sessions(5, true)")
    ];
  };
}
