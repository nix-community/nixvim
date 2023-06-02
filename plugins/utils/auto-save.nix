{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.auto-save;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.auto-save =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "auto-save";

      package = helpers.mkPackageOption "auto-save" pkgs.vimPlugins.auto-save-nvim;

      keymaps = {
        silent = mkOption {
          type = types.bool;
          description = "Whether auto-save keymaps should be silent.";
          default = false;
        };

        toggle = helpers.mkNullOrOption types.str "Keymap for running auto-save.";
      };

      enableAutoSave = helpers.defaultNullOpts.mkBool true ''
        Whether to start auto-save when the plugin is loaded.
      '';

      executionMessage = {
        message =
          helpers.defaultNullOpts.mkNullable
          (with types; either str helpers.rawType)
          ''
            {
              __raw = \'\'
                function()
                  return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                end
              \'\';
            }
          ''
          ''
            The message to print en save.
            This can be a lua function that returns a string.
          '';

        dim =
          helpers.defaultNullOpts.mkNullable
          (types.numbers.between 0 1)
          "0.18"
          "Dim the color of `message`.";

        cleaningInterval = helpers.defaultNullOpts.mkInt 1250 ''
          Time (in milliseconds) to wait before automatically cleaning MsgArea after displaying
          `message`.
          See `:h MsgArea`.
        '';
      };

      triggerEvents =
        helpers.defaultNullOpts.mkNullable (with types; listOf str)
        ''["InsertLeave" "TextChanged"]''
        ''
          Vim events that trigger auto-save.
          See `:h events`.
        '';

      condition =
        helpers.defaultNullOpts.mkStr
        ''
          function(buf)
            local fn = vim.fn
            local utils = require("auto-save.utils.data")

            if
              fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
              return true -- met condition(s), can save
            end
            return false -- can't save
          end
        ''
        ''
          Function that determines whether to save the current buffer or not.
          - return true: if buffer is ok to be saved
          - return false: if it's not ok to be saved
        '';

      writeAllBuffers = helpers.defaultNullOpts.mkBool false ''
        Write all buffers when the current one meets `condition`.
      '';

      debounceDelay = helpers.defaultNullOpts.mkInt 135 ''
        Saves the file at most every `debounce_delay` milliseconds.
      '';

      callbacks =
        mapAttrs
        (
          name: desc:
            helpers.mkNullOrOption types.str "The code of the function that runs ${desc}."
        )
        {
          enabling = "when enabling auto-save";
          disabling = "when disabling auto-save";
          beforeAssertingSave = "before checking `condition`";
          beforeSaving = "before doing the actual save";
          afterSaving = "after doing the actual save";
        };
    };

  config = let
    options =
      {
        enabled = cfg.enableAutoSave;
        execution_message = with cfg.executionMessage; {
          inherit message dim;
          cleaning_interval = cleaningInterval;
        };
        trigger_events = cfg.triggerEvents;
        condition =
          helpers.ifNonNull' cfg.condition
          (helpers.mkRaw cfg.condition);
        write_all_buffers = cfg.writeAllBuffers;
        debounce_delay = cfg.debounceDelay;
        callbacks = with cfg.callbacks;
          mapAttrs (name: value: helpers.ifNonNull' value (helpers.mkRaw value)) {
            inherit enabling disabling;
            before_asserting_save = beforeAssertingSave;
            before_saving = beforeSaving;
            after_saving = afterSaving;
          };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('auto-save').setup(${helpers.toLuaObject options})
      '';

      maps.normal = with cfg.keymaps; let
        inherit (cfg.keymaps) silent;
      in
        mkMerge [
          (mkIf (toggle != null) {
            ${toggle} = {
              action = ":ASToggle<CR>";
              inherit silent;
            };
          })
        ];
    };
}
