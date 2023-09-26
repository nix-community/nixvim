{
  config,
  lib,
  ...
}:
with lib; let
  helpers = import ../lib/helpers.nix {inherit lib;};

  # These are the configuration options that change the behavior of each mapping.
  mapConfigOptions = {
    silent =
      helpers.defaultNullOpts.mkBool false
      "Whether this mapping should be silent. Equivalent to adding <silent> to a map.";

    nowait =
      helpers.defaultNullOpts.mkBool false
      "Whether to wait for extra input on ambiguous mappings. Equivalent to adding <nowait> to a map.";

    script =
      helpers.defaultNullOpts.mkBool false
      "Equivalent to adding <script> to a map.";

    expr =
      helpers.defaultNullOpts.mkBool false
      "Means that the action is actually an expression. Equivalent to adding <expr> to a map.";

    unique =
      helpers.defaultNullOpts.mkBool false
      "Whether to fail if the map is already defined. Equivalent to adding <unique> to a map.";

    noremap =
      helpers.defaultNullOpts.mkBool true
      "Whether to use the 'noremap' variant of the command, ignoring any custom mappings on the defined action. It is highly advised to keep this on, which is the default.";

    remap =
      helpers.defaultNullOpts.mkBool false
      "Make the mapping recursive. Inverses \"noremap\"";

    desc =
      helpers.mkNullOrOption types.str
      "A textual description of this keybind, to be shown in which-key, if you have it.";
  };

  modes = {
    normal.short = "n";
    insert.short = "i";
    visual = {
      desc = "visual and select";
      short = "v";
    };
    visualOnly = {
      desc = "visual only";
      short = "x";
    };
    select.short = "s";
    terminal.short = "t";
    normalVisualOp = {
      desc = "normal, visual, select and operator-pending (same as plain 'map')";
      short = "";
    };
    operator.short = "o";
    lang = {
      desc = "normal, visual, select and operator-pending (same as plain 'map')";
      short = "l";
    };
    insertCommand = {
      desc = "insert and command-line";
      short = "!";
    };
    command.short = "c";
  };

  mkMapOptionSubmodule = {
    defaultMode ? "",
    withKeyOpt ? true,
    flatConfig ? false,
  }:
    with types;
      either
      str
      (types.submodule {
        options =
          (
            if withKeyOpt
            then {
              key = mkOption {
                type = types.str;
                description = "The key to map.";
                example = "<C-m>";
              };
            }
            else {}
          )
          // {
            mode = mkOption {
              type = let
                modeEnum =
                  enum
                  # ["" "n" "v" ...]
                  (
                    map
                    (
                      {short, ...}: short
                    )
                    (attrValues modes)
                  );
              in
                either modeEnum (listOf modeEnum);
              description = ''
                One or several modes.
                Use the short-names (`"n"`, `"v"`, ...).
                See `:h map-modes` to learn more.
              '';
              default = defaultMode;
              example = ["n" "v"];
            };

            action =
              if config.plugins.which-key.enable
              then helpers.mkNullOrOption types.str "The action to execute"
              else
                mkOption {
                  type = types.str;
                  description = "The action to execute.";
                };

            lua = mkOption {
              type = types.bool;
              description = ''
                If true, `action` is considered to be lua code.
                Thus, it will not be wrapped in `""`.
              '';
              default = false;
            };
          }
          // (
            if flatConfig
            then mapConfigOptions
            else {
              options = mapConfigOptions;
            }
          );
      });
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
                  mkMapOptionSubmodule
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
      modes;

    keymaps = mkOption {
      type = types.listOf (mkMapOptionSubmodule {});
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
                          (attrNames mapConfigOptions)
                          action;
                      }
                  )
                  // {inherit key;}
              )
              config.maps.${modeOptionName}
          )
          modes
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
