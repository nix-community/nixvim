{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "colorful-menu";
  packPathName = "colorful-menu.nvim";
  package = "colorful-menu-nvim";

  description = ''
    To use this in `nvim-cmp` for example,
    ```nix
    plugins.cmp.settings.formatting.format.__raw = \'\'
      function(entry, vim_item)
        local highlights_info = require("colorful-menu").cmp_highlights(entry)

        -- highlight_info is nil means we are missing the ts parser, it's
        -- better to fallback to use default `vim_item.abbr`. What this plugin
        -- offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
        if highlights_info ~= nil then
            vim_item.abbr_hl_group = highlights_info.highlights
            vim_item.abbr = highlights_info.text
        end

        return vim_item
      end
    \'\';
    ```

    Learn more in the [README](https://github.com/xzbdmw/colorful-menu.nvim).
  '';

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    ls = {
      lua_ls.arguments_hl = "@comment";
      pyright.extra_info_hl = "@comment";
      fallback = true;
    };
    fallback_highlight = "@variable";
    max_width = 60;
  };
}
