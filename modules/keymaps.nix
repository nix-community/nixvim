{
  lib,
  helpers,
  config,
  options,
  ...
}:
{
  options = {
    keymaps = lib.mkOption {
      type = lib.types.listOf helpers.keymaps.deprecatedMapOptionSubmodule;
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

    keymapsOnEvents = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf helpers.keymaps.deprecatedMapOptionSubmodule);
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
        # All keymap options that have historically supported the `lua` sub-option
        keymapOptions =
          [
            options.keymaps
            options.keymapsOnEvents
            options.plugins.wtf.keymaps.ai
            options.plugins.wtf.keymaps.search
            # NOTE: lsp `diagnostic` and `lspBuf` don't use `mapOptionSubmodule` yet
            # So we only need `lua` deprecation in lsp's `extra` option
            options.plugins.lsp.keymaps.extra
            # NOTE: tmux-navigator added `mapOptionSubmodule` support _after_ branching off 24.05
            options.plugins.tmux-navigator.keymaps
          ]
          # NOTE: barbar added `mapOptionSubmodule` support shortly _before_ branching off 24.05
          ++ builtins.attrValues (builtins.removeAttrs options.plugins.barbar.keymaps [ "silent" ]);
      in
      lib.pipe keymapOptions [
        (map (opt: (opt.type.getSubOptions opt.loc).lua))
        (lib.filter (opt: opt.isDefined))
        (map (opt: ''
          ${"\n"}
          The `${lib.showOption opt.loc}' option is deprecated and will be removed in 24.11.

          You should use a "raw" `action` instead;
          e.g. `action.__raw = "<lua code>"` or `action = helpers.mkRaw "<lua code>"`.

          ${lib.options.showDefs opt.definitionsWithLocations}
        ''))
      ];

    extraConfigLua = lib.mkIf (config.keymaps != [ ]) ''
      -- Set up keybinds {{{
      do
        local __nixvim_binds = ${lib.nixvim.toLuaObject (map helpers.keymaps.removeDeprecatedMapAttrs config.keymaps)}
        for i, map in ipairs(__nixvim_binds) do
          vim.keymap.set(map.mode, map.key, map.action, map.options)
        end
      end
      -- }}}
    '';

    autoGroups = lib.mapAttrs' (
      event: mappings: lib.nameValuePair "nixvim_binds_${event}" { clear = true; }
    ) config.keymapsOnEvents;

    autoCmd = lib.mapAttrsToList (event: mappings: {
      inherit event;
      group = "nixvim_binds_${event}";
      callback = helpers.mkRaw ''
        function(args)
          do
            local __nixvim_binds = ${lib.nixvim.toLuaObject (map helpers.keymaps.removeDeprecatedMapAttrs mappings)}

            for i, map in ipairs(__nixvim_binds) do
              local options = vim.tbl_extend("error", map.options or {}, { buffer = args.buf })
              vim.keymap.set(map.mode, map.key, map.action, options)
            end
          end
        end
      '';
      desc = "Load keymaps for ${event}";
    }) config.keymapsOnEvents;
  };
}
