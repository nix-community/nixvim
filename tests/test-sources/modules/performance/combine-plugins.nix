{ pkgs, ... }:
let
  inherit (pkgs) lib;

  # Assertion for a number of plugins of given type defined in nvimPackage.packpathDirs
  expectNPlugins =
    config: type: n:
    let
      # 'build.extraFiles' must not be combined, so exclude it from counting
      plugins = builtins.filter (
        p: p != config.build.extraFiles
      ) config.build.nvimPackage.packpathDirs.myNeovimPackages.${type};
      numPlugins = builtins.length plugins;
    in
    {
      assertion = numPlugins == n;
      message = "Expected ${toString n} '${type}' plugins defined in 'nvimPackage.packpathDirs', got ${toString numPlugins}: ${
        lib.concatMapStringsSep ", " lib.getName plugins
      }.";
    };
  # Assertion that exactly one start plugin is defined in nvimPackage.packpathDirs
  expectOneStartPlugin = config: expectNPlugins config "start" 1;

  # Stub plugins
  mkPlugin =
    name: args:
    pkgs.vimUtils.buildVimPlugin (
      {
        pname = name;
        version = "2025-04-27";
        src = pkgs.runCommand "${name}-source" { } ''
          mkdir "$out"
          # Add some colliding files
          echo "# ${name}" > "$out/README.md"
          echo "Copyright (c) ${name}" > "$out/LICENSE"
          mkdir "$out/tests"
          echo "return '${name}'" > "$out/tests/test.lua"
          # Add import path
          mkdir -p "$out/lua/${name}"
          echo "return '${name}'" > "$out/lua/${name}/init.lua"
          # Add doc
          mkdir "$out/doc"
          echo "*${name}.txt* ${name}" > "$out/doc/${name}.txt"
        '';
      }
      // args
    );
  # Simple plugins without any features
  simplePlugin1 = mkPlugin "simple-plugin-1" { };
  simplePlugin2 = mkPlugin "simple-plugin-2" { };
  simplePlugin3 = mkPlugin "simple-plugin-3" { };
  # Plugins with dependencies
  pluginWithDeps1 = mkPlugin "plugin-with-deps-1" {
    dependencies = [ simplePlugin1 ];
  };
  pluginWithDeps2 = mkPlugin "plugin-with-deps-2" {
    dependencies = [ simplePlugin2 ];
  };
  pluginWithDeps3 = mkPlugin "plugin-with-deps-3" {
    dependencies = [ simplePlugin3 ];
  };
  # Plugin with recursive dependencies
  pluginWithRecDeps = mkPlugin "plugin-with-rec-deps" {
    dependencies = [
      pluginWithDeps1
      pluginWithDeps2
    ];
  };
  # Plugin with non-standard files
  pluginWithExtraFiles = mkPlugin "plugin-with-extra-files" {
    postInstall = ''
      mkdir "$out/_extra"
      touch "$out/_extra/test"
    '';
  };
  # Plugins with Python dependencies
  pluginWithPyDeps1 = mkPlugin "plugin-with-py-deps-1" {
    passthru.python3Dependencies = ps: [ ps.pyyaml ];
  };
  pluginWithPyDeps2 = mkPlugin "plugin-with-py-deps-2" {
    passthru.python3Dependencies = ps: [ ps.pyyaml ];
  };
  pluginWithPyDeps3 = mkPlugin "plugin-with-py-deps-3" {
    passthru.python3Dependencies = ps: [ ps.requests ];
  };
  # Plugins with Lua dependencies
  ensureDep =
    drv: dep:
    drv.overrideAttrs (prev: {
      propagatedBuildInputs = lib.unique (
        prev.propagatedBuildInputs or [ ] ++ [ prev.passthru.lua.pkgs.${dep} ]
      );
    });
  pluginWithLuaDeps1 = ensureDep pkgs.vimPlugins.telescope-nvim "plenary-nvim";
  pluginWithLuaDeps2 = ensureDep pkgs.vimPlugins.nvim-cmp "plenary-nvim";
  pluginWithLuaDeps3 = ensureDep pkgs.vimPlugins.gitsigns-nvim "nui-nvim";
