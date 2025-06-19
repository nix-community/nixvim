{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "scope";
  packPathName = "scope.nvim";
  package = "scope-nvim";
  description = "Seamlessly navigate through buffers within each tab using commands like `:bnext` and `:bprev`.";

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
