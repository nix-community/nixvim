{ config, lib, ... }:
with lib;
let
  helpers = import ../plugins/helpers.nix { inherit lib; };

  autoCmdOption = types.submodule {
    options = {
      event = mkOption {
        type = types.oneOf [
          types.str
          (types.listOf types.str)
        ];
        description = "The event or events to register this autocommand.";
      };

      group = mkOption {
        type = types.nullOr (types.oneOf [
          types.str
          types.int
        ]);
        description = "The autocommand group name or id to match against.";
        default = null;
      };

      pattern = mkOption {
        type = types.nullOr (types.oneOf [
          types.str
          (types.listOf types.str)
        ]);
        description = "Pattern or patterns to match literally against.";
        default = null;
      };

      buffer = mkOption {
        type = types.nullOr types.int;
        description = "Buffer number for buffer local autocommands |autocmd-buflocal|. Cannot be used with <pattern>.";
        default = null;
      };

      description = mkOption {
        type = types.nullOr types.str;
        description = "A textual description of this autocommand.";
        default = null;
      };

      callback = mkOption {
        type = types.nullOr types.str;
        description = "The name of a Vimscript function to call when this autocommand is triggered. Cannot be used with <command>.";
        default = null;
      };

      command = mkOption {
        type = types.nullOr types.str;
        description = "Vim command to execute on event. Cannot be used with <callback>";
        default = null;
      };

      once = mkOption {
        type = types.nullOr types.bool;
        description = "Run the autocommand only once";
        default = null;
      };

      nested = mkOption {
        type = types.nullOr types.bool;
        description = "Run nested autocommands.";
        default = null;
      };
    };
  };
in
{
  options.autoCmd = mkOption {
    type = types.listOf autoCmdOption;
    default = [ ];
    description = "autocmd definitions";
    example = ''
      autoCmd = [
        {
          event = [ "BufEnter" "BufWinEnter" ];
          pattern = [ "*.c" "*.h" ];
          command = "echo 'Entering a C or C++ file'";
        }
      ];
    '';
  };

  config = {
    extraConfigLua = optionalString (config.autoCmd != [ ]) ''
      -- Set up autocommands {{{
      do
        local __nixvim_autocommands = ${helpers.toLuaObject config.autoCmd}

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
      -- }}}
    '';
  };
}
