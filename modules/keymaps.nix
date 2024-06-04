{
  lib,
  helpers,
  config,
  options,
  ...
}:
with lib; {
  options = {
    keymaps = mkOption {
      type = types.listOf helpers.keymaps.mapOptionSubmodule;
      default = [];
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
      default = {};
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

  config = let
    # TODO remove `normalizeMapping` once `lua` option is gone
    normalizeMapping = keyMapping: {
      inherit (keyMapping) mode key options;

      action =
        if keyMapping.lua != null && keyMapping.lua
        then helpers.mkRaw keyMapping.action
        else keyMapping.action;
    };
  in {
    # Deprecate `lua` keymap option
    # TODO upgrade to an assertion (removal notice) in 24.11
    # TODO remove entirely in 25.05?
    warnings = let
      luaDefs = pipe options.keymaps.definitionsWithLocations [
        (map (def: {
          inherit (def) file;
          value = filter (v: (v.lua or null) != null) def.value;
        }))
        (filter (def: def.value != []))
        (map (
          def: let
            count = length def.value;
            plural = count > 1;
          in ''
            Found ${toString count} use${optionalString plural "s"} in ${def.file}:
            ${generators.toPretty {} def.value}
          ''
        ))
      ];
    in
      optional (luaDefs != []) ''
        Nixvim (keymaps): the `lua` keymap option is deprecated.

        This option will be removed in 24.11. You should use a "raw" `action` instead;
        e.g. `action.__raw = "<lua code>"` or `action = helpers.mkRaw "<lua code>"`.

        ${concatStringsSep "\n" luaDefs}
      '';

    extraConfigLua = optionalString (config.keymaps != []) ''
      -- Set up keybinds {{{
      do
        local __nixvim_binds = ${helpers.toLuaObject (map normalizeMapping config.keymaps)}
        for i, map in ipairs(__nixvim_binds) do
          vim.keymap.set(map.mode, map.key, map.action, map.options)
        end
      end
      -- }}}
    '';

    autoGroups =
      mapAttrs' (
        event: mappings: nameValuePair "nixvim_binds_${event}" {clear = true;}
      )
      config.keymapsOnEvents;

    autoCmd =
      mapAttrsToList (event: mappings: {
        inherit event;
        group = "nixvim_binds_${event}";
        callback = helpers.mkRaw ''
          function()
            do
              local __nixvim_binds = ${helpers.toLuaObject (map normalizeMapping mappings)}
              for i, map in ipairs(__nixvim_binds) do
                vim.keymap.set(map.mode, map.key, map.action, map.options)
              end
            end
          end
        '';
        desc = "Load keymaps for ${event}";
      })
      config.keymapsOnEvents;
  };
}
