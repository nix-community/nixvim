{ config, lib, ... }:
with lib;
let
  helpers = import ../lib/helpers.nix { inherit lib; };

  autoGroupOption = types.submodule {
    options = {
      clear = mkOption {
        type = types.bool;
        description = "Clear existing commands if the group already exists.";
        default = true;
      };
    };
  };

  autoCmdOption = types.submodule {
    options = {
      event = helpers.mkNullOrOption (types.either types.str (types.listOf types.str)) ''
        The event or events to register this autocommand.
      '';

      group = helpers.mkNullOrOption (types.either types.str types.int) ''
        The autocommand group name or id to match against.
      '';

      pattern = helpers.mkNullOrOption (types.either types.str (types.listOf types.str)) ''
        Pattern or patterns to match literally against.
      '';

      buffer = helpers.defaultNullOpts.mkInt null ''
        Buffer number for buffer local autocommands |autocmd-buflocal|.
        Cannot be used with <pattern>.
      '';

      description = helpers.defaultNullOpts.mkStr "" "A textual description of this autocommand.";

      callback = helpers.defaultNullOpts.mkStr null ''
        The name of a Vimscript function to call when this autocommand is triggered. Cannot be used with <command>.
      '';

      command = helpers.defaultNullOpts.mkStr null ''
        Vim command to execute on event. Cannot be used with <callback>
      '';

      once = helpers.defaultNullOpts.mkBool false "Run the autocommand only once";

      nested = helpers.defaultNullOpts.mkBool false "Run nested autocommands.";
    };
  };

in
{
  options = {
    autoGroups = mkOption {
      type = types.attrsOf autoGroupOption;
      default = { };
      description = "augroup definitions";
      example = ''
        autoGroups = {
          my_augroup = {
            clear = true;
          }
        };
      '';
    };

    autoCmd = mkOption {
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
  };

  config = mkIf (config.autoGroups != { } || config.autoCmd != { }) {
    extraConfigLuaPost = (optionalString (config.autoGroups != { }) ''
      -- Set up autogroups {{
      do
        local __nixvim_autogroups = ${helpers.toLuaObject config.autoGroups}

        for group_name, options in pairs(__nixvim_autogroups) do
          vim.api.nvim_create_augroup(group_name, options)
        end
      end
      -- }}
    '') +
    (optionalString (config.autoCmd != [ ]) ''
      -- Set up autocommands {{
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
      -- }}
    '');
  };
}
