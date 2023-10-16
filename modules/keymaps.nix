{
  config,
  lib,
  ...
}:
with lib; let
  helpers = import ../lib/helpers.nix {inherit lib;};
in {
  options = {
    maps =
      mapAttrs
      (
        modeName: modeProps: let
          desc = modeProps.desc or modeName;
        in
          mkOption {
            description = "Mappings for ${desc} mode";
            type = with types;
              attrsOf
              (
                either
                str
                (
                  helpers.keymaps.mkMapOptionSubmodule
                  {
                    defaultMode = modeProps.short;
                    withKeyOpt = false;
                    flatConfig = true;
                  }
                )
              );
            default = {};
          }
      )
      helpers.keymaps.modes;

    keymaps = mkOption {
      type =
        types.listOf
        (helpers.keymaps.mkMapOptionSubmodule {});
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
    warnings =
      optional
      (
        any
        (modeMaps: modeMaps != {})
        (attrValues config.maps)
      )
      ''
        The `maps` option will be deprecated in the near future.
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
      '';

    extraConfigLua = let
      modeMapsAsList =
        flatten
        (
          mapAttrsToList
          (
            modeOptionName: modeProps:
              mapAttrsToList
              (
                key: action:
                  (
                    if isString action
                    then {
                      mode = modeProps.short;
                      inherit action;
                      lua = false;
                      options = {};
                    }
                    else
                      {
                        inherit
                          (action)
                          action
                          lua
                          mode
                          ;
                      }
                      // {
                        options =
                          getAttrs
                          (attrNames helpers.keymaps.mapConfigOptions)
                          action;
                      }
                  )
                  // {inherit key;}
              )
              config.maps.${modeOptionName}
          )
          helpers.keymaps.modes
        );

      mappings = let
        normalizeMapping = keyMapping: {
          inherit
            (keyMapping)
            mode
            key
            ;

          action =
            if keyMapping.lua
            then helpers.mkRaw keyMapping.action
            else keyMapping.action;

          options =
            if keyMapping.options == {}
            then helpers.emptyTable
            else keyMapping.options;
        };
      in
        map normalizeMapping
        (config.keymaps ++ modeMapsAsList);
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
