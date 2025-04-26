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
    config = lib.mkOption {
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
    (lib.mkRenamedOptionModule [ "diagnostics" ] [ "diagnostic" "config" ])
  ];

  config = {
    extraConfigLuaPre = lib.mkIf (cfg.config != { }) ''
      vim.diagnostic.config(${lib.nixvim.toLuaObject cfg.config})
    '';
  };
}
