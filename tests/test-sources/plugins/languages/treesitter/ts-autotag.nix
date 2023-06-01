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
        filetypes = [
          "html"
          "javascript"
          "typescript"
          "javascriptreact"
          "typescriptreact"
          "svelte"
          "vue"
          "tsx"
          "jsx"
          "rescript"
          "xml"
          "php"
          "markdown"
          "astro"
          "glimmer"
          "handlebars"
          "hbs"
        ];
        skipTags = [
          "area"
          "base"
          "br"
          "col"
          "command"
          "embed"
          "hr"
          "img"
          "slot"
          "input"
          "keygen"
          "link"
          "meta"
          "param"
          "source"
          "track"
          "wbr"
          "menuitem"
        ];
      };
    };
  };
}
