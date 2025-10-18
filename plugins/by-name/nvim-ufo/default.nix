{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-ufo";
  moduleName = "ufo";
  package = "nvim-ufo";
  description = "An Neovim plugin for managing folds with LSP support.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    open_fold_hl_timeout = defaultNullOpts.mkUnsignedInt 400 ''
      Time in millisecond between the range to be highlgihted and to be cleared
      while opening the folded line, `0` value will disable the highlight.
    '';

    provider_selector = defaultNullOpts.mkLuaFn null ''
      A lua function as a selector for fold providers.
    '';

    close_fold_kinds_for_ft = defaultNullOpts.mkAttrsOf lib.types.anything { default = { }; } ''
      After the buffer is displayed (opened for the first time), close the
      folds whose range with `kind` field is included in this option. For now,
      'lsp' provider's standardized kinds are 'comment', 'imports' and 'region',
      run `UfoInspect` for details if your provider has extended the kinds.
    '';

    fold_virt_text_handler = defaultNullOpts.mkLuaFn null "A lua function to customize fold virtual text.";

    enable_get_fold_virt_text = defaultNullOpts.mkBool false ''
      Enable a function with `lnum` as a parameter to capture the virtual text
      for the folded lines and export the function to `get_fold_virt_text` field of
      ctx table as 6th parameter in `fold_virt_text_handler`
    '';

    preview = {
      win_config = {
        border = defaultNullOpts.mkBorder "rounded" "preview window" "";

        winblend = defaultNullOpts.mkUnsignedInt 12 "The winblend for preview window, `:h winblend`.";

        winhighlight = defaultNullOpts.mkStr "Normal:Normal" "The winhighlight for preview window, `:h winhighlight`.";

        maxheight = defaultNullOpts.mkUnsignedInt 20 "The max height of preview window.";
      };

      mappings = lib.nixvim.mkNullOrOption lib.types.attrs "Mappings for preview window.";
    };
  };

  settingsExample = {
    provider_selector = # Lua
      ''
        function(bufnr, filetype, buftype)
          local ftMap = {
            vim = "indent",
            python = {"indent"},
            git = ""
          }

         return ftMap[filetype]
        end
      '';
    fold_virt_text_handler = # Lua
      ''
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

  extraOptions = {
    setupLspCapabilities = lib.nixvim.options.mkEnabledOption "setup LSP capabilities for nvim-ufo";
  };

  extraConfig = cfg: {
    plugins.lsp.capabilities =
      lib.mkIf cfg.setupLspCapabilities # lua
        ''
          -- Capabilities configuration for nvim-ufo
          capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
          }
        '';
  };
}
