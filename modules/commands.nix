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

      preview = lib.nixvim.mkNullOrLuaFn' {
        description = ''
          Preview handler for `'inccommand'`, see `:h command-preview`.

          The function is called with `opts`, `ns`, and `buf` arguments. `opts` has the same form as
          `nvim_create_user_command()` callbacks, `ns` is the preview highlight namespace, and `buf`
          is the preview buffer for `inccommand=split` or `nil` for `inccommand=nosplit`.

          Return `0` to show no preview, `1` to show a preview without opening the preview window, or
          `2` to open the preview window when `inccommand=split`.
        '';
        example = ''
          function(opts, ns, buf)
            if buf then
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, { opts.args })
            end
            return 2
          end
        '';
      };
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
