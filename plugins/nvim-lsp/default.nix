{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.lsp;
  helpers = (import ../helpers.nix { inherit lib; });
in
{
  imports = [
    ./clangd.nix
    ./rust-analyzer.nix
    ./rnix-lsp.nix
  ];

  options = {
    programs.nixvim.plugins.lsp = {
      enable = mkEnableOption "Enable neovim's built-in LSP";

      enabledServers = mkOption {
        type = with types; listOf (oneOf [str (submodule {
          options = {
            name = mkOption {
              type = str;
              description = "The server's name";
            };

            extraOptions = mkOption {
              type = attrs;
              description = "Extra options for the server";
            };
          };
        })]);
        description = "A list of enabled LSP servers. Don't use this directly.";
        default = [];
      };

      onAttach = mkOption {
        type = types.lines;
        description = "A lua function to be run when a new LSP buffer is attached. The argument `client` is provided.";
        default = "";
      };

      capabilities = mkOption {
        type = types.lines;
        description = "A lua function defining the capabilities of a new LSP buffer.";
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.nvim-lspconfig ];

      # Enable all LSP servers
      extraConfigLua = ''
        -- LSP {{{
        local __lspServers = ${helpers.toLuaObject cfg.enabledServers}
        local __lspOnAttach = function(client)
          ${cfg.onAttach}
        end
        local __lspCapabilities = function
          ${cfg.capabilities}
        end

        for i,server in ipairs(__lspServers) do
          if type(server) == "string" then
            require('lspconfig')[server].setup {
              on_attach = __lspOnAttach
              capabilities = __lspCapabilities
            }
          else
            require('lspconfig')[server.name].setup(server.extraOptions)
          end
        end
        -- }}}
      '';
    };
  };
}
