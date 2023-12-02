{
  lib,
  helpers,
  config,
  ...
}:
with lib; {
  # This warning has been added on 2023-12-02. TODO: remove it in early Feb. 2024.
  imports = [
    (mkRemovedOptionModule
      ["maps"]
      ''
        Please, use the new `keymaps` option which works as follows:

        keymaps = [
          {
            # Default mode is "" which means normal-visual-op
            key = "<C-m>";
            action = ":!make<CR>";
          }
          {
            # Mode can be a string or a list of strings
            mode = "n";
            key = "<leader>p";
            action = "require('my-plugin').do_stuff";
            lua = true;
            # Note that all of the mapping options are now under the `options` attrs
            options = {
              silent = true;
              desc = "My plugin does stuff";
            };
          }
        ];
      '')
  ];

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
