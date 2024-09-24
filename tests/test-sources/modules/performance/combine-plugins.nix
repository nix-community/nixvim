{ pkgs, ... }:
let
  inherit (pkgs) lib;

  # Count plugins of given type excluding 'build.extraFiles'
  pluginCount =
    pkg: files: type:
    builtins.length (builtins.filter (p: p != files) pkg.packpathDirs.myNeovimPackages.${type});
in
{
  # Test basic functionality
  default =
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
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 1;
          message = "More than one plugin is defined in packpathDirs, expected one plugin pack.";
        }
      ];
    };

  # Test disabled option
  disabled =
    { config, ... }:
    {
      performance.combinePlugins.enable = false;
      extraPlugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter
      ];
      assertions = [
        {
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" >= 2;
          message = "Only one plugin is defined in packpathDirs, expected at least two.";
        }
      ];
    };

  # Test that plugin dependencies are handled
  dependencies =
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
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 1;
          message = "More than one plugin is defined in packpathDirs.";
        }
      ];
    };

  # Test that pathsToLink option works
  paths-to-link =
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
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 1;
          message = "More than one plugin is defined in packpathDirs.";
        }
      ];
    };

  # Test that plugin python3 dependencies are handled
  python-dependencies =
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
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 1;
          message = "More than one plugin is defined in packpathDirs.";
        }
      ];
    };

  # Test that optional plugins are handled
  optional-plugins =
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
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 1;
          message = "More than one start plugin is defined in packpathDirs";
        }
        {
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "opt" == 2;
          message = "Less than two opt plugins are defined in packpathDirs";
        }
      ];
    };

  # Test that plugin configs are handled
  configs =
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
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 1;
          message = "More than one start plugin is defined in packpathDirs";
        }
      ];
    };

  # Test that config.build.extraFiles is not combined
  files-plugin =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pkgs.vimPlugins; [
        nvim-treesitter
        vim-nix
      ];
      # Ensure that build.extraFiles is added extraPlugins
      wrapRc = true;
      # Extra user files colliding with plugins
      extraFiles = {
        "ftplugin/nix.vim".text = "let b:test = 1";
        "queries/nix/highlights.scm".text = ''
          ;; extends
          (comment) @comment
        '';
      };
      # Another form of user files
      files = {
        "ftdetect/nix.vim" = {
          autoCmd = [
            {
              event = [
                "BufRead"
                "BufNewFile"
              ];
              pattern = "*.nix";
              command = "setf nix";
            }
          ];
        };
      };
      extraConfigLuaPost = ''
        local function get_paths(name)
          local paths = vim.api.nvim_get_runtime_file(name, true);
          return vim.tbl_filter(function(v)
            -- Skip paths from neovim runtime
            return not v:find("/nvim/runtime/")
          end, paths)
        end

        -- Both plugin and user version are available
        assert(#get_paths("ftplugin/nix.vim") == 2, "only one version of ftplugin/nix.vim")
        assert(#get_paths("ftdetect/nix.vim") == 2, "only one version of ftdetect/nix.vim")
        assert(#get_paths("queries/nix/highlights.scm") == 2, "only one version of queries/nix/highlights.scm")

        -- First found file is from build.extraFiles
        assert(
          get_paths("ftplugin/nix.vim")[1]:find("${lib.getName config.build.extraFiles}", 1, true),
          "first found ftplugin/nix.vim isn't in build.extraFiles runtime path"
        )
        assert(
          get_paths("queries/nix/highlights.scm")[1]:find("${lib.getName config.build.extraFiles}", 1, true),
          "first found queries/nix/highlights.scm isn't in build.extraFiles runtime path"
        )
        assert(
          get_paths("queries/nix/highlights.scm")[1]:find("${lib.getName config.build.extraFiles}", 1, true),
          "first found queries/nix/highlights.scm isn't in build.extraFiles runtime path"
        )
      '';
      assertions = [
        {
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 1;
          message = "More than one start plugin is defined in packpathDirs";
        }
      ];
    };

  # Test that standalonePlugins option works
  standalone-plugins =
    { config, ... }:
    {
      performance.combinePlugins = {
        enable = true;
        standalonePlugins = with pkgs.vimPlugins; [
          # By plugin name
          "nvim-treesitter"
          # By package itself
          nvim-lspconfig
          # Its dependency, plenary-nvim, not in this list, so will be combined
          telescope-nvim
          # Dependency of other plugin
          "nvim-cmp"
        ];
      };
      extraPlugins = with pkgs.vimPlugins; [
        nvim-treesitter
        nvim-lspconfig
        telescope-nvim
        # Only its dependency (nvim-cmp) won't be combined, but not the plugin itself
        cmp-dictionary
        # More plugins
        gitsigns-nvim
        luasnip
      ];
      extraConfigLuaPost = ''
        -- Plugins are loadable
        require("nvim-treesitter")
        require("lspconfig")
        require("telescope")
        require("plenary")
        require("cmp_dictionary")
        require("cmp")
        require("gitsigns")
        require("luasnip")

        -- Verify if plugin is standalone or combined
        local function is_standalone(name, dirname)
          local paths = vim.api.nvim_get_runtime_file("lua/" .. name, true);
          assert(#paths == 1, "more than one copy of " .. name .. " in runtime")
          return paths[1]:match("^(.+)/lua/"):find(dirname or name, 1, true) ~= nil
        end

        -- Standalone plugins
        assert(is_standalone("nvim-treesitter"), "nvim-treesitter is combined, expected standalone")
        assert(is_standalone("lspconfig"), "nvim-lspconfig is combined, expected standalone")
        assert(is_standalone("telescope"), "telescope-nvim is combined, expected standalone")
        -- Add trailing slash to ensure that it doesn't match cmp_dictionary
        assert(is_standalone("cmp/", "nvim-cmp"), "nvim-cmp is combined, expected standalone")
        -- Combined plugins
        assert(not is_standalone("plenary"), "plenary-nvim is standalone, expected combined")
        assert(not is_standalone("cmp_dictionary", "cmp-dictionary"), "cmp-dictionary is standalone, expected combined")
        assert(not is_standalone("gitsigns"), "gitsigns-nvim is standalone, expected combined")
        assert(not is_standalone("luasnip"), "luasnip is standalone, expected combined")
      '';
      assertions = [
        {
          # plugin-pack, nvim-treesitter, nvim-lspconfig, telescope-nvim, nvim-cmp
          assertion = pluginCount config.build.packageUnchecked config.build.extraFiles "start" == 5;
          message = "Wrong number of plugins in packpathDirs";
        }
      ];
    };

  # Test if plenary.filetype is working
  plenary-nvim = {
    performance.combinePlugins.enable = true;
    extraPlugins = [ pkgs.vimPlugins.plenary-nvim ];
    extraConfigLuaPost = ''
      -- Plenary filetype detection is usable
      assert(require("plenary.filetype").detect(".bashrc") == "sh", "plenary.filetype is not working")
    '';
  };
}
