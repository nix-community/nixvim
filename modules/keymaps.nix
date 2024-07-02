{
  lib,
  helpers,
  config,
  options,
  ...
}:
with lib;
{
  options = {
    keymaps = mkOption {
      type = types.listOf helpers.keymaps.mapOptionSubmodule;
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

    keymapsOnEvents = mkOption {
      type = types.attrsOf (types.listOf helpers.keymaps.mapOptionSubmodule);
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
        foldLuaDefs = foldr (keymap: defs: defs ++ keymap.luaDefs) [ ];
        luaDefs = filterAttrs (_: v: v != [ ]) {
          keymaps = foldLuaDefs config.keymaps;
          keymapsOnEvents = pipe config.keymapsOnEvents [
            attrValues
            flatten
            foldLuaDefs
          ];
        };
      in
      mapAttrsToList (opt: defs: ''
        Nixvim (${opt}): the `lua` option is deprecated and will be removed in 24.11.
        You should use a "raw" `action` instead:
        e.g. `action.__raw = "<lua code>"` or `action = helpers.mkRaw "<lua code>"`.
        Definitions: ${lib.options.showDefs defs}
      '') luaDefs;

    extraConfigLua = optionalString (config.keymaps != [ ]) ''
      -- Set up keybinds {{{
      do
        local __nixvim_binds = ${helpers.toLuaObject config.keymaps}
        for i, map in ipairs(__nixvim_binds) do
          vim.keymap.set(map.mode, map.key, map.action, map.options)
        end
      end
      -- }}}
    '';

    autoGroups = mapAttrs' (
      event: mappings: nameValuePair "nixvim_binds_${event}" { clear = true; }
    ) config.keymapsOnEvents;

    autoCmd = mapAttrsToList (event: mappings: {
      inherit event;
      group = "nixvim_binds_${event}";
      callback = helpers.mkRaw ''
        function()
          do
            local __nixvim_binds = ${helpers.toLuaObject mappings}
            for i, map in ipairs(__nixvim_binds) do
              vim.keymap.set(map.mode, map.key, map.action, map.options)
            end
          end
        end
      '';
      desc = "Load keymaps for ${event}";
    }) config.keymapsOnEvents;
  };
}
