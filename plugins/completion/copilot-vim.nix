{
  lib,
  pkgs,
  ...
} @ args:
with lib;
  (
    with (import ../helpers.nix {inherit lib;}).vim-plugin;
      mkVimPlugin args {
        name = "copilot-vim";
        description = "copilot.vim";
        package = pkgs.vimPlugins.copilot-vim;
        globalPrefix = "copilot_";

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
  )
  // {
    imports = [
      (lib.mkRenamedOptionModule ["plugins" "copilot"] ["plugins" "copilot-vim"])
    ];
  }
