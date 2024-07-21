{
  lib,
  helpers,
  config,
  ...
}:
with lib;
{
  options = {
    diagnostics = mkOption {
      type = with types; attrsOf anything;
      default = { };
      description = "The configuration diagnostic options, provided to `vim.diagnostic.config`.";
      example = {
        virtual_text = false;
        virtual_lines.only_current_line = true;
      };
    };
  };

  config = {
    extraConfigLuaPre = mkIf (config.diagnostics != { }) ''
      vim.diagnostic.config(${helpers.toLuaObject config.diagnostics})
    '';
  };
}
