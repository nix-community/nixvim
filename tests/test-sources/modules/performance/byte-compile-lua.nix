{ lib, pkgs }:
let
  pluginStubs = pkgs.callPackage ../../../utils/plugin-stubs.nix { };

  isByteCompiledFun = # lua
    ''
      -- LuaJIT bytecode header is: ESC L J version
      -- https://github.com/LuaJIT/LuaJIT/blob/v2.1/src/lj_bcdump.h
      -- We are comparing the first three bytes of the file (until version)
      local expected_header = string.char(0x1b, 0x4c, 0x4a)
      local function is_byte_compiled(filename)
        local f = assert(io.open(filename, "rb"))
        local data = assert(f:read(3))
        f:close()
        return data == expected_header
      end

      local function test_rtp_file(name, is_compiled)
        local file = assert(vim.api.nvim_get_runtime_file(name, false)[1], "file " .. name .. " not found in runtime")
        if is_compiled then
          assert(is_byte_compiled(file), name .. " is expected to be byte compiled, but it's not")
        else
          assert(not is_byte_compiled(file), name .. " is not expected to be byte compiled, but it is")
        end
      end

      local function test_lualib_file(func, is_compiled)
        -- Get the source of the func
        local info = debug.getinfo(func, "S")
        -- The source returned by debug.getinfo is prefixed with '@'
        local file = info.source:sub(2)
        assert(vim.uv.fs_stat(file))
        if is_compiled then
          assert(is_byte_compiled(file), file .. " is expected to be byte compiled, but it's not")
        else
          assert(not is_byte_compiled(file), file .. " is not expected to be byte compiled, but it is")
        end
      end

      local function assert_g_var(varname, filename)
        assert(
          vim.g[varname] == true or vim.g[varname] == 1,
          string.format(
            "expected vim.g.%s to be truthy, got %s. File %s isn't executed?",
            varname,
            vim.g[varname],
            filename
          )
        )
      end
    '';

  # In order to know where lua library come from
  # split plugins and libs to avoid lua libraries intersection.
  shortPluginList = with pluginStubs; [
    plugin1
    pluginWithDep4
  ];
  shortPluginNames = [
    "plugin1"
    "plugin_with_dep4"
    "plugin4"
    "plugin3"
  ];
  shortPluginLuaNames = [
    "lib1"
    "lib2"
    # "lib3" # is in both
  ];
  shortLuaList = with pluginStubs; [
    lib4
    libWithDep5
  ];
  shortLuaNames = [
    "lib4"
    "lib_with_dep5"
    "lib5"
    # "lib3" # is in both
  ];
  shortLuaAllNames = shortPluginLuaNames ++ shortLuaNames ++ [ "lib3" ];
  shortChecks =
    pluginStubs.pluginChecksFor shortPluginNames
    + pluginStubs.libChecksFor shortLuaAllNames
    + pluginStubs.pythonChecksFor [
      "yaml"
      "numpy"
    ];
