{
  empty = {
    plugins.colorful-menu.enable = true;
  };

  default = {
    plugins.colorful-menu = {
      enable = true;

      settings = {
        ls = {
          lua_ls = {
            arguments_hl = "@comment";
          };
          gopls = {
            add_colon_before_type = false;
            align_type_to_right = true;
            preserve_type_when_truncate = true;
          };
          ts_ls = {
            extra_info_hl = "@comment";
          };
          vtsls = {
            extra_info_hl = "@comment";
          };
          zls = {
            align_type_to_right = true;
          };
          rust-analyzer = {
            extra_info_hl = "@comment";
            align_type_to_right = true;
            preserve_type_when_truncate = true;
          };
          clangd = {
            extra_info_hl = "@comment";
            import_dot_hl = "@comment";
            align_type_to_right = true;
            preserve_type_when_truncate = true;
          };
          roslyn = {
            extra_info_hl = "@comment";
          };
          basedpyright = {
            extra_info_hl = "@comment";
          };
          dartls = {
            extra_info_hl = "@comment";
          };
          fallback = true;
        };
        fallback_highlight = "@variable";
        max_width = 60;
      };
    };
  };
}
