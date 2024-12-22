{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.marks;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.marks = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "marks.nvim";

    package = lib.mkPackageOption pkgs "marks.nvim" {
      default = [
        "vimPlugins"
        "marks-nvim"
      ];
    };

    builtinMarks =
      helpers.defaultNullOpts.mkListOf
        (types.enum [
          "'"
          "^"
          "."
          "<"
          ">"
        ])
        [ ]
        ''
          Which builtin marks to track and show. If set, these marks will also show up in the
          signcolumn and will update on `|CursorMoved|`.
        '';

    defaultMappings = helpers.defaultNullOpts.mkBool true ''
      Whether to use the default plugin mappings or not.
      See `|marks-mappings|` for more.
    '';

    signs = helpers.defaultNullOpts.mkBool true ''
      Whether to show marks in the signcolumn or not.
      If set to true, its recommended to also set `|signcolumn|` to "auto", for cases where
      multiple marks are placed on the same line.
    '';

    cyclic = helpers.defaultNullOpts.mkBool true ''
      Whether forward/backwards movement should cycle back to the beginning/end of buffer.
    '';

    forceWriteShada = helpers.defaultNullOpts.mkBool false ''
      If true, then deleting global (uppercase) marks will also update the `|shada|` file
      accordingly and force deletion of the mark permanently.
      This option can be destructive and should be set only after reading more about the shada
      file.
    '';

    refreshInterval = helpers.defaultNullOpts.mkUnsignedInt 150 ''
      How often (in ms) `marks.nvim` should update the marks list and recompute mark
      positions/redraw signs.
      Lower values means that mark positions and signs will refresh much quicker, but may incur a
      higher performance penalty, whereas higher values may result in better performance, but may
      also cause noticeable lag in signs updating.
    '';

    signPriority =
      helpers.defaultNullOpts.mkNullable
        (
          with types;
          either ints.unsigned (submodule {
            freeformType = attrs;
            options = mapAttrs (name: desc: helpers.mkNullOrOption ints.unsigned "Sign priority for ${desc}.") {
              lower = "lowercase marks";
              upper = "uppercase marks";
              builtin = "builtin marks";
              bookmark = "bookmarks";
            };
          })
        )
        10
        ''
          The sign priority to be used for marks.
          Can either be a number, in which case the priority applies to all types of marks, or a
          table with some or all of the following keys:

          - lower: sign priority for lowercase marks
          - upper: sign priority for uppercase marks
          - builtin: sign priority for builtin marks
          - bookmark: sign priority for bookmarks
        '';

    excludedFiletypes = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Which filetypes to ignore.
      If a buffer with this filetype is opened, then `marks.nvim` will not track any marks set in
      this buffer, and will not display any signs.
      Setting and moving to marks with ` or ' will still work, but movement commands like "m]" or
      "m[" will not.
    '';

    excludedBuftypes = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Which buftypes to ignore.
      If a buffer with this buftype is opened, then `marks.nvim` will not track any marks set in
      this buffer, and will not display any signs.
      Setting and moving to marks with ` or ' will still work, but movement commands like "m]" or
      "m[" will not.
    '';

    bookmarks = mkOption {
      description = "Configuration table for each bookmark group (see `|marks-bookmarks|`).";
      type =
        with types;
        attrsOf (submodule {
          options = {
            sign = helpers.mkNullOrOption (either str (enum [ false ])) ''
              The character to use in the signcolumn for this bookmark group.

              Defaults to "!@#$%^&*()" - in order from group 1 to 10.
              Set to `false` to turn off signs for this bookmark.
            '';

            virtText = helpers.mkNullOrOption str ''
              Virtual text annotations to place at the eol of a bookmark.
              Defaults to `null`, meaning no virtual text.
            '';

            annotate = helpers.defaultNullOpts.mkBool false ''
              When true, explicitly prompts the user for an annotation that will be displayed
              above the bookmark.
            '';
          };
        });
      default = { };
      apply = mapAttrs (
        _: v: with v; {
          inherit sign;
          virt_text = virtText;
          inherit annotate;
        }
      );
    };

    mappings = helpers.defaultNullOpts.mkAttrsOf (with types; either str (enum [ false ])) { } ''
      Custom mappings.
      Set a mapping to `false` to disable it.
    '';
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    assertions = [
      {
        assertion = all (n: elem n (range 0 9)) (attrNames cfg.bookmarks);
        message = ''
          Nixvim (plugins.marks): The keys of the `bookmarks` option should be integers between 0 and 9.
        '';
      }
    ];

    extraConfigLua =
      let
        bookmarks = mapAttrs' (
          bookmarkNumber: bookmarkOptions: nameValuePair "bookmark_${bookmarkNumber}" bookmarkOptions
        ) cfg.bookmarks;

        setupOptions =
          with cfg;
          {
            builtin_marks = builtinMarks;
            default_mappings = defaultMappings;
            inherit signs cyclic;
            force_write_shada = forceWriteShada;
            refresh_interval = refreshInterval;
            sign_priority = signPriority;
            excluded_filetypes = excludedFiletypes;
            excluded_buftypes = excludedBuftypes;
            inherit mappings;
          }
          // bookmarks
          // cfg.extraOptions;
      in
      ''
        require('marks').setup(${lib.nixvim.toLuaObject setupOptions})
      '';
  };
}
