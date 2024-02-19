{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
  helpers.vim-plugin.mkVimPlugin config {
    name = "copilot-vim";
    originalName = "copilot.vim";
    defaultPackage = pkgs.vimPlugins.copilot-vim;
    globalPrefix = "copilot_";
    deprecateExtraConfig = true;

    options = {
      nodeCommand = mkDefaultOpt {
        global = "node_command";
        type = types.str;
        default = "${pkgs.nodejs-18_x}/bin/node";
        description = "Tell Copilot what `node` binary to use.";
      };

      filetypes = mkDefaultOpt {
        type = with types; attrsOf bool;
        description = ''
          A dictionary mapping file types to their enabled status

          Default: `{}`
        '';
        example = {
          "*" = false;
          python = true;
        };
      };

      proxy = mkDefaultOpt {
        type = types.str;
        description = "Tell Copilot what proxy server to use.";
        example = "localhost:3128";
      };
    };
  }
