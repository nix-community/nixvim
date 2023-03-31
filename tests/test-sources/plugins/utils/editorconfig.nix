{
  # TODO: convert to disable test in neovim 0.9
  empty = {
    plugins.editorconfig.enable = true;
  };

  example = {
    plugins.editorconfig.enable = true;
    plugins.editorconfig.properties.foo = ''
      function(bufnr, val, opts)
        if opts.charset and opts.charset ~= "utf-8" then
          error("foo can only be set when charset is utf-8", 0)
        end
        vim.b[bufnr].foo = val
      end
    '';
  };
}
