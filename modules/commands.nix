{
  lib,
  helpers,
  config,
  ...
}:
with lib; let
  commandAttributes = types.submodule {
    options = {
      command = mkOption {
        type = types.str;
        description = "The command to run";
      };

      nargs = helpers.mkNullOrOption (types.enum ["0" "1" "*" "?" "+"]) ''
        The number of arguments to expect, see :h command-nargs.
      '';
      complete = helpers.mkNullOrOption (with types; either str helpers.nixvimTypes.rawLua) ''
        Tab-completion behaviour, see :h command-complete.
      '';
      range = helpers.mkNullOrOption (with types; oneOf [bool int (enum ["%"])]) ''
        Whether the command accepts a range, see :h command-range.
      '';
      count = helpers.mkNullOrOption (with types; either bool int) ''
        Whether the command accepts a count, see :h command-range.
      '';
      addr = helpers.mkNullOrOption types.str ''
        Whether special characters relate to other things, see :h command-addr.
      '';
      bang = helpers.defaultNullOpts.mkBool false "Whether this command can take a bang (!)";
      bar = helpers.defaultNullOpts.mkBool false "Whether this command can be followed by a \"|\" and another command";
      register = helpers.defaultNullOpts.mkBool false "The first argument to the command can be an optional register";
      keepscript = helpers.defaultNullOpts.mkBool false "Do not use the location of where the user command was defined for verbose messages, use the location of where the command was invoked";
      force = helpers.defaultNullOpts.mkBool false "Overwrite an existing user command";
      desc = helpers.defaultNullOpts.mkStr "" "A description of the command";

      # TODO: command-preview, need to grab a function here.
    };
  };
in {
  options.userCommands = mkOption {
    type = types.attrsOf commandAttributes;
    default = {};
    description = "A list of user commands to add to the configuration";
  };

  config = let
    cleanupCommand = _: cmd: {
      inherit (cmd) command;
      options = filterAttrs (name: _: name != "command") cmd;
    };
  in
    mkIf (config.userCommands != {}) {
      extraConfigLua = helpers.wrapDo ''
        local cmds = ${helpers.toLuaObject (mapAttrs cleanupCommand config.userCommands)};
        for name,cmd in pairs(cmds) do
          vim.api.nvim_create_user_command(name, cmd.command, cmd.options)
        end
      '';
    };
}
