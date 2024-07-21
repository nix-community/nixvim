{
  lib,
  helpers,
  config,
  ...
}:
with lib;
let
  optionsAttrs = {
    opts = {
      prettyName = "options";
      luaVariableName = "options";
      luaApi = "opt";
      description = "The configuration options, e.g. line numbers (`vim.opt.*`)";
    };

    globalOpts = {
      prettyName = "global options";
      luaVariableName = "global_options";
      luaApi = "opt_global";
      description = "The configuration global options (`vim.opt_global.*`)";
    };

    localOpts = {
      prettyName = "local options";
      luaVariableName = "local_options";
      luaApi = "opt_local";
      description = "The configuration local options (`vim.opt_local.*`)";
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
  options = mapAttrs (
    _:
    { description, ... }:
    mkOption {
      type = with types; attrsOf anything;
      default = { };
      inherit description;
    }
  ) optionsAttrs;

  # Added 2024-03-29 (do not remove)
  imports = mapAttrsToList (old: new: mkRenamedOptionModule [ old ] [ new ]) {
    options = "opts";
    globalOptions = "globalOpts";
    localOptions = "localOpts";
  };

  config = {
    extraConfigLuaPre =
      let
        content = helpers.concatNonEmptyLines (
          mapAttrsToList (
            optionName:
            {
              prettyName,
              luaVariableName,
              luaApi,
              ...
            }:
            let
              varName = "nixvim_${luaVariableName}";
              optionDefinitions = config.${optionName};
            in
            optionalString (optionDefinitions != { }) ''
              -- Set up ${prettyName} {{{
              do
                local ${varName} = ${helpers.toLuaObject optionDefinitions}

                for k,v in pairs(${varName}) do
                  vim.${luaApi}[k] = v
                end
              end
              -- }}}
            ''
          ) optionsAttrs
        );
      in
      mkIf (content != "") content;
  };
}
