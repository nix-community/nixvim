{
  empty = {
    plugins.nvim-ufo.enable = true;
  };

  example = {
    plugins.nvim-ufo = {
      enable = true;
      providerSelector = ''
        function(bufnr, filetype, buftype)
          local ftMap = {
            vim = "indent",
            python = {"indent"},
            git = ""
          }

         return ftMap[filetype]
        end
      '';

      foldVirtTextHandler = ''
        function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  %d '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, {chunkText, hlGroup})
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, {suffix, 'MoreMsg'})
          return newVirtText
        end
      '';
    };
  };

  defaults = {
    plugins.nvim-ufo = {
      enable = true;
      openFoldHlTimeout = 400;
      providerSelector = null;
      closeFoldKinds = {};
      foldVirtTextHandler = null;
      enableGetFoldVirtText = false;
      preview = {
        winConfig = {
          border = "rounded";
          winblend = 12;
          winhighlight = "Normal:Normal";
          maxheight = 20;
        };
        mappings = {};
      };
    };
  };
}
