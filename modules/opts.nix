{ lib, config, ... }:
let
  optionsAttrs = {
    opts = {
      prettyName = "options";
      luaVariableName = "options";
      luaApi = "opt";
      description = ''
        The configuration options, e.g. line numbers (`vim.opt.*`)

        These options are set as global and local.

        See [:h option-list](https://neovim.io/doc/user/quickref/#option-list) for all available options.
      '';
    };

    globalOpts = {
      prettyName = "global options";
      luaVariableName = "global_options";
      luaApi = "opt_global";
      description = ''
        The configuration global options (`vim.opt_global.*`)

        These options are overridden for buffers that have the same option set as a local option.
        If a configuration set in `globalOpts` seems to have no effect, check with `:setglobal <option>?`, `:setlocal <option>?`
        and move the option declaration into `opts`.

        See [:h option-list](https://neovim.io/doc/user/quickref/#option-list) for all available options.
      '';
    };

    localOpts = {
      prettyName = "local options";
      luaVariableName = "local_options";
      luaApi = "opt_local";
      description = ''
        The configuration local options (`vim.opt_local.*`)

        These options are applied to the buffer on startup of neovim with the global options (`opt_global`) as a fallback.
        When opening a new buffer, e.g. with `:new`, the global options are used, making `localOpts` irrelevant for the new buffer.

        See [:h option-list](https://neovim.io/doc/user/quickref/#option-list) for all available options.
      '';
    };

    globals = {
      prettyName = "globals";
      luaVariableName = "globals";
      luaApi = "g";
      description = "Global variables (`vim.g.*`)";
    };
  };
in
{
  options = lib.mapAttrs (
    _:
    { description, ... }:
    lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      inherit description;
    }
  ) optionsAttrs;

  config = {
    extraConfigLuaPre =
      let
        content = lib.nixvim.concatNonEmptyLines (
          lib.mapAttrsToList (
            optionName:
            {
              prettyName,
              luaVariableName,
              luaApi,
              ...
            }:
            let
              varName = "nixvim_${luaVariableName}";
              optionDefinitions = lib.nixvim.toLuaObject config.${optionName};
            in
            lib.optionalString (optionDefinitions != "{ }") ''
              -- Set up ${prettyName} {{{
              do
                local ${varName} = ${optionDefinitions}

                for k,v in pairs(${varName}) do
                  vim.${luaApi}[k] = v
                end
              end
              -- }}}
            ''
          ) optionsAttrs
        );
      in
      lib.mkIf (content != "") (lib.mkOrder 600 content); # Move options to top of file below global table
  };
}
