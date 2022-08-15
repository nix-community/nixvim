{ pkgs, lib, ... }@attrs:

let
  helpers = import ../helpers.nix { inherit lib; };
in with helpers; with lib; with pkgs.vimExtraPlugins; 
mkPlugin attrs {
  name = "focus";
  description = "Enable focus.nvim";
  extraPlugins = [ 
    focus-nvim
  ];

  extraConfigLua = "require('focus').setup {}";

}
#   options.programs.nixvim.plugins.focus = {
#     enable = mkEnableOption "Enable focus.nvim";
#   };

#   config = mkIf cfg.enable {
#     programs.nixvim = {
#       extraPlugins = [
#         pkgs.vimExtraPlugins.focus-nvim
#       ];

#       extraConfigLua = ''
#         require('focus').setup{ }
#       '' ;
#     };
#   };
# }
