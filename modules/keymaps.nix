{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib.nixvim) toLuaObject;
  inherit (lib.nixvim.keymaps)
    removeDeprecatedMapAttrs
    deprecatedMapOptionSubmodule
    ;
in
{
  options = {
    keymaps = lib.mkOption {
      type = lib.types.listOf deprecatedMapOptionSubmodule;
      default = [ ];
      description = "Nixvim keymaps.";
      example = [
        {
          key = "<C-m>";
          action = "<cmd>make<CR>";
          options.silent = true;
        }
      ];
    };

    keymapsOnEvents = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf deprecatedMapOptionSubmodule);
      default = { };
      example = {
        "InsertEnter" = [
          {
            key = "<C-y>";
            action.__raw = ''require("cmp").mapping.confirm()'';
          }
          {
            key = "<C-n>";
            action.__raw = ''require("cmp").mapping.select_next_item()'';
          }
        ];
      };
      description = ''
        Register keymaps on an event instead of when nvim opens.
        Keys are the events to register on, and values are lists of keymaps to register on each event.
      '';
    };
  };

  config = {
    # Deprecate `lua` keymap option
    # TODO upgrade to an assertion (removal notice) in 24.11
    # TODO remove entirely in 25.05?
    warnings =
      let
        keymapsUsingLua =
          lib.pipe
            # All keymap options that have historically supported the `lua` sub-option
            [
              options.keymaps.valueMeta.list
              (lib.concatMap (ev: ev.list) (lib.attrValues options.keymapsOnEvents.valueMeta.attrs))

              # NOTE: lsp `diagnostic` and `lspBuf` don't use `mapOptionSubmodule` yet
              # So we only need `lua` deprecation in lsp's `extra` option
              options.plugins.lsp.keymaps.extra.valueMeta.list

              # NOTE: tmux-navigator added `mapOptionSubmodule` support _after_ branching off 24.05
              options.plugins.tmux-navigator.keymaps.valueMeta.list

              # NOTE: barbar added `mapOptionSubmodule` support shortly _before_ branching off 24.05
              (lib.mapAttrsToList (name: opt: opt.valueMeta) (
                removeAttrs options.plugins.barbar.keymaps [ "silent" ]
              ))
            ]
            [
              lib.concatLists
              (lib.filter (meta: meta.configuration.options.lua.isDefined or false))
              (map (meta: meta.configuration.options))
            ];
      in
      lib.optional (keymapsUsingLua != [ ]) ''
        The `lua` keymap option is deprecated and will be removed in 26.05.

        You should use a "raw" `action` instead;
        e.g. `action.__raw = "<lua code>"` or `action = lib.nixvim.mkRaw "<lua code>"`.

        ${lib.concatMapStringsSep "\n" (
          m: "- `${m.lua}' is defined in " + lib.options.showFiles m.lua.files
        ) keymapsUsingLua}
      '';

    extraConfigLua = lib.mkIf (config.keymaps != [ ]) ''
      -- Set up keybinds {{{
      do
        local __nixvim_binds = ${toLuaObject (map removeDeprecatedMapAttrs config.keymaps)}
        for i, map in ipairs(__nixvim_binds) do
          vim.keymap.set(map.mode, map.key, map.action, map.options)
        end
      end
      -- }}}
    '';

    autoGroups = lib.mapAttrs' (
      event: mappings: lib.nameValuePair "nixvim_binds_${event}" { clear = true; }
    ) config.keymapsOnEvents;

    autoCmd = lib.mapAttrsToList (event: mappings: {
      inherit event;
      group = "nixvim_binds_${event}";
      callback = lib.nixvim.mkRaw ''
        function(args)
          do
            local __nixvim_binds = ${toLuaObject (map removeDeprecatedMapAttrs mappings)}

            for i, map in ipairs(__nixvim_binds) do
              local options = vim.tbl_extend("keep", map.options or {}, { buffer = args.buf })
              vim.keymap.set(map.mode, map.key, map.action, options)
            end
          end
        end
      '';
      desc = "Load keymaps for ${event}";
    }) config.keymapsOnEvents;
  };
}
