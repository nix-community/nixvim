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
    '';

  # Stub plugin built with mkDerivation
  stubDrvPlugin = pkgs.stdenvNoCC.mkDerivation {
    name = "stub_drv_plugin";
    src = pkgs.emptyDirectory;
    buildPhase = ''
      mkdir -p "$out/lua/$name"
      echo "return '$name'" >"$out/lua/$name/init.lua"
      mkdir $out/plugin
      echo "_G['$name'] = true" >"$out/plugin/$name.lua"
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
        "plugin/file_text.lua".text = "vim.opt.tabstop = 2";
        # By simple source derivation using buildCommand
        "plugin/file_source.lua".source = writeLua "file_source.lua" "vim.opt.tabstop = 2";
        # By standard derivation, it needs to execute fixupPhase
        "plugin/file_drv.lua".source = pkgs.stdenvNoCC.mkDerivation {
          name = "file_drv.lua";
          src = pkgs.emptyDirectory;
          buildPhase = ''
            echo "vim.opt.tabstop = 2" > $out
          '';
        };
        # By path
        "plugin/file_path.lua".source = ./files/file.lua;
        # By string
        "plugin/file_string.lua".source = builtins.toFile "file_path.lua" "vim.opt.tabstop = 2";
        # By derivation converted to string
        "plugin/file_drv_string.lua".source = toString (
          writeLua "file_drv_string.lua" "vim.opt.tabstop = 2"
        );
        # Non-lua files
        "plugin/test.vim".text = "set tabstop=2";
        "plugin/test.json".text = builtins.toJSON { a = 1; };
        # Lua file with txt extension won't be byte compiled
        "test.txt".source = writeLua "test.txt" "vim.opt.tabstop = 2";
      };

      files = {
        "plugin/file.lua" = {
          opts.tabstop = 2;
        };
        "plugin/file.vim" = {
          opts.tabstop = 2;
        };
      };

      extraPlugins = [ stubDrvPlugin ];

      extraConfigLua = ''
        -- The test will search for this string in nixvim-print-init output: VALIDATING_STRING.
        -- Since this is the comment, it won't appear in byte compiled file.
      '';

      # Using plugin for the test code to avoid infinite recursion
      extraFiles."plugin/test.lua".text =
        # lua
        ''
          ${isByteCompiledFun}

          -- vimrc is byte compiled
          local init = vim.env.MYVIMRC or vim.fn.getscriptinfo({name = "init.lua"})[1].name
          assert(is_byte_compiled(init), "MYVIMRC is expected to be byte compiled, but it's not")

          -- nixvim-print-init prints text
          local init_content = vim.fn.system("${lib.getExe config.build.printInitPackage}")
          assert(init_content:find("VALIDATING_STRING"), "nixvim-print-init's output is byte compiled")

          -- lua extraFiles are byte compiled
          test_rtp_file("plugin/file_text.lua", true)
          test_rtp_file("plugin/file_source.lua", true)
          test_rtp_file("plugin/file_drv.lua", true)
          test_rtp_file("plugin/file_path.lua", true)
          test_rtp_file("plugin/file_string.lua", true)
          test_rtp_file("plugin/file_drv_string.lua", true)
          test_rtp_file("plugin/test.vim", false)
          test_rtp_file("plugin/test.json", false)
          test_rtp_file("test.txt", false)

          -- lua files are byte compiled
          test_rtp_file("plugin/file.lua", true)
          test_rtp_file("plugin/file.vim", false)

          -- Plugins and neovim runtime aren't byte compiled by default
          test_rtp_file("lua/vim/lsp.lua", false)
          test_rtp_file("lua/stub_drv_plugin/init.lua", false)
        '';

    };

  disabled =
    {
      config,
      lib,
      ...
    }:
    {
      performance.byteCompileLua.enable = false;

      extraFiles."plugin/test1.lua".text = "vim.opt.tabstop = 2";

      files."plugin/test2.lua".opts.tabstop = 2;

      extraPlugins = [ stubDrvPlugin ];

      extraConfigLua = ''
        -- The test will search for this string in nixvim-print-init output: VALIDATING_STRING.
        -- Since this is the comment, it won't appear in byte compiled file.
      '';

      # Using plugin for the test code to avoid infinite recursion
      extraFiles."plugin/test.lua".text =
        # lua
        ''
          ${isByteCompiledFun}

          -- vimrc
          local init = vim.env.MYVIMRC or vim.fn.getscriptinfo({name = "init.lua"})[1].name
          assert(not is_byte_compiled(init), "MYVIMRC is not expected to be byte compiled, but it is")

          -- nixvim-print-init prints text
          local init_content = vim.fn.system("${lib.getExe config.build.printInitPackage}")
          assert(init_content:find("VALIDATING_STRING"), "nixvim-print-init's output is byte compiled")

          -- Nothing is byte compiled
          -- extraFiles
          test_rtp_file("plugin/test1.lua", false)
          -- files
          test_rtp_file("plugin/test2.lua", false)
          -- Plugins
          test_rtp_file("lua/stub_drv_plugin/init.lua", false)
          -- Neovim runtime
          test_rtp_file("lua/vim/lsp.lua", false)
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
      test_rtp_file("plugin/tutor.vim", false)
      test_rtp_file("ftplugin/vim.vim", false)

      -- Python3 packages are importable
      vim.cmd.py3("import yaml")
    '';
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
        # Depends on stubBuildCommandPlugin -> stubDependentPlugin
        stubDrvPlugin
        # Plugin with invalid
        stubInvalidFilePlugin
      ];

      extraConfigLuaPost = ''
        ${isByteCompiledFun}

        -- Plugins are loadable
        require("stub_drv_plugin")
        require("stub_build_command_plugin")
        require("stub_dependent_plugin")
        require("stub_invalid_file_plugin")

        -- Python modules are importable
        vim.cmd.py3("import yaml")

        -- stubDrvPlugin
        test_rtp_file("lua/stub_drv_plugin/init.lua", true)
        test_rtp_file("plugin/stub_drv_plugin.lua", true)
        test_rtp_file("plugin/stub_drv_plugin.vim", false)

        -- stubBuildCommandPlugin
        test_rtp_file("lua/stub_build_command_plugin/init.lua", true)

        -- stubDependentPlugin
        test_rtp_file("lua/stub_dependent_plugin/init.lua", true)

        -- stubInvalidFilePlugin
        test_rtp_file("lua/stub_invalid_file_plugin/init.lua", true)
        test_rtp_file("ftplugin/invalid.lua", false)
      '';
    })
