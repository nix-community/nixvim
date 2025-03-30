{
  empty = {
    plugins.highlight-colors.enable = true;
  };

  defaults = {
    plugins.highlight-colors = {
      enable = true;

      settings = {
        render = "background";
        enable_hex = true;
        enable_rgb = true;
        enable_hsl = true;
        enable_hsl_without_function = true;
        enable_var_usage = true;
        enable_named_colors = true;
        enable_short_hex = true;
        enable_tailwind = false;
        enable_ansi = false;
        custom_colors = null;
        virtual_symbol = "■";
        virtual_symbol_prefix = "";
        virtual_symbol_suffix = " ";
        virtual_symbol_position = "inline";
        exclude_filetypes = { };
        exclude_buftypes = { };
        exclude_buffer.__raw = "function(bufnr) end";
      };
    };
  };

  example = {
    plugins.highlight-colors = {
      enable = true;

      settings = {
        render = "virtual";
        virtual_symbol = "■";
        enable_named_colors = true;
      };
    };
  };
}
