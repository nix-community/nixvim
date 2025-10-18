{
  lib,
  config,
  ...
}:
{
  options = {
    autoGroups = lib.mkOption {
      type = lib.types.attrsOf lib.nixvim.autocmd.autoGroupOption;
      default = { };
      description = "augroup definitions";
      example = {
        my_augroup = {
          clear = true;
        };
      };
    };

    autoCmd = lib.mkOption {
      type = lib.types.listOf lib.nixvim.autocmd.autoCmdOption;
      default = [ ];
      description = "autocmd definitions";
      example = [
        {
          event = [
            "BufEnter"
            "BufWinEnter"
          ];
          pattern = [
            "*.c"
            "*.h"
          ];
          command = "echo 'Entering a C or C++ file'";
        }
      ];
    };
  };

  config =
    let
      inherit (config) autoGroups autoCmd;
    in
    lib.mkIf (autoGroups != { } || autoCmd != [ ]) {
      # Introduced early October 2023.
      # TODO remove in early December 2023.
      assertions = [
        {
          assertion = lib.all (x: x.description == null) autoCmd;
          message = ''
            RENAMED OPTION: `autoCmd[].description` has been renamed `autoCmd[].desc`.
            Please update your configuration.
          '';
        }
      ];

      extraConfigLuaPost =
        (lib.optionalString (autoGroups != { }) ''
          -- Set up autogroups {{
          do
            local __nixvim_autogroups = ${lib.nixvim.toLuaObject autoGroups}

            for group_name, options in pairs(__nixvim_autogroups) do
              vim.api.nvim_create_augroup(group_name, options)
            end
          end
          -- }}
        '')
        + (lib.optionalString (autoCmd != [ ]) ''
          -- Set up autocommands {{
          do
            local __nixvim_autocommands = ${lib.nixvim.toLuaObject autoCmd}

            for _, autocmd in ipairs(__nixvim_autocommands) do
              vim.api.nvim_create_autocmd(
                autocmd.event,
                {
                  group     = autocmd.group,
                  pattern   = autocmd.pattern,
                  buffer    = autocmd.buffer,
                  desc      = autocmd.desc,
                  callback  = autocmd.callback,
                  command   = autocmd.command,
                  once      = autocmd.once,
                  nested    = autocmd.nested
                }
              )
            end
          end
          -- }}
        '');
    };
}
