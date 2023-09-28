{
  config,
  lib,
  ...
}:
with lib; let
  helpers = import ../lib/helpers.nix {inherit lib;};

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

      buffer = helpers.mkNullOrOption types.int ''
        Buffer number for buffer local autocommands |autocmd-buflocal|.
        Cannot be used with `pattern`.
      '';

      description = helpers.mkNullOrOption types.str "A textual description of this autocommand.";

      callback = helpers.mkNullOrOption (types.either types.str helpers.rawType) ''
        A function or a string.
        - if a string, the name of a Vimscript function to call when this autocommand is triggered.
        - Otherwise, a Lua function which is called when this autocommand is triggered.
          Cannot be used with `command`.
          Lua callbacks can return true to delete the autocommand; in addition, they accept a single
          table argument with the following keys:
          - id: (number) the autocommand id
          - event: (string) the name of the event that triggered the autocommand |autocmd-events|
          - group: (number|nil) the autocommand group id, if it exists
          - match: (string) the expanded value of |<amatch>|
          - buf: (number) the expanded value of |<abuf>|
          - file: (string) the expanded value of |<afile>|
          - data: (any) arbitrary data passed to |nvim_exec_autocmds()|

        Example using callback:
        autoCmd = [
          {
            event = [ "BufEnter" "BufWinEnter" ];
            pattern = [ "*.c" "*.h" ];
            callback = { __raw = "function() print('This buffer enters') end"; };
          }
      '';

      command = helpers.defaultNullOpts.mkStr "" ''
        Vim command to execute on event. Cannot be used with `callback`.
      '';

      once = helpers.defaultNullOpts.mkBool false "Run the autocommand only once.";

      nested = helpers.defaultNullOpts.mkBool false "Run nested autocommands.";
    };
  };
in {
  options = {
    autoGroups = mkOption {
      type = types.attrsOf autoGroupOption;
      default = {};
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
      default = [];
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

  config = let
    inherit (config) autoGroups autoCmd;
  in
    mkIf (autoGroups != {} || autoCmd != {}) {
      extraConfigLuaPost =
        (optionalString (autoGroups != {}) ''
          -- Set up autogroups {{
          do
            local __nixvim_autogroups = ${helpers.toLuaObject autoGroups}

            for group_name, options in pairs(__nixvim_autogroups) do
              vim.api.nvim_create_augroup(group_name, options)
            end
          end
          -- }}
        '')
        + (optionalString (autoCmd != []) ''
          -- Set up autocommands {{
          do
            local __nixvim_autocommands = ${helpers.toLuaObject autoCmd}

            for _, autocmd in ipairs(__nixvim_autocommands) do
              vim.api.nvim_create_autocmd(
                autocmd.event,
                {
                  group     = autocmd.group,
                  pattern   = autocmd.pattern,
                  buffer    = autocmd.buffer,
                  desc      = autocmd.description,
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
