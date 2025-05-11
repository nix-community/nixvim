{ lib, pkgs, ... }:
let
  pluginStubs = pkgs.callPackage ../../../utils/plugin-stubs.nix { };

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
in
{
  # Test basic functionality
  default =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = pluginStubs.pluginPack;
      extraConfigLuaPost = ''
        ${pluginStubs.pluginChecks}

        -- No separate plugin entry in vim.api.nvim_list_runtime_paths()
        ${lib.concatMapStrings (
          name: # lua
          ''
            assert(not vim.iter(vim.api.nvim_list_runtime_paths()):any(function(entry)
              return entry:find("${name}", 1, true)
            end), "plugin '${name}' found in runtime, expected to be combined")
          '') pluginStubs.pluginNames}
      '';
      assertions = [
        (expectOneStartPlugin config)
      ];
    };

  # Test disabled option
  disabled =
    { config, ... }:
    {
      performance.combinePlugins.enable = false;
      extraPlugins = pluginStubs.pluginPack;
      extraConfigLuaPost = lib.concatMapStringsSep "\n" (
        name:
        # lua
        ''
          -- Separate plugin entry in vim.api.nvim_list_runtime_paths()
          assert(vim.iter(vim.api.nvim_list_runtime_paths()):any(function(entry)
            return entry:find("${name}", 1, true)
          end), "plugin '${name}' isn't found in runtime as a separate entry, expected not to be combined")
        '') pluginStubs.pluginNames;
      assertions = [
        (expectNPlugins config "start" (builtins.length pluginStubs.pluginPack))
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
      extraPlugins = [
        # A plugin with extra directory
        (pluginStubs.mkPlugin "extra" {
          postInstall = ''
            mkdir $out/_extra
            touch $out/_extra/test
          '';
        })
      ];
      extraConfigLuaPost = ''
        ${pluginStubs.pluginChecksFor [ "extra" ]}

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

  # Test that optional plugins are handled
  optional-plugins =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pluginStubs; [
        # Start plugins
        plugin1
        plugin3
        # Optional plugin
        {
          plugin = plugin2;
          optional = true;
        }
        # Optional plugin with dependencies on plugin3 and plugin4
        # Dependencies should not be duplicated
        {
          plugin = pluginWithDep4;
          optional = true;
        }
      ];
      extraConfigLuaPost = ''
        -- Start plugins are working. Dependencies of the optional plugins are also available.
        ${pluginStubs.pluginChecksFor [
          "plugin1"
          "plugin3"
          "plugin4" # Dependency of the optional plugin
        ]}

        -- Lua libraries are available. Libs of the optional plugins are also available.
        ${pluginStubs.libChecksFor [
          "lib1"
          "lib2" # Dependency of the optional plugin
          "lib3"
        ]}

        ${lib.concatMapStrings
          (
            name: # lua
            ''
              -- Optional plugin is not loadable
              local ok = pcall(require, "${name}")
              assert(not ok, "${name} is loadable, expected it to be an opt plugin")

              -- Load plugin
              vim.cmd.packadd("${name}")

              -- Now opt plugin is working
              ${pluginStubs.pluginChecksFor [ name ]}
            '')
          [
            "plugin2"
            "plugin_with_dep4"
          ]
        }

        -- Only one copy of dependent plugin should be available
        ${lib.concatMapStrings
          (
            name: # lua
            ''
              local num_plugins = #vim.api.nvim_get_runtime_file("lua/${name}/init.lua", true)
              assert(num_plugins == 1, "expected 1 copy of ${name}, got " .. num_plugins)
            '')
          [
            "plugin3"
            "plugin4"
          ]
        }
      '';
      assertions = [
        (expectOneStartPlugin config)
        # plugin2 plugin_with_dep4
        (expectNPlugins config "opt" 2)
      ];
    };

  # Test that plugin configs are handled
  configs =
    { config, ... }:
    {
      performance.combinePlugins.enable = true;
      extraPlugins = with pluginStubs; [
        # A plugin without config
        plugin1
        # A plugin with config
        {
          plugin = plugin2;
          config = "let g:plugin2_var = 1";
        }
        # Optional plugin with config
        {
          plugin = plugin3;
          optional = true;
          config = "let g:plugin3_var = 1";
        }
      ];
      extraConfigLuaPost = ''
        -- Configs are evaluated
        assert(vim.g.plugin2_var == 1, "plugin2's config isn't evaluated")
        assert(vim.g.plugin3_var == 1, "plugin3's config isn't evaluated")
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
      extraPlugins = with pluginStubs; [
        plugin1
        plugin2
      ];
      # Ensure that build.extraFiles is added to extraPlugins
      wrapRc = true;
      # Extra user files colliding with plugins
      extraFiles = {
        "lua/plugin1/init.lua".text = "return 1";
      };
      # Another form of user files
      files = {
        "lua/plugin2/init.lua" = {
          extraConfigLua = "return 1";
        };
      };
      extraConfigLuaPost = ''
        for _, file in ipairs({"lua/plugin1/init.lua", "lua/plugin2/init.lua"}) do
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
    let
      standalonePlugins = [
        # By plugin name
        "plugin1"
        # By package itself. Its dependency, plugin4, not in this list, so will be combined
        pluginStubs.pluginWithDep4
        # Dependency of other plugin
        "plugin5"
        # Both dependency and top-level plugin
        "plugin3"
      ];
    in
    {
      performance.combinePlugins = {
        enable = true;
        inherit standalonePlugins;
      };
      extraPlugins = pluginStubs.pluginPack;
      extraConfigLuaPost = ''
        ${pluginStubs.pluginChecks}

        ${lib.concatMapStringsSep "\n" (
          name:
          let
            isStandalone = builtins.elem name (
              map (x: if builtins.isString x then x else lib.getName x) standalonePlugins
            );
            expectedText = if isStandalone then "standalone" else "combined";
          in
          # lua
          ''
            -- Check that ${name} plugin is ${expectedText}
            local paths = vim.api.nvim_get_runtime_file("lua/${name}", true)
            -- Plugins shouldn't be duplicated
            assert(#paths == 1, "expected exactly 1 copy of '${name}' in runtime, got ", #paths)
            -- Test if plugin is standalone. This matches directory name before '/lua/'.
            local is_standalone = paths[1]:match("^(.+)/lua/"):find("${name}", 1, true) ~= nil
            assert(
                is_standalone == ${lib.nixvim.toLuaObject isStandalone},
                "expected '${name}' to be ${expectedText}, found path: " .. paths[1]
            )
          ''
        ) pluginStubs.pluginNames}
      '';
      assertions = [
        # plugin-pack and 'standalonePlugins'
        (expectNPlugins config "start" (builtins.length standalonePlugins + 1))
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
