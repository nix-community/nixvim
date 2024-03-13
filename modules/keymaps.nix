{
  lib,
  helpers,
  config,
  ...
}:
with lib; {
  options = {
    keymaps = mkOption {
      type =
        types.listOf
        helpers.keymaps.mapOptionSubmodule;
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
            action = ''require("cmp").mapping.confirm()'';
            lua = true;
          }
          {
            key = "<C-n>";
            action = ''require("cmp").mapping.select_next_item()'';
            lua = true;
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
    extraConfigLua = let
      normalizeMapping = keyMapping: {
        inherit
          (keyMapping)
          mode
          key
          options
          ;

        action =
          if keyMapping.lua
          then helpers.mkRaw keyMapping.action
          else keyMapping.action;
      };

      mappings = map normalizeMapping config.keymaps;
    in
      optionalString (mappings != [])
      ''
        -- Set up keybinds {{{
        do
          local __nixvim_binds = ${helpers.toLuaObject mappings}
          for i, map in ipairs(__nixvim_binds) do
            vim.keymap.set(map.mode, map.key, map.action, map.options)
          end
        end
      ''
      + foldl (a: b: a + "\n" + b)
      ""
      (
        mapAttrsToList
        (event: mappings:
          optionalString (mappings != [])
          ''
            vim.api.nvim_create_autocmd(
              "${event}", {
                  group = vim.api.nvim_create_augroup("nixvim_binds_${event}", { clear = true }),
                  callback = function()
                    do
                      local __nixvim_binds = ${helpers.toLuaObject (map normalizeMapping mappings)}
                      for i, map in ipairs(__nixvim_binds) do
                        vim.keymap.set(map.mode, map.key, map.action, map.options)
                      end
                    end
                  end
              }
            )
          '')
        config.keymapsOnEvents
      )
      + "-- }}}";
  };
}
