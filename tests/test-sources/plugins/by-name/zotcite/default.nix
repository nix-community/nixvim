{
  empty = {
    plugins.zotcite.enable = true;
  };

  defaults = {
    plugins.zotcite = {
      enable = true;

      settings = {
        hl_cite_key = true;
        conceallevel = 2;
        wait_attachment = false;
        open_in_zotero = false;
        filetypes = [
          "markdown"
          "pandoc"
          "rmd"
          "quarto"
          "vimwiki"
        ];
      };
    };
  };

  example = {
    plugins.zotcite = {
      enable = true;

      settings = {
        hl_cite_key = false;
        wait_attachment = true;
        open_in_zotero = true;
        filetypes = [
          "markdown"
          "quarto"
        ];
      };
    };
  };
}
