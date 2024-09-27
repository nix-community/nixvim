{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "auto-save";
  originalName = "auto-save.nvim";
  package = "auto-save-nvim";

  maintainers = [ lib.maintainers.braindefender ];

  # TODO: introduced 2024-06-21, remove after 24.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    [
      "executionMessage"
      "message"
    ]
    [
      "executionMessage"
      "dim"
    ]
    [
      "executionMessage"
      "cleaningInterval"
    ]
    "triggerEvents"
    "writeAllBuffers"
    "debounceDelay"
  ];

  imports =
    let
      basePluginPath = [
        "plugins"
        "auto-save"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "enableAutoSave" ]) (settingsPath ++ [ "enabled" ]))
      (lib.mkRemovedOptionModule (basePluginPath ++ [ "keymaps" ]) ''
        Use the top-level `keymaps` option to create a keymap that runs :ASToggle

        keymaps = [
          { key = "<leader>s"; action = "<cmd>ASToggle<CR>"; }
        ];
      '')
    ];

  settingsOptions = {
    enabled = defaultNullOpts.mkBool true ''
      Whether to start auto-save when the plugin is loaded.
    '';

    execution_message = {
      enabled = defaultNullOpts.mkBool true ''
        Show execution message after successful auto-save.
      '';

      message =
        defaultNullOpts.mkStr
          {
            __raw = ''
              function()
                return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
              end
            '';
          }
          ''
            The message to print on save.
            This can be a lua function that returns a string.
          '';

      dim = defaultNullOpts.mkNullable (types.numbers.between 0 1) 0.18 "Dim the color of `message`.";

      cleaning_interval = defaultNullOpts.mkUnsignedInt 1250 ''
        Time (in milliseconds) to wait before automatically cleaning MsgArea after displaying
        `message`.
        See `:h MsgArea`.
      '';
    };

    trigger_events = {
      immediate_save =
        defaultNullOpts.mkListOf types.str
          [
            "BufLeave"
            "FocusLost"
          ]
          ''
            Vim events that trigger an immediate save.\
            See `:h events` for events description.
          '';

      defer_save =
        defaultNullOpts.mkListOf types.str
          [
            "InsertLeave"
            "TextChanged"
          ]
          ''
            Vim events that trigger a deferred save (saves after `debounceDelay`).\
            See `:h events` for events description.
          '';

      cancel_defered_save = defaultNullOpts.mkListOf types.str [ "InsertEnter" ] ''
        Vim events that cancel a pending deferred save.\
        See `:h events` for events description.
      '';
    };

    condition = defaultNullOpts.mkLuaFn' {
      pluginDefault = null;
      description = ''
        Function that determines whether to save the current buffer or not.
        - return true: if buffer is ok to be saved
        - return false: if it's not ok to be saved

        In this example, the second argument of `utils.not_in(..., {})`
        determines which filetypes will be ignored by auto-save plugin.

        Buffers that are `nomodifiable` are not saved by default.
      '';
      example = ''
        function(buf)
          local fn = vim.fn
          local utils = require("auto-save.utils.data")

          if utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true
          end
          return false
        end
      '';
    };

    write_all_buffers = defaultNullOpts.mkBool false ''
      Write all buffers when the current one meets `condition`.
    '';

    noautocmd = defaultNullOpts.mkBool false ''
      Do not execute autocmds when saving.
    '';

    lockmarks = defaultNullOpts.mkBool false ''
      Lock marks when saving, see `:h lockmarks` for more details.
    '';

    debounce_delay = defaultNullOpts.mkUnsignedInt 1000 ''
      Saves the file at most every `debounce_delay` milliseconds.
    '';

    debug = defaultNullOpts.mkBool false ''
      Log debug messages to `auto-save.log` file in NeoVim cache directory.
    '';
  };

  settingsExample = {
    condition = ''
      function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if utils.not_in(fn.getbufvar(buf, "&filetype"), {'oil'}) then
          return true
        end
        return false
      end
    '';
    write_all_buffers = true;
    debounce_delay = 1000;
  };
}
