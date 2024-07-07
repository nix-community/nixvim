{ pkgs, ... }:
{
  # Test basic functionality
  default.module =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter
      ];
      extraConfigLuaPost = ''
        -- Plugins are loadable
        require("lspconfig")
        require("nvim-treesitter")

        -- No separate plugin entries in nvim_list_runtime_paths
        assert(not vim.iter(vim.api.nvim_list_runtime_paths()):any(function(entry)
          return entry:find("treesitter") or entry:find("lspconfig")
        end), "separate plugins are found in runtime")

        -- Help tags are generated
        assert(vim.fn.getcompletion("lspconfig", "help")[1], "no help tags for nvim-lspconfig")
        assert(vim.fn.getcompletion("nvim-treesitter", "help")[1], "no help tags for nvim-treesitter")
      '';
      assertions = [
        {
          assertion = builtins.length config.finalPackage.packpathDirs.myNeovimPackages.start == 1;
          message = "More than one plugin is defined in packpathDirs, expected one plugin pack.";
        }
      ];
    };

  # Test disabled option
  disabled.module =
    { config, ... }:
    {
      performance.combinePlugins.enable = false;
      extraPlugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter
      ];
      assertions = [
        {
          assertion = builtins.length config.finalPackage.packpathDirs.myNeovimPackages.start >= 2;
          message = "Only one plugin is defined in packpathDirs, expected at least two.";
        }
      ];
    };

  # Test that plugin dependencies are handled
  dependencies.module =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pkgs.vimPlugins; [
        # Depends on nvim-cmp
        cmp-dictionary
        # Depends on telescope-nvim which itself depends on plenary-nvim
        telescope-undo-nvim
      ];
      extraConfigLuaPost = ''
        -- Plugins and its dependencies are loadable
        require("cmp_dictionary")
        require("cmp")
        require("telescope-undo")
        require("telescope")
        require("plenary")
      '';
      assertions = [
        {
          assertion = builtins.length config.finalPackage.packpathDirs.myNeovimPackages.start == 1;
          message = "More than one plugin is defined in packpathDirs.";
        }
      ];
    };

  # Test that pathsToLink option works
  paths-to-link.module =
    { config, ... }:
    {
      performance.combinePlugins = {
        enable = true;
        # fzf native library is in build directory
        pathsToLink = [ "/build" ];
      };
      extraPlugins = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
      extraConfigLuaPost = ''
        -- Native library is in runtimepath
        assert(
          vim.api.nvim_get_runtime_file("build/libfzf.so", false)[1],
          "build/libfzf.so is not found in runtimepath"
        )

        -- Native library is loadable
        require("fzf_lib")
      '';
      assertions = [
        {
          assertion = builtins.length config.finalPackage.packpathDirs.myNeovimPackages.start == 1;
          message = "More than one plugin is defined in packpathDirs.";
        }
      ];
    };
}
