{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.plugins.none-ls.sources.formatting.prettierd;
  ts-ls-cfg = config.plugins.lsp.servers.ts_ls;
  opt = options.plugins.none-ls.sources.formatting.prettierd;
  defaultPrio = (lib.mkOptionDefault null).priority;
in
{
  options.plugins.none-ls.sources.formatting.prettierd = {
    disableTsServerFormatter = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Disables the formatting capability of the `ts_ls` language server if it is enabled.
      '';
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.nixvim.mkWarnings "plugins.none-ls.sources.formatting.prettierd" {
      when = opt.disableTsServerFormatter.highestPrio == defaultPrio && ts-ls-cfg.enable;

      message = ''
        You have enabled the `prettierd` formatter in none-ls.
        You have also enabled the `ts_ls` language server which also brings a formatting feature.

        - To disable the formatter built-in the `ts_ls` language server, set
          `plugins.none-ls.sources.formatting.prettierd.disableTsServerFormatter` to `true`.
        - Else, to silence this warning, explicitly set the option to `false`.
      '';
    };

    plugins.lsp.servers.ts_ls =
      lib.mkIf (cfg.enable && ts-ls-cfg.enable && cfg.disableTsServerFormatter)
        {
          onAttach.function = ''
            client.server_capabilities.documentFormattingProvider = false
          '';
        };
  };
}
