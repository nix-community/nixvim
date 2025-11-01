{
  empty = {
    plugins = {
      treesitter.enable = true;
      ts-autotag.enable = true;
    };
  };

  default = {
    plugins = {
      treesitter.enable = true;
      ts-autotag = {
        enable = true;

        settings = {
          opts = {
            enable_close = true;
            enable_rename = true;
            enable_close_on_slash = true;
          };
          aliases = {
            "astro" = "html";
            "eruby" = "html";
            "vue" = "html";
            "htmldjango" = "html";
            "markdown" = "html";
            "php" = "html";
            "twig" = "html";
            "blade" = "html";
            "javascriptreact" = "typescriptreact";
            "javascript.jsx" = "typescriptreact";
            "typescript.tsx" = "typescriptreact";
            "javascript" = "typescriptreact";
            "typescript" = "typescriptreact";
            "rescript" = "typescriptreact";
            "handlebars" = "glimmer";
            "hbs" = "glimmer";
            "rust" = "rust";
          };
          per_filetype.__empty = { };
        };
      };
    };
  };

  example = {
    plugins = {
      treesitter.enable = true;
      ts-autotag = {
        enable = true;

        settings = {
          opts = {
            enable_close = true;
            enable_rename = true;
            enable_close_on_slash = false;
          };
          per_filetype = {
            html = {
              enable_close = false;
            };
          };
        };
      };
    };
  };
}
