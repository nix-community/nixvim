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
        -- }}}
      '';
  };
}
