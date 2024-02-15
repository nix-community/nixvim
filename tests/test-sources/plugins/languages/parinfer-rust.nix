{
  empty = {
    plugins.parinfer-rust.enable = true;
  };

  defaults = {
    plugins.parinfer-rust = {
      enable = true;

      settings = {
        mode = "smart";
        enabled = true;
        force_balance = false;
        comment_char = ";";
        string_delimiters = [''"''];
        lisp_vline_symbols = false;
        lisp_block_comments = false;
        guile_block_comments = false;
        scheme_sexp_comments = false;
        janet_long_strings = false;
      };
    };
  };
}
