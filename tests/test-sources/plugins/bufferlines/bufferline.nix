{
  empty = {
    plugins.bufferline.enable = true;
  };

  example = {
    plugins.bufferline = {
      enable = true;
      customFilter = ''
        function(buf_number, buf_numbers)
          -- filter out filetypes you don't want to see
          if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
              return true
          end
          -- filter out by buffer name
          if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
              return true
          end
          -- filter out based on arbitrary rules
          -- e.g. filter out vim wiki buffer from tabline in your work repo
          if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
              return true
          end
          -- filter out by it's index number in list (don't show first buffer)
          if buf_numbers[1] ~= buf_number then
              return true
          end
        end
      '';

      getElementIcon = ''
        function(element)
          -- element consists of {filetype: string, path: string, extension: string, directory: string}
          -- This can be used to change how bufferline fetches the icon
          -- for an element e.g. a buffer or a tab.
          -- e.g.
          local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(opts.filetype, { default = false })
          return icon, hl
        end
      '';
    };
  };

  defaults = {
    plugins.bufferline = {
      enable = true;
      mode = "buffers";
      themable = true;
      numbers = "none";
      bufferCloseIcon = "";
      modifiedIcon = "●";
      closeIcon = "";
      closeCommand = "bdelete! %d";
      leftMouseCommand = "buffer %d";
      rightMouseCommand = "bdelete! %d";
      middleMouseCommand = null;
      indicator = {
        icon = "▎";
        style = "icon";
      };
      leftTruncMarker = "";
      rightTruncMarker = "";
      separatorStyle = "thin";
      nameFormatter = null;
      truncateNames = true;
      tabSize = 18;
      maxNameLength = 18;
      colorIcons = true;
      showBufferIcons = true;
      showBufferCloseIcons = true;
      getElementIcon = null;
      showCloseIcon = true;
      showTabIndicators = true;
      showDuplicatePrefix = true;
      enforceRegularTabs = false;
      alwaysShowBufferline = true;
      persistBufferSort = true;
      maxPrefixLength = 15;
      sortBy = "id";
      diagnostics = false;
      diagnosticsIndicator = null;
      diagnosticsUpdateInInsert = true;
      offsets = null;
      groups = {
        items = [ ];
        options = {
          toggleHiddenOnEnter = true;
        };
      };
      hover = {
        enabled = false;
        reveal = [ ];
        delay = 200;
      };
      debug = {
        logging = false;
      };
      customFilter = null;
      highlights = { };
    };
  };
}
