{
  empty = {
    plugins.no-neck-pain.enable = true;
  };

  defaults = {
    plugins.no-neck-pain = {
      enable = true;

      settings = {
        debug = false;
        width = 100;
        minSideBufferWidth = 10;
        disableOnLastBuffer = false;
        killAllBuffersOnDisable = false;
        fallbackOnBufferDelete = true;

        autocmds = {
          enableOnVimEnter = false;
          enableOnTabEnter = false;
        };

        mappings = {
          enabled = false;
          toggle = "<Leader>np";
        };

        buffers = {
          setNames = false;
          colors = {
            background = null;
            blend = 0;
          };
          left = {
            enabled = true;
          };
          right = {
            enabled = true;
          };
        };

        integrations = {
          NvimTree = {
            position = "left";
            reopen = true;
          };
        };
      };
    };
  };

  example = {
    plugins.no-neck-pain.enable = true;
    plugins.no-neck-pain.settings = {
      width = 80;
      autocmds = {
        enableOnVimEnter = true;
        skipEnteringNoNeckPainBuffer = true;
      };
      buffers = {
        colors = {
          background = "catppuccin-frappe";
          blend = -0.1;
        };
        scratchPad = {
          enabled = true;
          fileName = "notes";
          location = "~/";
        };
        bo = {
          filetype = "md";
        };
      };
    };
  };
}
