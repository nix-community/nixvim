{ pkgs, ... }:
let
  pluginCount = pkg: type: builtins.length pkg.packpathDirs.myNeovimPackages.${type};
in
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
          assertion = pluginCount config.finalPackage "start" == 1;
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
          assertion = pluginCount config.finalPackage "start" >= 2;
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
          assertion = pluginCount config.finalPackage "start" == 1;
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
          assertion = pluginCount config.finalPackage "start" == 1;
          message = "More than one plugin is defined in packpathDirs.";
        }
      ];
    };

  # Test that plugin python3 dependencies are handled
  python-dependencies.module =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pkgs.vimPlugins; [
        # No python3 dependencies
        plenary-nvim
        # Duplicate python3 dependencies
        (nvim-lspconfig.overrideAttrs { passthru.python3Dependencies = ps: [ ps.pyyaml ]; })
        (nvim-treesitter.overrideAttrs { passthru.python3Dependencies = ps: [ ps.pyyaml ]; })
        # Another python3 dependency
        (nvim-cmp.overrideAttrs { passthru.python3Dependencies = ps: [ ps.requests ]; })
      ];
      extraConfigLuaPost = ''
        -- Python modules are importable
        vim.cmd.py3("import yaml")
        vim.cmd.py3("import requests")
      '';
      assertions = [
        {
          assertion = pluginCount config.finalPackage "start" == 1;
          message = "More than one plugin is defined in packpathDirs.";
        }
      ];
    };

  # Test that optional plugins are handled
  optional-plugins.module =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pkgs.vimPlugins; [
        # Start plugins
        plenary-nvim
        nvim-lspconfig
        # Optional plugin
        {
          plugin = nvim-treesitter;
          optional = true;
        }
        # Optional plugin with dependency on plenary-nvim
        # Dependencies should not be duplicated
        {
          plugin = telescope-nvim;
          optional = true;
        }
      ];
      extraConfigLuaPost = ''
        -- Start plugins are loadable
        require("plenary")
        require("lspconfig")

        -- Opt plugins are not loadable
        local ok = pcall(require, "nvim-treesitter")
        assert(not ok, "nvim-treesitter plugin is loadable")
        ok = pcall(require, "telescope")
        assert(not ok, "telescope-nvim plugin is loadable")

        -- Load plugins
        vim.cmd.packadd("nvim-treesitter")
        vim.cmd.packadd("telescope.nvim")

        -- Now opt plugins are loadable
        require("nvim-treesitter")
        require("telescope")

        -- Only one copy of plenary-nvim should be available
        assert(
          #vim.api.nvim_get_runtime_file("lua/plenary/init.lua", true) == 1,
          "plenary-nvim is duplicated"
        )
      '';
      assertions = [
        {
          assertion = pluginCount config.finalPackage "start" == 1;
          message = "More than one start plugin is defined in packpathDirs";
        }
        {
          assertion = pluginCount config.finalPackage "opt" == 2;
          message = "Less than two opt plugins are defined in packpathDirs";
        }
      ];
    };

  # Test that plugin configs are handled
  configs.module =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pkgs.vimPlugins; [
        # A plugin without config
        plenary-nvim
        # Plugins with configs
        {
          plugin = nvim-treesitter;
          config = "let g:treesitter_config = 1";
        }
        {
          plugin = nvim-lspconfig;
          config = "let g:lspconfig_config = 1";
        }
        # Optional plugin with config
        {
          plugin = telescope-nvim;
          optional = true;
          config = "let g:telescope_config = 1";
        }
      ];
      extraConfigLuaPost = ''
        -- Plugins are loadable
        require("plenary")
        require("nvim-treesitter")
        require("lspconfig")

        -- Configs are evaluated
        assert(vim.g.treesitter_config == 1, "nvim-treesitter config isn't evaluated")
        assert(vim.g.lspconfig_config == 1, "nvim-lspconfig config isn't evaluated")
        assert(vim.g.telescope_config == 1, "telescope-nvim config isn't evaluated")
      '';
      assertions = [
        {
          assertion = pluginCount config.finalPackage "start" == 1;
          message = "More than one start plugin is defined in packpathDirs";
        }
      ];
    };
}