in
{
  # Test basic functionality
  default =
    { config, ... }:
    let
      extraPlugins = [
        simplePlugin1
        simplePlugin2
        simplePlugin3
      ];
    in
    {
      performance.combinePlugins.enable = true;
      inherit extraPlugins;
      extraConfigLuaPost = lib.concatMapStringsSep "\n" (
        name:
        # lua
        ''
          -- Plugin is loadable
          require("${name}")

          -- No separate plugin entry in vim.api.nvim_list_runtime_paths()
          assert(not vim.iter(vim.api.nvim_list_runtime_paths()):any(function(entry)
            return entry:find("${name}", 1, true)
          end), "plugin '${name}' found in runtime, expected to be combined")

          -- Help tags are generated
          assert(vim.fn.getcompletion("${name}", "help")[1], "no help tags for '${name}'")
        '') (map lib.getName extraPlugins);
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test disabled option
  disabled =
    { config, ... }:
    let
      extraPlugins = [
        simplePlugin1
        simplePlugin2
        simplePlugin3
      ];
    in
    {
      performance.combinePlugins.enable = false;
      inherit extraPlugins;
      extraConfigLuaPost = lib.concatMapStringsSep "\n" (
        name:
        # lua
        ''
          -- Separate plugin entry in vim.api.nvim_list_runtime_paths()
          assert(vim.iter(vim.api.nvim_list_runtime_paths()):any(function(entry)
            return entry:find("${name}", 1, true)
          end), "plugin '${name}' isn't found in runtime as a separate entry, expected not to be combined")
        '') (map lib.getName extraPlugins);
      assertions = [
        (expectNPlugins config "start" (builtins.length extraPlugins))
      ];
    };

  # Test that plugin dependencies are handled
  dependencies =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = [
        # Depends on pluginWithDeps1 and pluginWithDeps2 which themselves depend on simplePlugin1 and simplePlugin2
        pluginWithRecDeps
        # Depends on simplePlugin3
        pluginWithDeps3
        # Duplicated dependency
        pluginWithDeps2
        # Duplicated plugin
        simplePlugin2
      ];
      extraConfigLuaPost = ''
        -- Plugin 'pluginWithRecDeps' and its dependencies are loadable
        require("plugin-with-rec-deps")
        require("plugin-with-deps-1")
        require("plugin-with-deps-2")
        require("simple-plugin-1")
        require("simple-plugin-2")
        -- Plugin 'pluginWithDeps3' and its dependencies are loadable
        require("plugin-with-deps-3")
        require("simple-plugin-3")
      '';
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test that pathsToLink option works
  paths-to-link =
    { config, ... }:
    {
      performance.combinePlugins = {
        enable = true;
        pathsToLink = [ "/_extra" ];
      };
      extraPlugins = [ pluginWithExtraFiles ];
      extraConfigLuaPost = ''
        -- Test file is in runtime
        assert(
          vim.api.nvim_get_runtime_file("_extra/test", false)[1],
          "'_extra/test' file isn't found in runtime, expected to be found"
        )
      '';
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test that plugin python3 dependencies are handled
  python-dependencies =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = [
        # No python3 dependencies
        simplePlugin1
        # Duplicated python3-pyyaml dependency
        pluginWithPyDeps1
        pluginWithPyDeps2
        # Python3-requests dependency
        pluginWithPyDeps3
      ];
      extraConfigLuaPost = ''
        -- Python modules are importable
        vim.cmd.py3("import yaml")
        vim.cmd.py3("import requests")
      '';
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test that plugin lua dependencies are handled
  lua-dependencies =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = [
        simplePlugin1
        # Duplicated plenary-nvim dependency
        pluginWithLuaDeps1
        pluginWithLuaDeps2
        # nui-nvim dependency
        pluginWithLuaDeps3
      ];
      extraConfigLuaPost = ''
        -- All packages and its dependencies are importable
        require("telescope")
        require("plenary")
        require("cmp")
        require("gitsigns")
        require("nui.popup")
      '';
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test that optional plugins are handled
  optional-plugins =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = [
        # Start plugins
        simplePlugin1
        simplePlugin2
        # Optional plugin
        {
          plugin = simplePlugin3;
          optional = true;
        }
        # Optional plugin with dependency on simplePlugin1
        # Dependencies should not be duplicated
        {
          plugin = pluginWithDeps1;
          optional = true;
        }
      ];
      extraConfigLuaPost = ''
        -- Start plugins are loadable
        require("simple-plugin-1")
        require("simple-plugin-2")

        -- Opt plugins are not loadable
        local ok = pcall(require, "simple-plugin-3")
        assert(not ok, "simplePlugin3 is loadable, expected it to be an opt plugin")
        ok = pcall(require, "plugin-with-deps-1")
        assert(not ok, "pluginWithDeps1 is loadable, expected it to be an opt plugin")

        -- Load plugins
        vim.cmd.packadd("simple-plugin-3")
        vim.cmd.packadd("plugin-with-deps-1")

        -- Now opt plugins are loadable
        require("simple-plugin-3")
        require("plugin-with-deps-1")

        -- Only one copy of simplePlugin1 should be available
        local num_plugins = #vim.api.nvim_get_runtime_file("lua/simple-plugin-1/init.lua", true)
        assert(num_plugins == 1, "expected 1 copy of simplePlugin1, got " .. num_plugins)
      '';
      assertions = [
        (expectOneStartPlugin config)
        # simplePlugin3 pluginWithDeps1
        (expectNPlugins config "opt" 2)
      ];
    };

  # Test that plugin configs are handled
  configs =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = [
        # A plugin without config
        simplePlugin1
        # Plugin with config
        {
          plugin = simplePlugin2;
          config = "let g:simple_plugin_2 = 1";
        }
        # Optional plugin with config
        {
          plugin = simplePlugin3;
          optional = true;
          config = "let g:simple_plugin_3 = 1";
        }
      ];
      extraConfigLuaPost = ''
        -- Configs are evaluated
        assert(vim.g.simple_plugin_2 == 1, "simplePlugin2's config isn't evaluated")
        assert(vim.g.simple_plugin_3 == 1, "simplePlugin3's config isn't evaluated")
      '';
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test that config.build.extraFiles is not combined
  files-plugin =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = [
        simplePlugin1
        simplePlugin2
      ];
      # Ensure that build.extraFiles is added to extraPlugins
      wrapRc = true;
      # Extra user files colliding with plugins
      extraFiles = {
        "lua/simple-plugin-1/init.lua".text = "return 1";
      };
      # Another form of user files
      files = {
        "lua/simple-plugin-2/init.lua" = {
          extraConfigLua = "return 1";
        };
      };
      extraConfigLuaPost = ''
        for _, file in ipairs({"lua/simple-plugin-1/init.lua", "lua/simple-plugin-2/init.lua"}) do
          local paths_found = vim.api.nvim_get_runtime_file(file, true)
          local num_found = #paths_found

          -- Both plugin and user version are available
          assert(num_found == 2, "expected exactly 2 versions of '" .. file .. "', got " .. num_found)

          -- First found file is from build.extraFiles
          assert(
            paths_found[1]:find("${lib.getName config.build.extraFiles}", 1, true),
            "expected first found '" .. file .. "' to be from build.extraFiles, got " .. paths_found[1]
          )
        end
      '';
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test that standalonePlugins option works
  standalone-plugins =
    { config, ... }:
    {
      performance.combinePlugins = {
        enable = true;
        standalonePlugins = [
          # By plugin name
          "simple-plugin-1"
          # By package itself. Its dependency, simplePlugin2, not in this list, so will be combined
          pluginWithDeps2
          # Dependency of other plugin
          "simple-plugin-3"
        ];
      };
      extraPlugins = [
        simplePlugin1
        pluginWithDeps2
        pluginWithDeps3
        pluginWithExtraFiles
      ];
      extraConfigLuaPost = ''
        local tests = {
          {"simple-plugin-1", true},
          {"plugin-with-deps-2", true},
          {"simple-plugin-2", false},
          {"plugin-with-deps-3", false},
          {"simple-plugin-3", true},
          {"plugin-with-extra-files", false},
        }
        for _, test in ipairs(tests) do
          local name = test[1]
          local expected_standalone = test[2]

          -- Plugin is loadable
          require(test[1])

          local paths = vim.api.nvim_get_runtime_file("lua/" .. name, true)
          -- Plugins shouldn't be duplicated
          assert(#paths == 1, "expected exactly 1 copy of '" .. name .. "' in runtime, got ", #paths)
          -- Test if plugin is standalone. This matches directory name before '/lua/'.
          local is_standalone = paths[1]:match("^(.+)/lua/"):find(name, 1, true) ~= nil
          local expected_text = expected_standalone and "standalone" or "combined"
          assert(
              is_standalone == expected_standalone,
              "expected '" .. name .. "' to be " .. expected_text .. ", found path: " .. paths[1]
          )
        end
      '';
      assertions = [
        # plugin-pack, simplePlugin1, pluginWithDeps2, simplePlugin3
        (expectNPlugins config "start" 4)
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
