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

  # Generates maps for a lua config
  genMaps = mode: maps: let
    /*
    Take a user-defined action (string or attrs) and return the following attribute set:
    {
      action = (string) the actual action to map to this key
      config = (attrs) the configuration options for this mapping (noremap, silent...)
    }

    - If the action is a string:
    {
      action = action;
      config = {};
    }

    - If the action is an attrs:
    {
      action = action;
      config = {
        inherit (action) <values of the config options that have been explicitly set by the user>
      };
    }
    */
    normalizeAction = action:
      if isString action
      # Case 1: action is a string
      then {
        inherit action;
        config = helpers.emptyTable;
      }
      else
        # Case 2: action is an attrs
        let
          # Extract the values of the config options that have been explicitly set by the user
          config =
            filterAttrs (n: v: v != null)
            (getAttrs (attrNames mapConfigOptions) action);
        in {
          config =
            if config == {}
            then helpers.emptyTable
            else config;
          action =
            if action.lua
            then helpers.mkRaw action.action
            else action.action;
        };
  in
    builtins.attrValues (builtins.mapAttrs
      (key: action: let
        normalizedAction = normalizeAction action;
      in {
        inherit (normalizedAction) action config;
        key = key;
        mode = mode;
      })
      maps);

  mapOption = types.oneOf [
    types.str
    (types.submodule {
      options =
        mapConfigOptions
        // {
          action = mkOption {
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
        };
    })
  ];

  mapOptions = mode:
    mkOption {
      description = "Mappings for ${mode} mode";
      type = types.attrsOf mapOption;
      default = {};
    };
in {
  options = {
    maps = mkOption {
      type = types.submodule {
        options = {
          normal = mapOptions "normal";
          insert = mapOptions "insert";
          select = mapOptions "select";
          visual = mapOptions "visual and select";
          terminal = mapOptions "terminal";
          normalVisualOp = mapOptions "normal, visual, select and operator-pending (same as plain 'map')";

          visualOnly = mapOptions "visual only";
          operator = mapOptions "operator-pending";
          insertCommand = mapOptions "insert and command-line";
          lang = mapOptions "insert, command-line and lang-arg";
          command = mapOptions "command-line";
        };
      };
      default = {};
      description = ''
        Custom keybindings for any mode.

        For plain maps (e.g. just 'map' or 'remap') use maps.normalVisualOp.
      '';

      example = ''
        maps = {
          normalVisualOp.";" = ":"; # Same as noremap ; :
          normal."<leader>m" = {
            silent = true;
            action = "<cmd>make<CR>";
          }; # Same as nnoremap <leader>m <silent> <cmd>make<CR>
        };
      '';
    };
  };

  config = let
    mappings =
      (genMaps "" config.maps.normalVisualOp)
      ++ (genMaps "n" config.maps.normal)
      ++ (genMaps "i" config.maps.insert)
      ++ (genMaps "v" config.maps.visual)
      ++ (genMaps "x" config.maps.visualOnly)
      ++ (genMaps "s" config.maps.select)
      ++ (genMaps "t" config.maps.terminal)
      ++ (genMaps "o" config.maps.operator)
      ++ (genMaps "l" config.maps.lang)
      ++ (genMaps "!" config.maps.insertCommand)
      ++ (genMaps "c" config.maps.command);
  in {
    extraConfigLua = optionalString (mappings != []) ''
      -- Set up keybinds {{{
      do
        local __nixvim_binds = ${helpers.toLuaObject mappings}

        for i, map in ipairs(__nixvim_binds) do
          vim.keymap.set(map.mode, map.key, map.action, map.config)
        end
      end
      -- }}}
    '';
  };
}
