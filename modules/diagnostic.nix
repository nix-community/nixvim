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

  config = {
    extraConfigLuaPre = lib.mkIf (cfg.settings != { }) ''
      vim.diagnostic.config(${lib.nixvim.toLuaObject cfg.settings})
    '';
  };
}
