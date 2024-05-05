{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.none-ls.sources.formatting.prettier;
  tsserver-cfg = config.plugins.lsp.servers.tsserver;
in {
  options.plugins.none-ls.sources.formatting.prettier = {
    disableTsServerFormatter = mkOption {
      type = with types; nullOr bool;
      description = ''
        Disables the formatting capability of the `tsserver` language server if it is enabled.
      '';
      default = null;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    warnings = optional ((cfg.disableTsServerFormatter == null) && tsserver-cfg.enable) ''
      You have enabled the `prettier` formatter in none-ls.
      You have also enabled the `tsserver` language server which also brings a formatting feature.

      - To disable the formatter built-in the `tsserver` language server, set
        `plugins.none-ls.sources.formatting.prettier.disableTsServerFormatter` to `true`.
      - Else, to silence this warning, explicitly set the option to `false`.
    '';

    plugins.lsp.servers.tsserver =
      mkIf
      (
        cfg.enable
        && tsserver-cfg.enable
        && (isBool cfg.disableTsServerFormatter)
        && cfg.disableTsServerFormatter
      )
      {
        onAttach.function = ''
          client.server_capabilities.documentFormattingProvider = false
        '';
      };
  };
}
