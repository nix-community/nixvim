{
  disable = {
    editorconfig.enable = false;
  };

  example = {
    editorconfig.enable = true;
    editorconfig.properties.foo = ''
      function(bufnr, val, opts)
        if opts.charset and opts.charset ~= "utf-8" then
          error("foo can only be set when charset is utf-8", 0)
        end
        vim.b[bufnr].foo = val
      end
    '';
  };
}
