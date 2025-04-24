{
  lib,
  helpers,
  config,
  ...
}:
{
  options = {
    diagnostics = lib.mkOption {
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
    extraConfigLuaPre = lib.mkIf (config.diagnostics != { }) ''
      vim.diagnostic.config(${lib.nixvim.toLuaObject config.diagnostics})
    '';
  };
}
