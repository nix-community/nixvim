let
  /*
    Transform plugins into attrset and set optional to true
    This installs the plugin files to {runtimepath}/pack/opt, instead of {runtimepath}/pack/start.
    Plugins in pack/opt are not loaded on startup, but can be later loaded with `:packadd {name}` or `require("lz.n").load({name})`

    See `nixpkgs/pkgs/applications/editors/neovim/utils.nix`
    See `nixpkgs/pkgs/applications/editors/vim/plugins/vim-utils.nix`
  */
  optionalPlugins = map (x: (if x ? plugin then x else { plugin = x; }) // { optional = true; });
in
{
  # Empty configuration
  empty = {
    plugins.lz-n.enable = true;
  };

  # Empty configuration
  defaults = {
    plugins.lz-n = {
      enable = true;
      settings = {
        load.__raw = "vim.cmd.packadd";
      };
    };
  };

  # single-plugin and priority of plugins.lz-n.settings to globals.lz-n
  example-single-plugin =
    { pkgs, lib, ... }:
    {
      extraPlugins = optionalPlugins [ pkgs.vimPlugins.neo-tree-nvim ];

      plugins.lz-n = {
        enable = true;
        settings = {
          load = lib.mkDefault "vim.cmd.packadd";
        };
        plugins = [
          # enabled, on keys as rawLua
          {
            __unkeyed-1 = "neo-tree.nvim";
            enabled = ''
              function()
              return true
              end
            '';
            keys = [
              {
                __unkeyed-1 = "<leader>ft";
                __unkeyed-2 = "<CMD>Neotree toggle<CR>";
                desc = "NeoTree toggle";
              }
            ];
            after = # lua
              ''
                function()
                  require("neo-tree").setup()
                end
              '';
          }
        ];
      };
    };

  example-multiple-plugin =
    { pkgs, ... }:
    {
      extraPlugins =
        with pkgs.vimPlugins;
        [ onedarker-nvim ]
        ++ (optionalPlugins [
          neo-tree-nvim
          dial-nvim
          vimtex
          telescope-nvim
          nvim-biscuits
          crates-nvim
        ]);

      plugins.treesitter.enable = true;

      plugins.lz-n = {
        enable = true;
        plugins = [
          # enabled, on keys
          {
            __unkeyed-1 = "neo-tree.nvim";
            enabled = ''
              function()
              return true
              end
            '';
            keys = [
              {
                __unkeyed-1 = "<leader>ft";
                __unkeyed-2 = "<CMD>Neotree toggle<CR>";
                desc = "NeoTree toggle";
              }
            ];
            after = # lua
              ''
                function()
                  require("neo-tree").setup()
                end
              '';
          }
          # on keys as list of str and rawLua
          {
            __unkeyed-1 = "dial.nvim";
            keys = [
              "<C-a>"
              { __raw = "{ '<C-x>'; mode = 'n' }"; }
            ];
          }
          # beforeAll, before, on filetype
          {
            __unkeyed-1 = "vimtex";
            ft = [ "plaintex" ];
            beforeAll = # lua
              ''
                function()
                  vim.g.vimtex_compiler_method = "latexrun"
                end
              '';
            before = # lua
              ''
                function()
                  vim.g.vimtex_compiler_method = "latexmk"
                end
              '';
          }
          # On event
          {
            __unkeyed-1 = "nvim-biscuits";
            event.__raw = "{ 'BufEnter *.lua' }";
            after.__raw = ''
              function()
              require('nvim-biscuits').setup({})
              end
            '';
          }
          # On command no setup function, priority
          {
            __unkeyed-1 = "telescope.nvim";
            cmd = [ "Telescope" ];
            priority = 500;
          }
          # On colorschme
          {
            __unkeyed-1 = "onedarker.nvim";
            colorscheme = [ "onedarker" ];
          }
          # raw value
          {
            __raw = ''
              {
                  "crates.nvim",
                  ft = "toml",
              }
            '';
          }
        ];
      };
    };

  example-keymap-string =
    { pkgs, ... }:
    {
      extraPlugins = optionalPlugins [ pkgs.vimPlugins.nvim-tree-lua ];

      plugins.lz-n = {
        enable = true;
        plugins = [
          {
            __unkeyed-1 = "nvim-tree.lua";
            enabled = ''
              function()
                return true
              end
            '';
            after = # lua
              ''
                function()
                  require("nvim-tree").setup({})
                end
              '';
          }
        ];

        keymaps = [
          {
            action = "<CMD>NvimTreeToggle<CR>";
            key = "<leader>ft";
            mode = "";
            options.desc = "NvimTree toggle";
            plugin = "nvim-tree.lua";
          }
        ];
      };
    };

  example-keymap-spec =
    { pkgs, ... }:
    {
      extraPlugins = optionalPlugins [ pkgs.vimPlugins.neo-tree-nvim ];

      plugins.lz-n = {
        enable = true;

        keymaps = [
          {
            action = "<CMD>Neotree toggle<CR>";
            key = "<leader>ft";
            mode = "";
            options.desc = "NeoTree toggle";
            plugin = {
              __unkeyed-1 = "neo-tree.nvim";
              enabled = ''
                function()
                  return true
                end
              '';
              after = # lua
                ''
                  function()
                    require("neo-tree").setup()
                  end
                '';
            };
          }
        ];
      };
    };
}