in
{
  default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      writeLua = lib.nixvim.builders.writeLuaWith pkgs;
    in
    {
      performance.byteCompileLua.enable = true;

      extraFiles = {
        # By text
        "plugin/extra_file_text.lua".text = "vim.g.extra_file_text = true";
        # By simple source derivation using buildCommand
        "plugin/extra_file_source.lua".source =
          writeLua "extra_file_source.lua" "vim.g.extra_file_source = true";
        # By standard derivation, it needs to execute fixupPhase
        "plugin/extra_file_drv.lua".source = pkgs.stdenvNoCC.mkDerivation {
          name = "extra_file_drv.lua";
          src = pkgs.emptyDirectory;
          buildPhase = ''
            echo "vim.g.extra_file_drv = true" > $out
          '';
        };
        # By path
        "plugin/extra_file_path.lua".source = ./files/file.lua;
        # By string
        "plugin/extra_file_string.lua".source =
          builtins.toFile "extra_file_path.lua" "vim.g.extra_file_string = true";
        # By derivation converted to string
        "plugin/extra_file_drv_string.lua".source = toString (
          writeLua "extra_file_drv_string.lua" "vim.g.extra_file_drv_string = true"
        );
        # Non-lua file
        "plugin/extra_file_non_lua.vim".text = "let g:extra_file_non_lua = 1";
        # Lua file with txt extension won't be byte compiled
        "text.txt".source = writeLua "text.txt" "vim.g.text = true";
      };

      files = {
        "plugin/file.lua" = {
          globals.file_lua = true;
        };
        "plugin/file.vim" = {
          globals.file_vimscript = true;
        };
      };

      extraPlugins = shortPluginList;

      extraLuaPackages = _: shortLuaList;

      extraConfigLua = ''
        -- The test will search for the next string in nixvim-print-init's output: VALIDATING_STRING.
        -- Since this is the comment, it won't appear in byte compiled file.

        vim.g.init_lua = true
      '';

      # Using plugin for the test code to avoid infinite recursion
      extraFiles."plugin/test.lua".text =
        # lua
        ''
          ${isByteCompiledFun}

          ${shortChecks}

          -- vimrc is byte compiled
          local init = vim.env.MYVIMRC or vim.fn.getscriptinfo({name = "init.lua"})[1].name
          assert(is_byte_compiled(init), "MYVIMRC is expected to be byte compiled, but it's not")
          assert_g_var("init_lua", "MYVIMRC")

          -- nixvim-print-init prints text
          local init_content = vim.fn.system("${lib.getExe config.build.printInitPackage}")
          assert(init_content:find("VALIDATING_STRING"), "nixvim-print-init's output is byte compiled")

          local runtime_lua_files = {
            -- lua 'extraFiles' are byte compiled
            { "plugin/extra_file_text.lua", true, "extra_file_text" },
            { "plugin/extra_file_source.lua", true, "extra_file_source" },
            { "plugin/extra_file_drv.lua", true, "extra_file_drv" },
            { "plugin/extra_file_path.lua", true, "extra_file_path" },
            { "plugin/extra_file_string.lua", true, "extra_file_string" },
            { "plugin/extra_file_drv_string.lua", true, "extra_file_drv_string" },
            -- other 'extraFiles'
            { "plugin/extra_file_non_lua.vim", false, "extra_file_non_lua" },
            -- lua 'files' are byte compiled
            { "plugin/file.lua", true, "file_lua" },
            -- other 'files'
            { "plugin/file.vim", false, "file_vimscript" },
          }
          for _, test in ipairs(runtime_lua_files) do
            local file, expected_byte_compiled, varname = unpack(test)
            test_rtp_file(file, expected_byte_compiled)
            -- Runtime plugin scripts are loaded last, so activate each manually before a test
            vim.cmd.runtime(file)
            assert_g_var(varname, file)
          end

          -- Nvim runtime isn't byte compiled by default
          test_rtp_file("lua/vim/lsp.lua", false)

          -- Plugins aren't byte-compiled by default
          ${lib.concatMapStrings (name: ''
            test_rtp_file("lua/${name}/init.lua", false)
            test_rtp_file("plugin/${name}.lua", false)
          '') shortPluginNames}

          -- Lua library isn't byte-compiled by default
          ${lib.concatMapStrings (name: ''
            test_lualib_file(require("${name}").name, false)
          '') shortLuaAllNames}
        '';

    };

  disabled = {
    performance.byteCompileLua.enable = false;

    extraFiles."plugin/test1.lua".text = "vim.opt.tabstop = 2";

    files."plugin/test2.lua".opts.tabstop = 2;

    extraPlugins = shortPluginList;

    extraLuaPackages = _: shortLuaList;

    extraConfigLua = ''
      ${isByteCompiledFun}

      -- Nothing is byte compiled
      -- vimrc
      local init = vim.env.MYVIMRC or vim.fn.getscriptinfo({name = "init.lua"})[1].name
      assert(not is_byte_compiled(init), "MYVIMRC is not expected to be byte compiled, but it is")
      -- extraFiles
      test_rtp_file("plugin/test1.lua", false)
      -- files
      test_rtp_file("plugin/test2.lua", false)
      -- Neovim runtime
      test_rtp_file("lua/vim/lsp.lua", false)
      -- plugins
      test_rtp_file("lua/${builtins.elemAt shortPluginNames 0}/init.lua", false)
      -- lua library
      test_lualib_file(require("${builtins.elemAt shortLuaNames 0}").name, false)
      test_lualib_file(require("${builtins.elemAt shortPluginLuaNames 0}").name, false)
    '';
  };

  init-lua-disabled = {
    performance.byteCompileLua = {
      enable = true;
      initLua = false;
    };

    extraConfigLuaPost = ''
      ${isByteCompiledFun}

      -- vimrc is not byte compiled
      local init = vim.env.MYVIMRC or vim.fn.getscriptinfo({name = "init.lua"})[1].name
      assert(not is_byte_compiled(init), "MYVIMRC is not expected to be byte compiled, but it is")
    '';
  };

  configs-disabled = {
    performance.byteCompileLua = {
      enable = true;
      configs = false;
    };

    extraFiles."plugin/test1.lua".text = "vim.opt.tabstop = 2";

    files."plugin/test2.lua".opts.tabstop = 2;

    extraConfigLuaPost = ''
      ${isByteCompiledFun}

      -- extraFiles
      test_rtp_file("plugin/test1.lua", false)
      -- files
      test_rtp_file("plugin/test2.lua", false)
    '';
  };

  nvim-runtime = {
    performance.byteCompileLua = {
      enable = true;
      nvimRuntime = true;
    };

    extraPlugins = shortPluginList;
    extraLuaPackages = _: shortLuaList;

    extraConfigLuaPost = ''
      ${isByteCompiledFun}

      ${shortChecks}

      -- vim namespace is working
      vim.opt.tabstop = 2
      vim.api.nvim_get_runtime_file("init.lua", false)
      vim.lsp.get_clients()
      vim.treesitter.language.get_filetypes("nix")
      vim.iter({})

      test_rtp_file("lua/vim/lsp.lua", true)
      test_rtp_file("lua/vim/iter.lua", true)
      test_rtp_file("lua/vim/treesitter/query.lua", true)
      test_rtp_file("lua/vim/lsp/buf.lua", true)
      test_rtp_file("plugin/editorconfig.lua", true)
    '';
  };

  # performance.byteCompileLua.luaLib for extraLuaPackages
  lua-lib-extra-lua-packages = {
    performance.byteCompileLua = {
      enable = true;
      luaLib = true;
    };

    extraLuaPackages = _: pluginStubs.libPack;

    extraConfigLuaPost = ''
      ${pluginStubs.libChecks}

      ${isByteCompiledFun}

      -- Lua modules are byte-compiled
      ${lib.concatMapStringsSep "\n" (
        name: "test_lualib_file(require('${name}').name, true)"
      ) pluginStubs.libNames}
    '';
  };

  # performance.byteCompileLua.luaLib for propagatedBuildInputs
  lua-lib-propagated-build-inputs =
    { config, ... }:
    {
      performance.byteCompileLua = {
        enable = true;
        luaLib = true;
      };

      extraPlugins = pluginStubs.pluginPack;

      extraConfigLuaPost = ''
        ${pluginStubs.pluginChecks}

        ${isByteCompiledFun}

        -- Lua modules are byte-compiled
        ${lib.concatMapStringsSep "\n" (
          name: "test_lualib_file(require('${name}').name, true)"
        ) pluginStubs.libNames}

        -- Plugins themselves are not byte-compiled
        ${lib.concatMapStringsSep "\n" (
          name: "test_rtp_file('lua/${name}/init.lua', false)"
        ) pluginStubs.pluginNames}
      '';

      assertions =
        let
          # Get plugins with all dependencies
          getDeps = drv: [ drv ] ++ builtins.concatMap getDeps drv.dependencies or [ ];
          plugins = lib.pipe config.build.plugins [
            (builtins.catAttrs "plugin")
            (builtins.concatMap getDeps)
            lib.unique
          ];
          # Collect both propagatedBuildInputs and requiredLuaModules to one list
          getAllRequiredLuaModules = lib.flip lib.pipe [
            (
              drvs: builtins.catAttrs "propagatedBuildInputs" drvs ++ builtins.catAttrs "requiredLuaModules" drvs
            )
            (builtins.concatMap (deps: deps ++ getAllRequiredLuaModules deps))
            lib.unique
          ];
          allRequiredLuaModules = getAllRequiredLuaModules plugins;
        in
        [
          # Ensure that lua dependencies are byte-compiled recursively
          # by checking that every library is present only once.
          # If there are two different derivations with the same name,
          # then one of them probably isn't byte-compiled.
          {
            assertion = lib.allUnique (map lib.getName allRequiredLuaModules);
            message = ''
              Expected propagatedBuildInputs and requiredLuaModules of all plugins to have unique names.
              Got the following derivations:''\n${lib.concatLines allRequiredLuaModules}
              Possible reasons:
              - not all dependencies are overridden the same way
              - requiredLuaModules are not updated along with propagatedBuildInputs
            '';
          }
        ];
    };
}
//
  # Two equal tests, one with combinePlugins.enable = true
  lib.genAttrs
    [
      "plugins"
      "plugins-combined"
    ]
    (name: {
      performance = {
        byteCompileLua = {
          enable = true;
          plugins = true;
        };

        combinePlugins.enable = lib.hasSuffix "combined" name;
      };

      extraPlugins = pluginStubs.pluginPack ++ [
        # A plugin with invalid lua file
        (pluginStubs.mkPlugin "invalid" {
          postInstall = ''
            mkdir $out/ftplugin
            echo "if true then" >$out/ftplugin/invalid.lua
          '';
        })
      ];

      extraConfigLuaPost = ''
        ${pluginStubs.pluginChecks}

        ${isByteCompiledFun}

        -- Plugins are byte-compiled
        ${lib.concatMapStrings (name: ''
          test_rtp_file("lua/${name}/init.lua", true)
          test_rtp_file("plugin/${name}.lua", true)
        '') pluginStubs.pluginNames}

        -- Lua modules aren't byte-compiled
        ${lib.concatMapStrings (name: ''
          test_lualib_file(require("${name}").name, false)
        '') pluginStubs.libNames}

        -- A plugin with invalid file
        ${pluginStubs.pluginChecksFor [ "invalid" ]}
        -- invalid file exists, but isn't byte compiled
        test_rtp_file("ftplugin/invalid.lua", false)
      '';
    })
