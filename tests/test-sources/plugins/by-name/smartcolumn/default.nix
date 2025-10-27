{
  empty = {
    plugins.smartcolumn.enable = true;
  };

  default = {
    plugins.smartcolumn = {
      settings = {
        colorcolumn = "80";
        disabled_filetypes = [
          "help"
          "text"
          "markdown"
        ];
        scope = "file";
        custom_colorcolumn.__empty = { };
      };
    };
  };

  example = {
    plugins.smartcolumn = {
      settings = {
        colorcolumn = "100";
        disabled_filetypes = [
          "checkhealth"
          "help"
          "lspinfo"
          "markdown"
          "neo-tree"
          "noice"
          "text"
        ];
        custom_colorcolumn = {
          go = [
            "100"
            "130"
          ];
          java = [
            "100"
            "140"
          ];
          nix = [
            "100"
            "120"
          ];
          rust = [
            "80"
            "100"
          ];
        };
        scope = "window";
      };
    };
  };

  function-colorcolumn = {
    plugins.smartcolumn = {
      settings.custom_colorcolumn.__raw = ''
        -- Supports custom logic from a function
        function ()
         return "100"
        end
      '';
    };
  };
}
