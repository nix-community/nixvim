{ pkgs, ... }:
{
  programs.nixvim = {
    # This just enables Nixvim.
    # If all you have is this, then there will be little visible difference
    # when compared to just installing NeoVim.
    enable = true;

    keymaps = [
      # Equivalent to nnoremap ; :
      {
        key = ";";
        action = ":";
      }

      # Equivalent to nmap <silent> <buffer> <leader>gg <cmd>Man<CR>
      {
        key = "<leader>gg";
        action = "<cmd>Man<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      # Etc...
    ];

    # We can set the leader key:
    globals.mapleader = ",";

    # We can create maps for every mode!
    # There is .normal, .insert, .visual, .operator, etc!

    # We can also set options:
    opts = {
      tabstop = 4;
      shiftwidth = 4;
      expandtab = false;

      mouse = "a";

      # etc...
    };

    # Of course, we can still use comfy vimscript:
    extraConfigVim = builtins.readFile ./init.vim;
    # Or lua!
    extraConfigLua = builtins.readFile ./init.lua;

    # One of the big advantages of Nixvim is how it provides modules for
    # popular vim plugins
    # Enabling a plugin this way skips all the boring configuration that
    # some plugins tend to require.
    plugins = {
      lightline = {
        enable = true;

        # This is optional - it will default to your enabled colorscheme
        settings = {
          colorscheme = "wombat";

          # This is one of lightline's example configurations
          active = {
            left = [
              [
                "mode"
                "paste"
              ]
              [
                "readonly"
                "filename"
                "modified"
                "helloworld"
              ]
            ];
          };

          component = {
            helloworld = "Hello, world!";
          };
        };
      };

      # Of course, there are a lot more plugins available.
      # You can find an up-to-date list here:
      # https://nixvim.pta2002.com/plugins
    };

    # There is a separate namespace for colorschemes:
    colorschemes.gruvbox.enable = true;

    # What about plugins not available as a module?
    # Use extraPlugins:
    extraPlugins = with pkgs.vimPlugins; [ vim-toml ];
  };
}
