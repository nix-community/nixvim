{
  lib,
  config,
  ...
}:
let
  cfg = config.diagnostic;
in
{
  options.diagnostic = {
    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      description = "The configuration diagnostic options, provided to `vim.diagnostic.config`.";
      example = {
        virtual_text = false;
        virtual_lines.current_line = true;
      };
    };
  };

  imports = [
    # TODO: Added 2025-04-26; remove after 25.05
    (lib.mkRenamedOptionModule [ "diagnostics" ] [ "diagnostic" "settings" ])

    # TODO: Added 2025-04-30;
    # The above rename initially renamed `diagnostics` -> `diagnostic.config`
    # This rename covers any users who migrated between 2025-04-26 and 2025-04-30
    # We can consider removing this rename earlier than usual
    (lib.mkRenamedOptionModule [ "diagnostic" "config" ] [ "diagnostic" "settings" ])
  ];

  config = {
    extraConfigLuaPre = lib.mkIf (cfg.settings != { }) ''
      vim.diagnostic.config(${lib.nixvim.toLuaObject cfg.settings})
    '';
  };
}
