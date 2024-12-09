{
  lua-config-pre-post = {
    extraConfigLuaPre = ''
      list = {}
    '';
    plugins.cmp = {
      enable = true;
      luaConfig = {
        pre = ''
          table.insert(list, "pre")
        '';
        content = ''
          table.insert(list, "init")
        '';
        post = ''
          table.insert(list, "post")
        '';
      };
    };
    extraConfigLuaPost = ''
      if not vim.deep_equal(list, {"pre", "init", "post"}) then
        vim.print("Unexpected list: " .. vim.inspect(list))
      end
    '';
  };
  lua-config-vim-plugin = {
    plugins.typst-vim = {
      enable = true;
      luaConfig.pre = # lua
        ''
          local command = "typst-wrapped" -- Let's say we got it through env vars 
        '';
      settings.cmd.__raw = "command";
      luaConfig.post = # lua
        ''
          local globals_cmd = vim.g.typst_cmd
        '';
    };

    extraConfigLuaPost = ''
      if globals_cmd ~= command then
        print("globals_cmd different than command: " .. globals_cmd .. ", " .. command)
      end
    '';
  };
}
