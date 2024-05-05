{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.yanky;
in {
  options.plugins.yanky =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "yanky.nvim";

      package = helpers.mkPackageOption "yanky.nvim" pkgs.vimPlugins.yanky-nvim;

      ring = {
        historyLength = helpers.defaultNullOpts.mkUnsignedInt 100 ''
          Define the number of yanked items that will be saved and used for ring.
        '';

        storage =
          helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "shada"
            "sqlite"
            "memory"
          ]
          ''
            Define the storage mode for ring values.

            Using `shada`, this will save pesistantly using Neovim ShaDa feature.
            This means that history will be persisted between each session of Neovim.

            You can also use this feature to sync the yank history across multiple running instances
            of Neovim by updating shada file.
            If you execute `:wshada` in the first instance and then `:rshada` in the second instance,
            the second instance will be synced with the yank history in the first instance.

            Using `memory`, each Neovim instance will have his own history and il will be lost between
            sessions.

            Sqlite is more reliable than ShaDa but requires more dependencies.
            You can change the storage path using `ring.storagePath` option.
          '';

        storagePath = helpers.defaultNullOpts.mkNullable (
          with types; either str helpers.nixvimTypes.rawLua
        ) ''{__raw = "vim.fn.stdpath('data') .. '/databases/yanky.db'";}'' "Only for sqlite storage.";

        syncWithNumberedRegisters = helpers.defaultNullOpts.mkBool true ''
          History can also be synchronized with numbered registers.
          Every time the yank history changes the numbered registers 1 - 9 will be updated to sync
          with the first 9 entries in the yank history.
          See [here](http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/) for an explanation of why we would want do do this.
        '';

        cancelEvent =
          helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "update"
            "move"
          ]
          ''
            Define the event used to cancel ring activation.
            `update` will cancel ring on next buffer update, `move` will cancel ring when moving
            cursor or content changed.
          '';

        ignoreRegisters = helpers.defaultNullOpts.mkNullable (with types; listOf str) ''["_"]'' ''
          Define registers to be ignored.
          By default the black hole register is ignored.
        '';

        updateRegisterOnCycle = helpers.defaultNullOpts.mkBool false ''
          If true, when you cycle through the ring, the contents of the register used to update will
          be updated with the last content cycled.
        '';
      };

      picker = {
        select = {
          action = helpers.mkNullOrOption (with types; either helpers.nixvimTypes.rawLua str) ''
            This define the action that should be done when selecting an item in the
            `vim.ui.select` prompt.
            If you let this option to `null`, this will use the default action: put selected item
            after cursor.

            This is either:
            - a `rawLua` value (`action.__raw = "function() foo end";`).
            - a string. In this case, Nixvim will automatically interpret it as a builtin yanky
            action.
              Example: `action = "put('p')";` will translate to
                `action = require('yanky.picker').actions.put('p')` in lua.
          '';
        };

        telescope = {
          enable = mkEnableOption "the `yank_history` telescope picker.";

          useDefaultMappings = helpers.defaultNullOpts.mkBool true ''
            This define if default Telescope mappings should be used.
          '';

          mappings = helpers.mkNullOrOption (with types; attrsOf (attrsOf str)) ''
            This define or overrides the mappings available in Telescope.

            If you set `useDefaultMappings` to `true`, mappings will be merged with default
            mappings.

            Example:
            ```nix
              {
                i = {
                  "<c-g>" = "put('p')";
                  "<c-k>" = "put('P')";
                  "<c-x>" = "delete()";
                  "<c-r>" = "set_register(require('yanky.utils').get_default_register())";
                };
                n = {
                  p = "put('p')";
                  P = "put('P')";
                  d = "delete()";
                  r = "set_register(require('yanky.utils').get_default_register())";
                };
              }
            ```
          '';
        };
      };

      systemClipboard = {
        syncWithRing = helpers.defaultNullOpts.mkBool true ''
          Yanky can automatically adds to ring history yanks that occurs outside of Neovim.
          This works regardless to your `&clipboard` setting.

          This means, if `&clipboard` is set to `unnamed` and/or `unnamedplus`, if you yank
          something outside of Neovim, you can put it immediately using `p` and it will be added to
          your yank ring.

          If `&clipboard` is empty, if you yank something outside of Neovim, this will be the first
          value you'll have when cycling through the ring.
          Basically, you can do `p` and then `<c-p>` to paste yanked text.
        '';
      };

      highlight = {
        onPut = helpers.defaultNullOpts.mkBool true ''
          Define if highlight put text feature is enabled.
        '';

        onYank = helpers.defaultNullOpts.mkBool true ''
          Define if highlight yanked text feature is enabled.
        '';

        timer = helpers.defaultNullOpts.mkUnsignedInt 500 ''
          Define the duration of highlight.
        '';
      };

      preserveCursorPosition = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Whether cursor position should be preserved on yank.
          This works only if mappings has been defined.
        '';
      };

      textobj = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Yanky comes with a text object corresponding to last put text.
          To use it, you have to enable it and set a keymap.
        '';
      };
    };

  config = let
    thereAreSomeTelescopeMappings =
      (cfg.picker.telescope.mappings != null) && (cfg.picker.telescope.mappings != {});
  in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = thereAreSomeTelescopeMappings -> cfg.picker.telescope.enable;
          message = ''
            Nixvim: You have defined some mappings in `plugins.yanky.picker.telescope.mappings` but
            you have not set `plugins.yanky.picker.telescope.enable`.
          '';
        }
      ];

      plugins.telescope.enable = true;
      plugins.telescope.enabledExtensions = optional cfg.picker.telescope.enable "yank_history";

      extraPlugins =
        [
          cfg.package
        ]
        ++ (optional (cfg.ring.storage == "sqlite") pkgs.vimPlugins.sqlite-lua);

      extraConfigLua = let
        setupOptions = with cfg;
          {
            ring = {
              history_length = ring.historyLength;
              inherit (ring) storage;
              storage_path = ring.storagePath;
              sync_with_numbered_registers = ring.syncWithNumberedRegisters;
              cancel_event = ring.cancelEvent;
              ignore_registers = ring.ignoreRegisters;
              update_register_on_cycle = ring.updateRegisterOnCycle;
            };
            picker = {
              select = {
                action =
                  if isString picker.select.action
                  then helpers.mkRaw "require('yanky.picker').actions.${picker.select.action}"
                  else picker.select.action;
              };
              telescope = {
                use_default_mappings = picker.telescope.useDefaultMappings;
                mappings = helpers.ifNonNull' picker.telescope.mappings (
                  mapAttrs (
                    mode: mappings: mapAttrs (key: action: helpers.mkRaw "__yanky_telescope_mapping.${action}") mappings
                  )
                  picker.telescope.mappings
                );
              };
            };
            system_clipboard = {
              sync_with_ring = systemClipboard.syncWithRing;
            };
            highlight = {
              on_put = highlight.onPut;
              on_yank = highlight.onYank;
              inherit (highlight) timer;
            };
            preserve_cursor_position = {
              inherit (preserveCursorPosition) enabled;
            };
            textobj = {
              inherit (textobj) enabled;
            };
          }
          // cfg.extraOptions;
      in
        (optionalString thereAreSomeTelescopeMappings "local __yanky_telescope_mapping = require('yanky.telescope.mapping')")
        + ''
          require('yanky').setup(${helpers.toLuaObject setupOptions})
        '';
    };
}
