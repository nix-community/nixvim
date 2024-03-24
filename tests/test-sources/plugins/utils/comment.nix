{
  empty = {
    plugins.comment.enable = true;
  };

  defaults = {
    plugins.comment = {
      enable = true;

      settings = {
        padding = true;
        sticky = true;
        ignore = null;
        toggler = {
          line = "gcc";
          block = "gbc";
        };
        opleader = {
          line = "gc";
          block = "gb";
        };
        extra = {
          above = "gcO";
          below = "gco";
          eol = "gcA";
        };
        mappings = {
          basic = true;
          extra = true;
        };
        pre_hook = null;
        post_hook = null;
      };
    };
  };

  example = {
    plugins = {
      treesitter.enable = true;
      ts-context-commentstring.enable = true;

      comment = {
        enable = true;

        settings = {
          ignore = "^const(.*)=(%s?)%((.*)%)(%s?)=>";
          pre_hook = "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
          post_hook = ''
            function(ctx)
                if ctx.range.srow == ctx.range.erow then
                    -- do something with the current line
                else
                    -- do something with lines range
                end
            end
          '';
        };
      };
    };
  };
}
