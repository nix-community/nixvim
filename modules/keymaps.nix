{ config, lib, helpers, ... }:
with lib;
let
  mapOption = types.oneOf [
    types.str
    (types.submodule {
      options = {
        silent = mkOption {
          type = types.bool;
          description = "Whether this mapping should be silent. Equivalent to adding <silent> to a map.";
          default = false;
        };

        nowait = mkOption {
          type = types.bool;
          description = "Whether to wait for extra input on ambiguous mappings. Equivalent to adding <nowait> to a map.";
          default = false;
        };

        script = mkOption {
          type = types.bool;
          description = "Equivalent to adding <script> to a map.";
          default = false;
        };

        expr = mkOption {
          type = types.bool;
          description = "Means that the action is actually an expression. Equivalent to adding <expr> to a map.";
          default = false;
        };

        unique = mkOption {
          type = types.bool;
          description = "Whether to fail if the map is already defined. Equivalent to adding <unique> to a map.";
          default = false;
        };

        noremap = mkOption {
          type = types.bool;
          description = "Whether to use the 'noremap' variant of the command, ignoring any custom mappings on the defined action. It is highly advised to keep this on, which is the default.";
          default = true;
        };

        action = mkOption {
          type = types.str;
          description = "The action to execute.";
        };

        description = mkOption {
          type = types.nullOr types.str;
          description = "A textual description of this keybind, to be shown in which-key, if you have it.";
          default = null;
        };
      };
    })
  ];

  mapOptions = mode: mkOption {
    description = "Mappings for ${mode} mode";
    type = types.attrsOf mapOption;
    default = { };
  };
in
{
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
      default = { };
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

  config =
    let
      mappings =
        (helpers.genMaps "" config.maps.normalVisualOp) ++
        (helpers.genMaps "n" config.maps.normal) ++
        (helpers.genMaps "i" config.maps.insert) ++
        (helpers.genMaps "v" config.maps.visual) ++
        (helpers.genMaps "x" config.maps.visualOnly) ++
        (helpers.genMaps "s" config.maps.select) ++
        (helpers.genMaps "t" config.maps.terminal) ++
        (helpers.genMaps "o" config.maps.operator) ++
        (helpers.genMaps "l" config.maps.lang) ++
        (helpers.genMaps "!" config.maps.insertCommand) ++
        (helpers.genMaps "c" config.maps.command);
    in
    {
      # TODO: Use vim.keymap.set if on nvim >= 0.7
      extraConfigLua = optionalString (mappings != [ ]) ''
        -- Set up keybinds {{{
        do
          local __nixvim_binds = ${helpers.toLuaObject mappings}

          for i, map in ipairs(__nixvim_binds) do
            vim.api.nvim_set_keymap(map.mode, map.key, map.action, map.config)
          end
        end
        -- }}}
      '';
    };
}
