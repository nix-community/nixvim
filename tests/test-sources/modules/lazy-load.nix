{
  example = {
    plugins.lz-n.enable = true;
    plugins = {
      cmp = {
        enable = true;
        settings = {
          sources = [ { name = "snippets"; } ];
          mapping.__raw = "require('cmp').mapping.preset.insert()";
        };
      };

      nvim-snippets = {
        enable = true;
        lazyLoad = {
          enable = true;
          event = "InsertEnter";
        };
      };

      telescope = {
        enable = true;
        lazyLoad = {
          enable = true;
          cmd = "Telescope";
        };
      };
    };

    colorschemes.ayu = {
      enable = true;
      settings.mirage = true;
      lazyLoad = {
        enable = true;
        event = "InsertEnter";
      };
    };
  };
}
