{
  extraLuaPackages = {
    extraLuaPackages = ps: [ ps.jsregexp ];
    # Make sure jsregexp is in LUA_PATH
    extraConfigLua = ''require("jsregexp")'';
  };

  # Test that all extraConfigs are present in output
  all-configs.module =
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
          message = "Configuration file ${name} does not contain extraConfigLuaPre.";
        }
        {
          assertion = lib.hasInfix "extraConfigLua2" value;
          message = "Configuration file ${name} does not contain extraConfigLua.";
        }
        {
          assertion = lib.hasInfix "extraConfigLuaPost3" value;
          message = "Configuration file ${name} does not contain extraConfigLuaPost.";
        }
        {
          assertion = lib.hasInfix "extraConfigVim4" value;
          message = "Configuration file ${name} does not contain extraConfigVim.";
        }
      ];
    in
    configs
    // {
      files = {
        "test.lua" = configs;
        "test.vim" = configs;
      };

      # Plugin configs
      extraPlugins = [
        {
          plugin = pkgs.emptyDirectory;
          config = "let g:var = 'neovimRcContent5'";
        }
      ];

      assertions =
        mkConfigAssertions "init.lua" config.content
        ++ mkConfigAssertions "test.lua" config.files."test.lua".content
        ++ mkConfigAssertions "test.vim" config.files."test.vim".content
        # Check the final generated init.lua too
        ++ mkConfigAssertions "initPath" (builtins.readFile config.initPath)
        ++ [
          # Only init.lua contains configuration from plugin definitions
          {
            assertion = lib.hasInfix "neovimRcContent5" (builtins.readFile config.initPath);
            message = "Configuration file init.lua does not contain plugin configs";
          }
        ];
    };

  files-default-empty.module =
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
