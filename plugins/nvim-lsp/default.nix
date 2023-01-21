{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.lsp;
  helpers = (import ../helpers.nix { inherit lib; });
in
{
  imports = [
    ./basic-servers.nix
  ];

  options = {
    plugins.lsp = {
      enable = mkEnableOption "Enable neovim's built-in LSP";

      enabledServers = mkOption {
        type = with types; listOf (oneOf [
          str
          (submodule {
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
          })
        ]);
        description = "A list of enabled LSP servers. Don't use this directly.";
        default = [ ];
      };

      onAttach = mkOption {
        type = types.lines;
        description = "A lua function to be run when a new LSP buffer is attached. The argument `client` and `bufnr` is provided.";
        default = "";
      };

      setupWrappers = mkOption {
        type = with types; listOf (functionTo str);
        description = "Code to be run to wrap the setup args. Takes in an argument containing the previous results, and returns a new string of code.";
        default = [ ];
      };

      preConfig = mkOption {
        type = types.lines;
        description = "Code to be run before loading the LSP. Useful for requiring plugins";
        default = "";
      };

      postConfig = mkOption {
        type = types.lines;
        description = "Code to be run after loading the LSP. This is an internal option";
        default = "";
      };
    };
  };

  config =
    let
      runWrappers = wrappers: s:
        if wrappers == [ ] then s
        else (head wrappers) (runWrappers (tail wrappers) s);
    in
    mkIf cfg.enable {
      extraPlugins = [ pkgs.vimPlugins.nvim-lspconfig ];

      # Enable all LSP servers
      extraConfigLua = ''
        -- LSP {{{
        do
          ${cfg.preConfig}
          local __lspServers = ${helpers.toLuaObject cfg.enabledServers}
          local __lspOnAttach = function(client, bufnr)
            ${cfg.onAttach}
          end

          local __setup = ${runWrappers cfg.setupWrappers "{
            on_attach = __lspOnAttach
          }"}

          for i,server in ipairs(__lspServers) do
            if type(server) == "string" then
              require('lspconfig')[server].setup(__setup)
            else
              local options = ${runWrappers cfg.setupWrappers "server.extraOptions"}

              if options == nil then
                options = __setup
              else
                options = vim.tbl_extend("keep", options, __setup)
              end

              require('lspconfig')[server.name].setup(options)
            end
          end

          ${cfg.postConfig}
        end
        -- }}}
      '';
    };
}
