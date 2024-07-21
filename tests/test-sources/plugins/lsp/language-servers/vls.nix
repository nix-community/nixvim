{
  default = {
    plugins.lsp = {
      enable = true;
      servers.vls.enable = true;
    };

    extraConfigLuaPost = ''
      -- V files are recognized by default
      assert(vim.filetype.match({ filename = "test.v" }) == "vlang", "V filetype is not recognized")
    '';
  };

  extra-options = {
    plugins.lsp = {
      enable = true;

      servers.vls = {
        enable = true;
        autoSetFiletype = true;
      };
    };

    extraConfigLuaPost = ''
      -- autoSetFiletype
      assert(vim.filetype.match({ filename = "test.v" }) == "vlang", "V filetype is not recognized")
    '';
  };
}
