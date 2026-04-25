{
  extraLuaPackages = {
    extraLuaPackages = ps: [ ps.jsregexp ];
    # Make sure jsregexp is in LUA_PATH
    extraConfigLua = ''require("jsregexp")'';
  };

  # Test that all extraConfigs are present in output
  all-configs =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      configs = {
        extraConfigLuaPre = "string.format('extraConfigLuaPre1')";
        extraConfigLua = "string.format('extraConfigLua2')";
        extraConfigLuaPost = "string.format('extraConfigLuaPost3')";
        extraConfigVim = "let g:var = 'extraConfigVim4'";
      };
      mkConfigAssertions = name: value: [
        {
          assertion = lib.hasInfix "extraConfigLuaPre1" value;
          message = "Configuration file ${name} should contain extraConfigLuaPre.";
        }
        {
          assertion = lib.hasInfix "extraConfigLua2" value;
          message = "Configuration file ${name} should contain extraConfigLua.";
        }
        {
          assertion = lib.hasInfix "extraConfigLuaPost3" value;
          message = "Configuration file ${name} should contain extraConfigLuaPost.";
        }
        {
          assertion = lib.hasInfix "extraConfigVim4" value;
          message = "Configuration file ${name} should contain extraConfigVim.";
        }
      ];
    in
    configs
    // {
      files = {
        "test.lua" = configs;
        "test.vim" = configs;
      };

      extraPlugins = [
        {
          config = "let g:var = 'wrappedNeovim.initRc5'";

          # Test that final init.lua contains all config sections
          plugin = pkgs.runCommandLocal "init-lua-content-test" { } ''
            test_content() {
                if ! grep -qF "$1" "${config.build.initFile}"; then
                    echo "init.lua should contain $2" >&2
                    exit 1
                fi
            }

            test_content extraConfigLuaPre1 extraConfigLuaPre
            test_content extraConfigLua2 extraConfigLua
            test_content extraConfigLuaPost3 extraConfigLuaPost
            test_content extraConfigVim4 extraConfigVim4
            test_content wrappedNeovim.initRc5 wrappedNeovim.initRc

            touch $out
          '';
        }
      ];

      assertions =
        # Main init.lua
        mkConfigAssertions "init.lua" config.content
        # Extra file modules
        ++ mkConfigAssertions "test.lua" config.files."test.lua".content
        ++ mkConfigAssertions "test.vim" config.files."test.vim".content;
    };

  files-default-empty =
    { config, lib, ... }:
    {
      files = {
        # lua type
        "test.lua" = { };
        # vim type
        "test.vim" = { };
      };

      assertions = [
        {
          assertion = !lib.nixvim.hasContent config.files."test.lua".content;
          message = "Default content of test.lua file is expected to be empty.";
        }
        {
          assertion = !lib.nixvim.hasContent config.files."test.vim".content;
          message = "Default content of test.vim file is expected to be empty.";
        }
      ];
    };

  with-providers = {
    withNodeJs = true;
    withPerl = true;
    withPython3 = true;
    withRuby = true;

    extraConfigLua = ''
      if type(vim.g.node_host_prog) ~= "string" or not vim.g.node_host_prog:match("node") then
        print("Node.js host program was not configured.")
      end

      if type(vim.g.perl_host_prog) ~= "string" or not vim.g.perl_host_prog:match("perl") then
        print("Perl host program was not configured.")
      end

      if type(vim.g.python3_host_prog) ~= "string" or not vim.g.python3_host_prog:match("python3") then
        print("Python3 host program was not configured.")
      end

      if type(vim.g.ruby_host_prog) ~= "string" or not vim.g.ruby_host_prog:match("ruby") then
        print("Ruby host program was not configured.")
      end
    '';
  };

  without-providers = {
    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

    extraConfigLua = ''
      if vim.g.loaded_node_provider ~= 0 then
        print("Node.js provider discovery was not disabled.")
      end

      if vim.g.loaded_perl_provider ~= 0 then
        print("Perl provider discovery was not disabled.")
      end

      if vim.g.loaded_python3_provider ~= 0 then
        print("Python3 provider discovery was not disabled.")
      end

      if vim.g.loaded_ruby_provider ~= 0 then
        print("Ruby provider discovery was not disabled.")
      end
    '';
  };

  extraPackagesAfter =
    { pkgs, ... }:
    {
      extraPackagesAfter = [ pkgs.hello ];

      extraConfigLua = ''
        if vim.fn.executable("hello") ~= 1 then
          print("Unable to find hello package.")
        end
      '';
    };

  autowrapRuntimeDeps =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "nixvim-runtime-deps-test";
        version = "1";
        src = pkgs.runCommandLocal "nixvim-runtime-deps-test-src" { } "mkdir -p $out";
        runtimeDeps = [ pkgs.hello ];
      };
    in
    {
      extraPlugins = [ plugin ];

      assertions = [
        {
          assertion = lib.elem pkgs.hello config.build.nvimPackage.runtimeDeps;
          message = "`autowrapRuntimeDeps` should add plugin runtime dependencies by default.";
        }
      ];
    };

  autowrapRuntimeDeps-disabled =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "nixvim-runtime-deps-disabled-test";
        version = "1";
        src = pkgs.runCommandLocal "nixvim-runtime-deps-disabled-test-src" { } "mkdir -p $out";
        runtimeDeps = [ pkgs.hello ];
      };
    in
    {
      autowrapRuntimeDeps = false;
      extraPlugins = [ plugin ];

      assertions = [
        {
          assertion = !lib.elem pkgs.hello config.build.nvimPackage.runtimeDeps;
          message = "`autowrapRuntimeDeps = false` should not add plugin runtime dependencies.";
        }
      ];
    };
}
