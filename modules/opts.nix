{
  lib,
  helpers,
  config,
  ...
}:
with lib; let
  # Added 2024-03-26 (do not remove)
  legacyAliases = [
    {
      from = "options";
      to = "opts";
    }
    {
      from = "globalOptions";
      to = "globalOpts";
    }
    {
      from = "localOptions";
      to = "localOpts";
    }
  ];

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
in {
  options =
    mapAttrs
    (
      _: {description, ...}:
        mkOption {
          type = with types; attrsOf anything;
          default = {};
          inherit description;
        }
    )
    optionsAttrs;

  imports =
    map
    ({
      from,
      to,
    }:
      mkRenamedOptionModule [from] [to])
    legacyAliases;

  config = {
    extraConfigLuaPre =
      concatLines
      (
        mapAttrsToList
        (
          optionName: {
            prettyName,
            luaVariableName,
            luaApi,
            ...
          }: let
            varName = "nixvim_${luaVariableName}";
            optionDefinitions = config.${optionName};
          in
            optionalString
            (optionDefinitions != {})
            ''
              -- Set up ${prettyName} {{{
              do
                local ${varName} = ${helpers.toLuaObject optionDefinitions}

                for k,v in pairs(${varName}) do
                  vim.${luaApi}[k] = v
                end
              end
              -- }}}
            ''
        )
        optionsAttrs
      );
  };
}
