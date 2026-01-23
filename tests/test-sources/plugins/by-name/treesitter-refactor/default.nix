{ pkgs, ... }:
{
  empty = {
    plugins = {
      treesitter = {
        enable = true;
        package = pkgs.vimPlugins.nvim-treesitter-legacy;
      };
      treesitter-refactor.enable = true;
    };
  };

  example = {
    plugins = {
      treesitter = {
        enable = true;
        package = pkgs.vimPlugins.nvim-treesitter-legacy;
      };
      treesitter-refactor = {
        enable = true;

        settings = {
          smart_rename = {
            enable = true;
            keymaps.smart_rename = "grr";
          };
        };
      };
    };
  };
}
