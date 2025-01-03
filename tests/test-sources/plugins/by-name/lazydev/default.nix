{
  empty = {
    plugins.lazydev.enable = true;
  };

  defaults = {
    plugins.lazydev = {
      enable = true;

      settings = {
        enabled.__raw = ''
          function(root_dir)
            return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
          end
        '';
        integrations = {
          lspconfig = true;
          cmp = true;
          coq = false;
        };
        library.__raw = "{}";
        runtime.__raw = "vim.env.VIMRUNTIME";
      };
    };
  };

  example = {
    plugins.lazydev = {
      enable = true;

      settings = {
        enabled.__raw = ''
          function(root_dir)
            return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
          end
        '';
        library = [
          "~/projects/my-awesome-lib"
          "lazy.nvim"
          "LazyVim"
          {
            path = "LazyVim";
            words = [ "LazyVim" ];
          }
        ];
        runtime.__raw = "vim.env.VIMRUNTIME";
      };
    };
  };
}
