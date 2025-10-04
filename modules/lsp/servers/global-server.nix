{ lib, ... }:
let
  inherit (lib) types;
in
{
  options = {
    enable = lib.mkOption {
      type = types.bool;
      description = "Whether to enable global defaults shared by all servers.";
      default = true;
      example = false;
    };

    name = lib.mkOption {
      type = types.str;
      description = ''
        The name to use for global defaults shared by all servers.

        Supplied to functions like `vim.lsp.config()`.

        Will always be `"*"`.
      '';
      readOnly = true;
    };

    config = lib.mkOption {
      type = with types; attrsOf anything;
      description = ''
        Default configuration shared by all servers.

        Will be merged by neovim using the behaviour of [`vim.tbl_deep_extend()`](https://neovim.io/doc/user/lua.html#vim.tbl_deep_extend()).
      '';
      default = { };
      example = {
        root_markers = [ ".git" ];
        capabilities.textDocument.semanticTokens = {
          multilineTokenSupport = true;
        };
      };
    };
  };

  imports = [
    ./server-renames.nix
  ];

  # Define the read-only `name` here, instead of via `default`, to avoid documenting it twice
  config.name = "*";
}
