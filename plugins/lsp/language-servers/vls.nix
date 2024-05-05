{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.lsp.servers.vls;
in {
  options.plugins.lsp.servers.vls = {
    autoSetFiletype = mkOption {
      type = types.bool;
      description = ''
        Files with the `.v` extension are not automatically detected as vlang files.
        If this option is enabled, Nixvim will automatically set  the filetype accordingly.
      '';
      default = true;
      example = false;
    };
  };

  config = mkIf cfg.enable {filetype.extension = mkIf cfg.autoSetFiletype {v = "vlang";};};
}
