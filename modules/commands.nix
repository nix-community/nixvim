{ lib, config, ... }:
let
  commandAttributes = lib.types.submodule {
    options = {
      command = lib.mkOption {
        type = with lib.types; either str rawLua;
        description = "The command to run.";
      };

      nargs =
        lib.nixvim.mkNullOrOption
          (lib.types.enum [
            0
            1
            "*"
            "?"
            "+"
          ])
          ''
            The number of arguments to expect, see :h command-nargs.
          '';
      complete = lib.nixvim.mkNullOrOption (with lib.types; either str rawLua) ''
        Tab-completion behaviour, see :h command-complete.
      '';
      range =
        lib.nixvim.mkNullOrOption
          (
            with lib.types;
            oneOf [
              bool
              int
              (enum [ "%" ])
            ]
          )
          ''
            Whether the command accepts a range, see :h command-range.
          '';
      count = lib.nixvim.mkNullOrOption (with lib.types; either bool int) ''
        Whether the command accepts a count, see :h command-range.
      '';
      addr = lib.nixvim.mkNullOrOption lib.types.str ''
        Whether special characters relate to other things, see :h command-addr.
      '';
      bang = lib.nixvim.defaultNullOpts.mkBool false "Whether this command can take a bang (!).";
      bar = lib.nixvim.defaultNullOpts.mkBool false "Whether this command can be followed by a \"|\" and another command.";
      register = lib.nixvim.defaultNullOpts.mkBool false "The first argument to the command can be an optional register.";
      keepscript = lib.nixvim.defaultNullOpts.mkBool false "Do not use the location of where the user command was defined for verbose messages, use the location of where the command was invoked.";
      force = lib.nixvim.defaultNullOpts.mkBool false "Overwrite an existing user command.";
      desc = lib.nixvim.defaultNullOpts.mkStr "" "A description of the command.";

      # TODO: command-preview, need to grab a function here.
    };
  };
in
{
  options.userCommands = lib.mkOption {
    type = lib.types.attrsOf commandAttributes;
    default = { };
    description = "A list of user commands to add to the configuration.";
  };

  config =
    let
      cleanupCommand = _: cmd: {
        inherit (cmd) command;
        options = lib.filterAttrs (name: _: name != "command") cmd;
      };
    in
    lib.mkIf (config.userCommands != { }) {
      extraConfigLua = lib.nixvim.wrapDo ''
        local cmds = ${lib.nixvim.toLuaObject (lib.mapAttrs cleanupCommand config.userCommands)};
        for name,cmd in pairs(cmds) do
          vim.api.nvim_create_user_command(name, cmd.command, cmd.options or {})
        end
      '';
    };
}
