{
  lib,
  pkgs,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "scope";
  originalName = "scope.nvim";
  defaultPackage = pkgs.vimPlugins.scope-nvim;

  maintainers = [ lib.maintainers.insipx ];

  settingsOptions = {
    hooks = {
      pre_tab_enter = lib.nixvim.defaultNullOpts.mkLuaFn null ''
        Run custom logic before entering a tab.
      '';

      post_tab_enter = lib.nixvim.defaultNullOpts.mkLuaFn null ''
        Run custom logic after entering a tab.
      '';

      pre_tab_leave = lib.nixvim.defaultNullOpts.mkLuaFn null ''
        Run custom logic before leaving a tab.
      '';
      post_tab_leave = lib.nixvim.defaultNullOpts.mkLuaFn null ''
        Run custom logic after leaving a tab.
      '';

      pre_tab_close = lib.nixvim.defaultNullOpts.mkLuaFn null ''
        Run custom logic before closing a tab.
      '';

      post_tab_close = lib.nixvim.defaultNullOpts.mkLuaFn null ''
        Run custom logic after closing a tab.
      '';
    };
  };

  settingsExample = {
    settings = {
      pre_tab_enter.__raw = ''
        function()
          print("about to enter tab!")
        end
      '';
    };
  };
}
