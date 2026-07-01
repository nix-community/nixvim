/*
  This file includes stub plugins with dependencies of various types.
  It is primarily used in tests for the performance module.
*/
{
  lib,
  neovim-unwrapped,
  neovimUtils,
  runCommand,
  vimUtils,
  writeText,
  writeTextDir,
}:
let
  # Make plugin content
  mkSrc =
    name:
    runCommand "${name}-source" { } ''
      mkdir $out

      # Add import path
      mkdir -p $out/lua/${name}
      echo "return '${name}'" >$out/lua/${name}/init.lua

      # Add plugins
      mkdir $out/plugin
      echo "_G['${name}'] = true" >$out/plugin/${name}.lua
      echo "let g:${builtins.replaceStrings [ "-" ] [ "_" ] name} = 1" >$out/plugin/${name}.vim

      # Add doc
      mkdir $out/doc
      echo "*${name}.txt* ${name}" >$out/doc/${name}.txt

      # Add colliding files (required for combinePlugins tests)
      echo "# ${name}" >$out/README.md
      echo "Copyright (c) ${name}" >$out/LICENSE
      mkdir $out/tests
      echo "return '${name}'" >$out/tests/test.lua
    '';

  # Make a classic vim plugin
  mkPlugin =
    name: attrs:
    vimUtils.buildVimPlugin (
      {
        pname = name;
        version = "2025-04-27";
        src = mkSrc name;
      }
      // attrs
    );

  # Make a plugin built with buildCommand
  mkBuildCommandPlugin =
    name: attrs:
    vimUtils.toVimPlugin (
      (mkSrc name).overrideAttrs (
        prev:
        {
          inherit name;
          pname = name;
          buildCommand = ''
            ${prev.buildCommand}
            # Activate vimGenDocHook for doc checks to pass
            fixupPhase
          '';
        }
        // attrs
      )
    );

  # Make lua library
  mkLuaLib =
    name: attrs:
    neovim-unwrapped.lua.pkgs.buildLuarocksPackage (
      let
        version = "0.0.1-1";
      in
      {
        pname = name;
        inherit version;
        src =
          writeTextDir "${name}/init.lua" # lua
            ''
              local M = {}
              M.name = function()
                return "${name}"
              end
              return M
            '';
        knownRockspec = writeText "${name}-${version}.rockspec" ''
          rockspec_format = "3.0"
          package = "${name}"
          version = "${version}"
          source = {
            url = "git://github.com/nix-community/nixvim.git",
          }
        '';
      }
      // attrs
    );

  # Make luarocks neovim plugin
  mkLuaPlugin =
    name: attrs:
    neovimUtils.buildNeovimPlugin {
      luaAttr = neovim-unwrapped.lua.pkgs.buildLuarocksPackage (
        let
          version = "0.0.1-1";
        in
        {
          pname = name;
          inherit version;
          src = mkSrc name;
          knownRockspec = writeText "${name}-${version}.rockspec" ''
            rockspec_format = "3.0"
            package = "${name}"
            version = "${version}"
            source = {
              url = "git://github.com/nix-community/nixvim.git",
            }
            build = {
              type = "builtin",
              copy_directories = {
                "doc",
                "plugin",
              },
            }
          '';
        }
        // attrs
      );
    };

  /*
    Dependency graph:

      plugin1  plugin2  plugin3  plugin_with_dep4  plugin_with_deep_dep
        |   \              |       /         \             /       \   \
      lib1  pyyaml       lib3  plugin4        \   plugin_with_dep5  \  lib_with_deep_dep
                              /   |   \        \   /       |     \   \           \
                          lib2  numpy  pyyaml  plugin3  plugin5  lib_with_dep4  lib_with_dep5
                                                  |        |          |      \  /     |
                                                lib3   requests      lib4    lib3    lib5

    plugin*: plugins
    lib*: lua dependencies that are not plugins
    pyyaml, requests, numpy: python dependencies

    *_with_dep*: plugin or lua library with dependency
    *_with_deep_dep: plugin or lua library with recursive dependencies

    Basic principles:
      * there are plugins of various types: buildVimPlugin (plugin1),
        buildNeovimPlugin (plugin3), buildCommand (plugin2)
      * there are standalone plugins (plugin1, plugin2)
      * there is a multiplied plugin present on all levels (plugin3)
      * there is a plugin with dependency (plugin_with_dep4 -> plugin4)
      * there is a plugin with recursive dependencies
        (plugin_with_deep_dep -> plugin_with_dep5 -> plugin5)
      * same principles for lua libraries (lib*)
      * there are python dependencies on various levels
  */

  # Lua libraries
  lib1 = mkLuaLib "lib1" { };
  lib2 = mkLuaLib "lib2" { };
  lib3 = mkLuaLib "lib3" { };
  lib4 = mkLuaLib "lib4" { };
  lib5 = mkLuaLib "lib5" { };
  libWithDep4 = mkLuaLib "lib_with_dep4" {
    propagatedBuildInputs = [
      lib4
      lib3
    ];
  };
  libWithDep5 = mkLuaLib "lib_with_dep5" {
    propagatedBuildInputs = [
      lib5
      lib3
    ];
  };
  libWithDeepDep = mkLuaLib "lib_with_deep_dep" {
    propagatedBuildInputs = [ libWithDep5 ];
  };

  # Plugins
  plugin1 = mkPlugin "plugin1" {
    propagatedBuildInputs = [
      # propagate lua to activate setup-hook
      neovim-unwrapped.lua
      lib1
    ];
    passthru.python3Dependencies = ps: [ ps.pyyaml ];
  };
  plugin2 = mkBuildCommandPlugin "plugin2" { };
  plugin3 = mkLuaPlugin "plugin3" {
    propagatedBuildInputs = [ lib3 ];
  };
  plugin4 = mkPlugin "plugin4" {
    propagatedBuildInputs = [ lib2 ];
    passthru.python3Dependencies = ps: [
      ps.numpy
      ps.pyyaml
    ];
  };
  plugin5 = mkPlugin "plugin5" {
    passthru.python3Dependencies = ps: [ ps.requests ];
  };
  pluginWithDep4 = mkPlugin "plugin_with_dep4" {
    dependencies = [
      plugin4
      plugin3
    ];
  };
  pluginWithDep5 = mkLuaPlugin "plugin_with_dep5" {
    dependencies = [
      plugin5
      plugin3
    ];
    propagatedBuildInputs = [ libWithDep4 ];
  };
  pluginWithDeepDep = mkLuaPlugin "plugin_with_deep_dep" {
    dependencies = [ pluginWithDep5 ];
    propagatedBuildInputs = [
      libWithDep4
      libWithDeepDep
    ];
  };

  # Names for using in loops
  libNames = [
    "lib1"
    "lib2"
    "lib3"
    "lib_with_dep4"
    "lib4"
    "lib_with_deep_dep"
    "lib_with_dep5"
    "lib5"
  ];
  pythonNames = [
    "yaml"
    "requests"
    "numpy"
  ];
  pluginNames = [
    "plugin1"
    "plugin2"
    "plugin3"
    "plugin_with_dep4"
    "plugin4"
    "plugin_with_deep_dep"
    "plugin_with_dep5"
    "plugin5"
  ];
  # Lua code to validate lua libraries of the given names
  libChecksFor = lib.concatMapStringsSep "\n" (name:
  # lua
  ''
    -- Lua dependencies require check
    do
      local mod = require("${name}")
      assert(
        mod.name() == "${name}",
        string.format(
          [[expected require("${name}").name() == "${name}", got %q. Invalid lua dependency?]],
          mod.name()
        )
      )
    end
  '');
  # Lua code to validate all lua libraries
  libChecks = libChecksFor libNames;
  # Lua code to validate python dependencies of the given names
  pythonChecksFor = lib.concatMapStringsSep "\n" (name:
  # lua
  ''
    -- Python dependencies checks
    vim.cmd.py3('import ${name}')
  '');
  # Lua code to validate all python dependencies
  pythonChecks = pythonChecksFor pythonNames;
  # Lua code to validate plugins of the given names
  # Python and lua dependencies aren't checked
  pluginChecksFor = lib.concatMapStringsSep "\n" (name:
  # lua
  ''
    -- Require check
    do
      local name = require("${name}")
      assert(
        name == "${name}",
        string.format([[expected require("${name}") == "${name}", got %q. Invalid plugin?]], name)
      )
    end

    -- Lua plugin check
    vim.cmd.runtime("plugin/${name}.lua")
    assert(
      _G["${name}"] == true,
      string.format(
        [[expected _G["${name}"] == true, got %s. File %q isn't executed?]],
        _G["${name}"],
        "plugin/${name}.lua"
      )
    )

    -- Vimscript plugin check
    vim.cmd.runtime("plugin/${name}.vim")
    assert(
      vim.g["${name}"] == 1,
      string.format(
        [[expected vim.g["${name}"] == 1, got %s. File %q isn't executed?]],
        vim.g["${name}"],
        "plugin/${name}.vim"
      )
    )

    -- Doc check
    do
      local doc = vim.api.nvim_get_runtime_file("doc/${name}.txt", false)
      assert(doc[1], [["doc/${name}.txt" not found in runtime]])
      assert(vim.fn.getcompletion("${name}", "help")[1], [[no help tags for "${name}"]])
    end
  '');
  # Lua code to validate all plugins along with python and lua dependencies
  pluginChecks = pluginChecksFor pluginNames + libChecks + pythonChecks;
in
{
  inherit
    # helpers
    mkPlugin
    mkLuaPlugin
    mkBuildCommandPlugin
    mkLuaLib

    # individual plugins
    plugin1
    plugin2
    plugin3
    plugin4
    plugin5
    pluginWithDep4
    pluginWithDep5
    pluginWithDeepDep

    # individual lua libraries
    lib1
    lib2
    lib3
    lib4
    lib5
    libWithDep4
    libWithDep5
    libWithDeepDep

    # checks
    pluginChecksFor
    pluginChecks
    pluginNames
    libChecksFor
    libChecks
    libNames
    pythonChecksFor
    pythonChecks
    pythonNames
    ;

  # a pack of top-level plugins
  pluginPack = [
    plugin1
    plugin2
    plugin3
    pluginWithDep4
    pluginWithDeepDep
  ];

  # a pack of top-level lua libraries
  libPack = [
    lib1
    lib2
    lib3
    libWithDep4
    libWithDeepDep
  ];
}
