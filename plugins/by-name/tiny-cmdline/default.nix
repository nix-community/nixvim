{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tiny-cmdline";
  package = "tiny-cmdline-nvim";

  maintainers = [ lib.maintainers.zainkergaye ];

  description = "A Neovim plugin that repositions the cmdline as a centered floating window, powered by Neovim's native ui2 system.";

  callSetup = false;
  extraConfig.plugins.tiny-cmdline.luaConfig.content = ''
    	
    		require('vim._core.ui2').enable({})
    		require('tiny-cmdline')
  '';

}
