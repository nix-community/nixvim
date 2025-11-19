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
      if vim.fn.executable("nvim-node") ~= 1 then
        print("Unable to find Node.js provider.")
      end

      if vim.fn.executable("nvim-perl") ~= 1 then
        print("Unable to find Perl provider.")
      end

      if vim.fn.executable("nvim-python3") ~= 1 then
        print("Unable to find Python3 provider.")
      end

      if vim.fn.executable("nvim-ruby") ~= 1 then
        print("Unable to find Ruby provider.")
      end
    '';
  };

  without-providers = {
    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

    extraConfigLua = ''
      if vim.fn.executable("nvim-node") == 1 then
        print("Node.js provider was found.")
      end

      if vim.fn.executable("nvim-perl") == 1 then
        print("Perl provider was found.")
      end

      if vim.fn.executable("nvim-python3") == 1 then
        print("Python3 provider was found.")
      end

      if vim.fn.executable("nvim-ruby") == 1 then
        print("Ruby provider was found.")
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
}
