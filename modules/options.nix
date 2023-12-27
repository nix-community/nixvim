{
  lib,
  helpers,
  config,
  ...
}:
with lib; {
  options = {
    options = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = "The configuration options, e.g. line numbers";
    };

    globalOptions = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = "The configuration global options";
    };

    localOptions = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = "The configuration local options";
    };

    globals = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = "Global variables";
    };
  };

  config = {
    extraConfigLuaPre =
      optionalString (config.globals != {}) ''
        -- Set up globals {{{
        do
          local nixvim_globals = ${helpers.toLuaObject config.globals}

          for k,v in pairs(nixvim_globals) do
            vim.g[k] = v
          end
        end
        -- }}}
      ''
      + optionalString (config.options != {}) ''
        -- Set up options {{{
        do
          local nixvim_options = ${helpers.toLuaObject config.options}

          for k,v in pairs(nixvim_options) do
            vim.opt[k] = v
          end
        end
        -- }}}
      ''
      + optionalString (config.localOptions != {}) ''
        -- Set up local options {{{
        do
          local nixvim_local_options = ${helpers.toLuaObject config.localOptions}

          for k,v in pairs(nixvim_local_options) do
            vim.opt_local[k] = v
          end
        end
        -- }}}
      ''
      + optionalString (config.globalOptions != {}) ''
        -- Set up global options {{{
        do
          local nixvim_global_options = ${helpers.toLuaObject config.globalOptions}

          for k,v in pairs(nixvim_global_options) do
            vim.opt_global[k] = v
          end
        end
        -- }}}
      '';
  };
}
