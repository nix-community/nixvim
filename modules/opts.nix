{
  lib,
  helpers,
  config,
  ...
}:
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
  options =
    (lib.mapAttrs (
      _:
      { description, ... }:
      lib.mkOption {
        type = with lib.types; attrsOf anything;
        default = { };
        inherit description;
      }
    ) optionsAttrs)
    // {
      globalsPre = lib.mkOption {
        type = lib.types.lines;
        default = "";
        internal = true;
      };

      globalsPost = lib.mkOption {
        type = lib.types.lines;
        default = "";
        internal = true;
      };
    };

  # Added 2024-03-29 (do not remove)
  imports = lib.mapAttrsToList (old: new: lib.mkRenamedOptionModule [ old ] [ new ]) {
    options = "opts";
    globalOptions = "globalOpts";
    localOptions = "localOpts";
  };

  config = {
    extraConfigLuaPre =
      let
        content = helpers.concatNonEmptyLines (
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
              optionDefinitions = helpers.toLuaObject config.${optionName};
              ifGlobals = lib.optionalString (optionName == "globals");
            in
            lib.optionalString (optionDefinitions != "{ }") (
              ''
                -- Set up ${prettyName} {{{
              ''
              + (ifGlobals config.globalsPre)
              + ''
                do
                  local ${varName} = ${optionDefinitions}

                  for k,v in pairs(${varName}) do
                    vim.${luaApi}[k] = v
                  end
                end
              ''
              + (ifGlobals config.globalsPost)
              + ''
                -- }}}
              ''
            )
          ) optionsAttrs
        );
      in
      lib.mkIf (content != "") (lib.mkOrder 600 content); # Move options to top of file below global table
  };
}
