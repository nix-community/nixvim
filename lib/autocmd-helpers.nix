{
  lib,
  nixvimOptions,
  nixvimTypes,
}:
with lib; rec {
  autoGroupOption = types.submodule {
    options = {
      clear = mkOption {
        type = types.bool;
        description = "Clear existing commands if the group already exists.";
        default = true;
      };
    };
  };

  autoCmdOptions = {
    event = nixvimOptions.mkNullOrOption (with types; either str (listOf str)) ''
      The event or events to register this autocommand.
    '';

    group = nixvimOptions.mkNullOrOption (with types; either str int) ''
      The autocommand group name or id to match against.
    '';

    pattern = nixvimOptions.mkNullOrOption (with types; either str (listOf str)) ''
      Pattern or patterns to match literally against.
    '';

    buffer = nixvimOptions.mkNullOrOption types.int ''
      Buffer number for buffer local autocommands |autocmd-buflocal|.
      Cannot be used with `pattern`.
    '';

    # Introduced early October 2023.
    # TODO remove in early December 2023.
    description = nixvimOptions.mkNullOrOption types.str ''
      DEPRECATED, please use `desc`.
    '';

    desc = nixvimOptions.mkNullOrOption types.str ''
      A textual description of this autocommand.
    '';

    callback = nixvimOptions.mkNullOrOption (with types; either str nixvimTypes.rawLua) ''
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

    command = nixvimOptions.defaultNullOpts.mkStr "" ''
      Vim command to execute on event. Cannot be used with `callback`.
    '';

    once = nixvimOptions.defaultNullOpts.mkBool false "Run the autocommand only once.";

    nested = nixvimOptions.defaultNullOpts.mkBool false "Run nested autocommands.";
  };

  autoCmdOption = types.submodule {
    options = autoCmdOptions;
  };
}
