lib:
let
  inherit (lib.nixvim) defaultNullOpts;
in
{
  no_default_rules = defaultNullOpts.mkFlagInt 0 ''
    Whether to disable the default rules.

    You can explicitly set default rules by calling `|lexima#set_default_rules()|`.
  '';

  map_escape = defaultNullOpts.mkStr "<Esc>" ''
    lexima.vim defines a insert mode mapping to `<Esc>` by default.

    If you don't want to map `<Esc>`, set this variable to another left-hand-side, or `""` to not
    create a default mapping to `|lexima#insmode#escape()|`.
  '';

  enable_basic_rules = defaultNullOpts.mkFlagInt 1 ''
    Whether to enable `|lexima-basic-rules|` by default.
  '';

  enable_newline_rules = defaultNullOpts.mkFlagInt 1 ''
    Whether to enable `|lexima-newline-rules|` by default.
  '';

  enable_space_rules = defaultNullOpts.mkFlagInt 1 ''
    Whether to enable `|lexima-space-rules|` by default.
  '';

  enable_endwise_rules = defaultNullOpts.mkFlagInt 1 ''
    Whether to enable `|lexima-endwise-rules|` by default.
  '';

  accept_pum_with_enter = defaultNullOpts.mkFlagInt 1 ''
    Whether `<cr>` can be used to accept completions when the `|popup-menu|` is visible.
  '';

  ctrlh_as_backspace = defaultNullOpts.mkFlagInt 0 ''
    Whether `<C-h>` should be usable in the same manner as `<BS>`.
  '';

  disable_on_nofile = defaultNullOpts.mkFlagInt 0 ''
    Whether to disable all lexima rules on `buftype=nofile`.
  '';

  disable_abbrev_trigger = defaultNullOpts.mkFlagInt 0 ''
    By default, lexima inputs `<C-]>` to expand an abbreviation.
    Set this option to `1` to disable this behavior.
  '';
}
