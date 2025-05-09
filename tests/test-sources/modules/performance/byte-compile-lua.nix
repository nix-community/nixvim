{ pkgs, ... }:
let
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

  # Stub plugin built with mkDerivation
  stubDrvPlugin = pkgs.stdenvNoCC.mkDerivation {
    name = "stub_drv_plugin";
    src = pkgs.emptyDirectory;
    buildPhase = ''
      mkdir -p "$out/lua/$name"
      echo "return '$name'" >"$out/lua/$name/init.lua"
      mkdir $out/plugin
      echo "vim.g['$name'] = true" >"$out/plugin/$name.lua"
      echo "let g:$name = 1" >"$out/plugin/$name.vim"
    '';
    dependencies = [ stubBuildCommandPlugin ];
  };
  # Stub plugin built with buildCommand with python dependency
  stubBuildCommandPlugin = pkgs.writeTextFile {
    name = "stub_build_command_plugin";
    text = ''
      return "stub_build_command_plugin"
    '';
    destination = "/lua/stub_build_command_plugin/init.lua";
    derivationArgs = {
      dependencies = [ stubDependentPlugin ];
      passthru.python3Dependencies = ps: [ ps.pyyaml ];
    };
  };
  # Dependent stub plugin
  stubDependentPlugin = pkgs.writeTextFile {
    name = "stub_dependent_plugin";
    text = ''
      return "stub_dependent_plugin"
    '';
    destination = "/lua/stub_dependent_plugin/init.lua";
  };
  # Stub plugin with an invalid lua file
  stubInvalidFilePlugin = pkgs.runCommand "stub_invalid_file_plugin" { } ''
    mkdir -p "$out/lua/$name"
    echo "return '$name'" >"$out/lua/$name/init.lua"
    mkdir "$out/ftplugin"
    echo "if true then" >"$out/ftplugin/invalid.lua"
  '';
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

      extraPlugins = [ stubDrvPlugin ];

      extraLuaPackages = ps: [ ps.say ];

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

            -- Plugins aren't byte compiled by default
            { "plugin/stub_drv_plugin.lua", false, "stub_drv_plugin" }
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

          -- Lua library isn't byte compiled by default
          test_lualib_file(require("say").set, false)
        '';

    };

  disabled = {
    performance.byteCompileLua.enable = false;

    extraFiles."plugin/test1.lua".text = "vim.opt.tabstop = 2";

    files."plugin/test2.lua".opts.tabstop = 2;

    extraPlugins = [ stubDrvPlugin ];

    extraLuaPackages = ps: [ ps.say ];

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
      -- Plugins
      test_rtp_file("lua/stub_drv_plugin/init.lua", false)
      -- Neovim runtime
      test_rtp_file("lua/vim/lsp.lua", false)
      -- Lua library
      test_lualib_file(require("say").set, false)
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

    extraPlugins = [
      stubBuildCommandPlugin
    ];

    extraConfigLuaPost = ''
      ${isByteCompiledFun}

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

      -- Python3 packages are importable
      vim.cmd.py3("import yaml")
    '';
  };

  # performance.byteCompileLua.luaLib for extraLuaPackages
  lua-lib-extra-lua-packages = {
    performance.byteCompileLua = {
      enable = true;
      luaLib = true;
    };

    extraLuaPackages =
      ps: with ps; [
        say
        argparse
      ];

    extraConfigLuaPost = ''
      ${isByteCompiledFun}

      -- Lua modules are importable and byte compiled
      local say = require("say")
      test_lualib_file(say.set, true)
      local argparse = require("argparse")
      test_lualib_file(argparse("test").parse, true)
    '';
  };

  # performance.byteCompileLua.luaLib for propagatedBuildInputs
  lua-lib-propagated-build-inputs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      performance.byteCompileLua = {
        enable = true;
        luaLib = true;
      };

      extraPlugins =
        let
          inherit (config.package) lua;
          setDeps =
            drv: deps:
            # 'toLuaModule' is used here for updating 'requiredLuaModules' attr
            lua.pkgs.luaLib.toLuaModule (
              drv.overrideAttrs {
                propagatedBuildInputs = [ lua ] ++ deps;
              }
            );
          # Add the 'argparse' dependency to the 'say' module
          say = setDeps lua.pkgs.say [ lua.pkgs.argparse ];
        in
        [
          # 'lz-n' depends on 'say' which itself depends on 'argparse'
          (setDeps pkgs.vimPlugins.lz-n [ say ])
          # 'nvim-cmp' depends on 'argparse'
          (setDeps pkgs.vimPlugins.nvim-cmp [ lua.pkgs.argparse ])
        ];

      extraConfigLuaPost = ''
        ${isByteCompiledFun}

        -- Plugins themselves are importable
        require("lz.n")
        require("cmp")

        -- Lua modules are importable and byte compiled
        local say = require("say")
        test_lualib_file(say.set, true)
        local argparse = require("argparse")
        test_lualib_file(argparse("test").parse, true)
      '';

      assertions =
        let
          requiredLuaModules = lib.pipe config.extraPlugins [
            (builtins.catAttrs "requiredLuaModules")
            builtins.concatLists
            lib.unique
          ];
        in
        [
          # Ensure that propagatedBuildInputs are byte-compiled recursively
          # by checking that every library is present only once
          {
            assertion = lib.allUnique (map lib.getName requiredLuaModules);
            message = ''
              Expected requiredLuaModules of all propagatedBuildInputs to have unique names.
              Got the following derivations: ${builtins.concatStringsSep ", " requiredLuaModules}.
              One possible reason is that not all dependencies are overridden the same way.
            '';
          }
        ];
    };
}
//
  # Two equal tests, one with combinePlugins.enable = true
  pkgs.lib.genAttrs
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

        combinePlugins.enable = pkgs.lib.hasSuffix "combined" name;
      };

      extraPlugins = [
        # Depends on stubBuildCommandPlugin, which itself depends on stubDependentPlugin
        stubDrvPlugin
        # Plugin with invalid file
        stubInvalidFilePlugin
      ];

      extraConfigLuaPost = ''
        ${isByteCompiledFun}

        local tests = {
          "stub_drv_plugin",
          "stub_build_command_plugin",
          "stub_dependent_plugin",
          "stub_invalid_file_plugin",
        }
        for _, test in ipairs(tests) do
          -- Plugin is loadable
          local val = require(test)
          -- Valid lua code
          assert(val == test, string.format([[expected require("%s") = "%s", got "%s"]], test, test, val))
          -- Is byte compiled
          test_rtp_file("lua/" .. test .. "/init.lua", true)
        end

        -- stubDrvPlugin's other files
        test_rtp_file("plugin/stub_drv_plugin.lua", true)
        -- non-lua file is valid
        vim.cmd.runtime("plugin/stub_drv_plugin.vim")
        assert_g_var("stub_drv_plugin", "plugin/stub_drv_plugin.vim")

        -- Python modules are importable
        vim.cmd.py3("import yaml")

        -- stubInvalidFilePlugin's invalid file exists, but isn't byte compiled
        test_rtp_file("ftplugin/invalid.lua", false)
      '';
    })
