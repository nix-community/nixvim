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
          config = "let g:var = 'neovimRcContent5'";

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
            test_content neovimRcContent5 neovimRcContent

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
    { config, helpers, ... }:
    {
      files = {
        # lua type
        "test.lua" = { };
        # vim type
        "test.vim" = { };
      };

      assertions = [
        {
          assertion = !helpers.hasContent config.files."test.lua".content;
          message = "Default content of test.lua file is expected to be empty.";
        }
        {
          assertion = !helpers.hasContent config.files."test.vim".content;
          message = "Default content of test.vim file is expected to be empty.";
        }
      ];
    };
}
