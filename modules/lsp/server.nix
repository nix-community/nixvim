{ lib, name, ... }:
let
  inherit (lib) types;
in
{
  options = {
    enable = lib.mkEnableOption "the language server";

    name = lib.mkOption {
      type = types.maybeRaw types.str;
      description = ''
        The name of the language server, supplied to functions like `vim.lsp.enable()`.
      '';
      default = name;
      defaultText = lib.literalMD "the attribute name";
    };

    activate = lib.mkOption {
      type = types.bool;
      description = ''
        Whether to call `vim.lsp.enable()` for this server.
      '';
      default = true;
      example = false;
    };

    package = lib.mkOption {
      type = with types; nullOr package;
      default = null;
      description = ''
        Package to use for this language server.

        Alternatively, the language server should be available on your `$PATH`.
      '';
    };

    config = lib.mkOption {
      type = with types; attrsOf anything;
      description = ''
        Configurations for each language server.
      '';
      default = { };
      example = {
        cmd = [
          "clangd"
          "--background-index"
        ];
        root_markers = [
          "compile_commands.json"
          "compile_flags.txt"
        ];
        filetypes = [
          "c"
          "cpp"
        ];
      };
    };
  };
}
