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
}
