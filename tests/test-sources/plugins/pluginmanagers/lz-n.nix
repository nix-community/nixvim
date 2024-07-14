{ pkgs, ... }:
{
  # Empty configuration
  empty = {
    plugins.lz-n.enable = true;
  };

  # Settings
  example = {
    plugins.lz-n = {
      enable = true;
      settings = {
        load = "vim.cmd.packadd";
      };
    };

  };

  test = {
    extraPlugins = with pkgs.vimPlugins; [
      neo-tree-nvim
      telescope-nvim
      onedarker-nvim
      vimtex

    ];
    plugins.lz-n = {
      enable = true;
      plugins = [
        # On keymap with setup function
        {
          name = "neo-tree.nvim";
          keys = [
            {
              mode = [ "n" ];
              key = "<leader>ft";
              action = "<CMD>Neotree toggle<CR>";
              options = {
                desc = "NeoTree toggle";
              };
            }
            {
              mode = [
                "n"
                "v"
              ];
              key = "gft";
              action = "<CMD>Neotree toggle<CR>";
              options = {
                desc = "NeoTree toggle";
              };
            }
          ];
          after = # lua
            ''
              function()
                require("neo-tree").setup()
              end
            '';
        }
        # On command no setup function
        {
          name = "telescope.nvim";
          cmd = [ "Telescope" ];
        }
        # On colorschme
        {
          name = "onedarker.nvim";
          colorscheme = [ "onedarker" ];
        }
        # On filetype with before function
        {
          name = "vimtex";
          ft = [ "plaintex" ];
          before = # lua
            ''
              function()
                vim.g.vimtex_compiler_method = "latexrun"
              end
            '';
        }
      ];
    };
  };

}
