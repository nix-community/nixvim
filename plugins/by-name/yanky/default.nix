{
  lib,
  config,
  helpers,
  options,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "yanky";
  originalName = "yanky.nvim";
  package = "yanky-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-06-28. Remove after 24.11 release.
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    [
      "ring"
      "historyLength"
    ]
    [
      "ring"
      "storage"
    ]
    [
      "ring"
      "storagePath"
    ]
    [
      "ring"
      "syncWithNumberedRegisters"
    ]
    [
      "ring"
      "cancelEvent"
    ]
    [
      "ring"
      "ignoreRegisters"
    ]
    [
      "ring"
      "updateRegisterOnCycle"
    ]
    [
      "picker"
      "telescope"
      "useDefaultMappings"
    ]
    [
      "systemClipboard"
      "syncWithRing"
    ]
    [
      "highlight"
      "onPut"
    ]
    [
      "highlight"
      "onYank"
    ]
    [
      "highlight"
      "timer"
    ]
    [
      "preserveCursorPosition"
      "enabled"
    ]
    [
      "textobj"
      "enabled"
    ]
  ];
  imports =
    let
      basePluginPath = [
        "plugins"
        "yanky"
      ];
    in
    [
      (mkRemovedOptionModule
        (
          basePluginPath
          ++ [
            "picker"
            "select"
            "action"
          ]
        )
        ''
          Please use `plugins.yanky.settings.picker.select.action` instead.
          However, be careful as we do not perform any manipulation on the provided string.
        ''
      )
      (mkRenamedOptionModule (
        basePluginPath
        ++ [
          "picker"
          "telescope"
          "enable"
        ]
      ) (basePluginPath ++ [ "enableTelescope" ]))
      (mkRemovedOptionModule
        (
          basePluginPath
          ++ [
            "picker"
            "telescope"
            "mappings"
          ]
        )
        ''
          Please use `plugins.yanky.settings.picker.telescope.mappings` instead.
          However, be careful as we do not perform any manipulation on the provided strings.
        ''
      )
    ];

  settingsDescription = ''
    Options provided to the `require('yanky').setup` function.

    NOTE: The following local variables are available in the scope:
    ```lua
    local utils = require('yanky.utils')
    local mapping = require('yanky.telescope.mapping') -- Only if `plugins.telescope` is enabled
    ```
  '';
  settingsOptions = {
    ring = {
      history_length = helpers.defaultNullOpts.mkUnsignedInt 100 ''
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

      storage_path = helpers.defaultNullOpts.mkStr {
        __raw = "vim.fn.stdpath('data') .. '/databases/yanky.db'";
      } "Only for sqlite storage.";

      sync_with_numbered_registers = helpers.defaultNullOpts.mkBool true ''
        History can also be synchronized with numbered registers.
        Every time the yank history changes the numbered registers 1 - 9 will be updated to sync
        with the first 9 entries in the yank history.
        See [here](http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/) for an explanation of why we would want do do this.
      '';

      cancel_event =
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

      ignore_registers = helpers.defaultNullOpts.mkListOf types.str [ "_" ] ''
        Define registers to be ignored.
        By default the black hole register is ignored.
      '';

      update_register_on_cycle = helpers.defaultNullOpts.mkBool false ''
        If true, when you cycle through the ring, the contents of the register used to update will
        be updated with the last content cycled.
      '';
    };

    picker = {
      select = {
        action = helpers.defaultNullOpts.mkLuaFn' {
          pluginDefault = null;
          description = ''
            This define the action that should be done when selecting an item in the
            `vim.ui.select` prompt.
            If you let this option to `null`, this will use the default action: put selected item
            after cursor.
          '';
          example = "require('yanky.picker').actions.put('gp')";
        };
      };

      telescope = {
        use_default_mappings = helpers.defaultNullOpts.mkBool true ''
          This define or overrides the mappings available in Telescope.

          If you set this option to `true`, mappings will be merged with default mappings.
        '';

        mappings = helpers.defaultNullOpts.mkAttrsOf' {
          type = with lib.types; either strLuaFn (attrsOf strLuaFn);
          apply =
            mappings:
            helpers.ifNonNull' mappings (
              mapAttrs (
                _: v:
                if isString v then
                  # `mappings.default` is a lua function
                  helpers.mkRaw v
                else
                  # `mappings.<mode>` is an attrs of lua function
                  mapAttrs (_: helpers.mkRaw) v
              ) mappings
            );
          pluginDefault = null;
          description = ''
            This define or overrides the mappings available in Telescope.

            If you set `settings.use_default_mappings` to `true`, mappings will be merged with
            default mappings.
          '';
          example = {
            default = "mapping.put('p')";
            i = {
              "<c-g>" = "mapping.put('p')";
              "<c-k>" = "mapping.put('P')";
              "<c-x>" = "mapping.delete()";
              "<c-r>" = "mapping.set_register(utils.get_default_register())";
            };
            n = {
              p = "mapping.put('p')";
              P = "mapping.put('P')";
              d = "mapping.delete()";
              r = "mapping.set_register(utils.get_default_register())";
            };
          };
        };
      };
    };

    system_clipboard = {
      sync_with_ring = helpers.defaultNullOpts.mkBool true ''
        Yanky can automatically adds to ring history yanks that occurs outside of Neovim.
        This works regardless to your `&clipboard` setting.

        This means, if `&clipboard` is set to `unnamed` and/or `unnamedplus`, if you yank
        something outside of Neovim, you can put it immediately using `p` and it will be added to
        your yank ring.

        If `&clipboard` is empty, if you yank something outside of Neovim, this will be the first
        value you'll have when cycling through the ring.
        Basically, you can do `p` and then `<c-p>` to paste yanked text.

        Note that `clipboard == unnamed` uses the primary selection of the system (see
        `:h clipboard` for more details) which is updated on selection, not on copy/yank.
        Also note that the syncing happens when neovim gains focus.
      '';

      clipboard_register = helpers.defaultNullOpts.mkStr null ''
        Choose the register that is synced with ring (from above).
        If `&clipboard` is empty then `*` is used.
      '';
    };

    highlight = {
      on_put = helpers.defaultNullOpts.mkBool true ''
        Define if highlight put text feature is enabled.
      '';

      on_yank = helpers.defaultNullOpts.mkBool true ''
        Define if highlight yanked text feature is enabled.
      '';

      timer = helpers.defaultNullOpts.mkUnsignedInt 500 ''
        Define the duration of highlight.
      '';
    };

    preserve_cursor_position = {
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

  settingsExample = {
    highlight = {
      on_put = true;
      on_yank = true;
      timer = 500;
    };
    preserve_cursor_position = {
      enabled = true;
    };
    picker = {
      telescope = {
        mappings = {
          default = "mapping.put('p')";
          i = {
            "<c-g>" = "mapping.put('p')";
            "<c-k>" = "mapping.put('P')";
            "<c-x>" = "mapping.delete()";
            "<c-r>" = "mapping.set_register(utils.get_default_register())";
          };
          n = {
            p = "mapping.put('p')";
            P = "mapping.put('P')";
            gp = "mapping.put('gp')";
            gP = "mapping.put('gP')";
            d = "mapping.delete()";
            r = "mapping.set_register(utils.get_default_register())";
          };
        };
      };
    };
  };

  extraOptions = {
    enableTelescope = mkEnableOption "the `yank_history` telescope picker.";
  };

  callSetup = false;
  extraConfig = cfg: {
    # TODO: Added 2024-09-14 remove after 24.11
    plugins.sqlite-lua.enable = mkOverride 1490 true;
    warnings =
      optional
        (cfg.settings.ring.storage == "sqlite" && options.plugins.sqlite-lua.enable.highestPrio == 1490)
        ''
          Nixvim (plugins.yanky) `sqlite-lua` automatic installation is deprecated.
          Please use `plugins.sqlite-lua.enable`.
        '';

    assertions = [
      {
        assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
        message = ''
          Nixvim (plugins.yanky): The telescope integration needs telescope to function as intended
        '';
      }
      {
        assertion = cfg.settings.ring.storage == "sqlite" -> config.plugins.sqlite-lua.enable;
        message = ''
          Nixvim (plugins.yanky): The sqlite storage backend needs `sqlite-lua` to function as intended.
          You can enable it by setting `plugins.sqlite-lua.enable` to `true`.
        '';
      }
    ];

    plugins.yanky.luaConfig.content = ''
      do
        local utils = require('yanky.utils')
        ${optionalString config.plugins.telescope.enable "local mapping = require('yanky.telescope.mapping')"}

        require('yanky').setup(${helpers.toLuaObject cfg.settings})
      end
    '';

    plugins.telescope.enabledExtensions = mkIf cfg.enableTelescope [ "yank_history" ];
  };
}
