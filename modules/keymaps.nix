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
  };

  config = {
    extraConfigLua = let
      # Divide mappings if they have "onEvent" set or not
      partitioned = partition (keymap: (keymap.onEvent or null) != null) config.keymaps;

      nonEventMaps =
        optionalString (partitioned.wrong != [])
        ''
          do
            local __nixvim_binds = ${helpers.toLuaObject (map normalizeMapping partitioned.wrong)}
            for i, map in ipairs(__nixvim_binds) do
              vim.keymap.set(map.mode, map.key, map.action, map.options)
            end
          end
        '';

      # Group by event
      grouped = groupBy (keymap: keymap.onEvent) partitioned.right;

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
    in
      ''
        -- Set up keybinds {{{
          ${nonEventMaps}
      ''
      + foldl (a: b: a + "\n" + b)
      ""
      (mapAttrsToList
        (event: autocmd: autocmd)
        (mapAttrs
          (
            event: mappings:
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
                })
              ''
          )
          grouped))
      + "-- }}}";
  };
}
