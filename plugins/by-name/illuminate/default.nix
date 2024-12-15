{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.illuminate;

  mkListStr = helpers.defaultNullOpts.mkListOf types.str;

  commonOptions = with helpers.defaultNullOpts; {
    providers =
      mkListStr
        [
          "lsp"
          "treesitter"
          "regex"
        ]
        ''
          Provider used to get references in the buffer, ordered by priority.
        '';

    delay = mkInt 100 ''
      Delay in milliseconds.
    '';

    modesDenylist = mkListStr [ ] ''
      Modes to not illuminate, this overrides `modes_allowlist`.
      See `:help mode()` for possible values.
    '';

    modesAllowlist = mkListStr [ ] ''
      Modes to illuminate, this is overridden by `modes_denylist`.
      See `:help mode()` for possible values.
    '';

    providersRegexSyntaxDenylist = mkListStr [ ] ''
      Syntax to not illuminate, this overrides `providers_regex_syntax_allowlist`.
      Only applies to the 'regex' provider.
      Use `:echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')`.
    '';

    providersRegexSyntaxAllowlist = mkListStr [ ] ''
      Syntax to illuminate, this is overridden by `providers_regex_syntax_denylist`.
      Only applies to the 'regex' provider.
      Use `:echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')`.
    '';

    underCursor = mkBool true ''
      Whether or not to illuminate under the cursor.
    '';

    largeFileCutoff = helpers.mkNullOrOption types.int ''
      Number of lines at which to use `large_file_config`.
      The `under_cursor` option is disabled when this cutoff is hit.
    '';

    minCountToHighlight = mkInt 1 ''
      Minimum number of matches required to perform highlighting.
    '';
  };

  filetypeOptions = {
    filetypesDenylist =
      mkListStr
        [
          "dirvish"
          "fugitive"
        ]
        ''
          Filetypes to not illuminate, this overrides `filetypes_allowlist`.
        '';

    filetypesAllowlist = mkListStr [ ] ''
      Filetypes to illuminate, this is overridden by `filetypes_denylist`.
    '';
  };
in
{
  options.plugins.illuminate =
    with helpers;
    with defaultNullOpts;
    lib.nixvim.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "vim-illuminate";

      package = lib.mkPackageOption pkgs "vim-illuminate" {
        default = [
          "vimPlugins"
          "vim-illuminate"
        ];
      };

      filetypeOverrides =
        helpers.defaultNullOpts.mkAttrsOf (types.submodule { options = commonOptions; }) { }
          ''
            Filetype specific overrides.
            The keys are strings to represent the filetype.
          '';

      largeFileOverrides = mkOption {
        type = types.submodule { options = commonOptions // filetypeOptions; };
        description = ''
          Config to use for large files (based on large_file_cutoff).
          Supports the same keys passed to .configure
          If null, illuminate will be disabled for large files.
        '';
        default = { };
      };
    }
    // commonOptions
    // filetypeOptions;

  config =
    let
      filetypeSetupOptions =
        filetypeOptions: with filetypeOptions; {
          filetypes_denylist = filetypesDenylist;
          filetypes_allowlist = filetypesAllowlist;
        };
      commonSetupOptions =
        opts: with opts; {
          inherit providers;
          inherit delay;
          modes_denylist = modesDenylist;
          modes_allowlist = modesAllowlist;
          providers_regex_syntax_denylist = providersRegexSyntaxDenylist;
          providers_regex_syntax_allowlist = providersRegexSyntaxAllowlist;
          under_cursor = underCursor;
          large_file_cutoff = largeFileCutoff;
          min_count_to_highlight = minCountToHighlight;
        };
      setupOptions =
        with cfg;
        {
          large_file_overrides =
            (commonSetupOptions largeFileOverrides) // (filetypeSetupOptions largeFileOverrides);

          filetype_overrides = helpers.ifNonNull' filetypeOverrides (
            mapAttrs (_: commonSetupOptions) filetypeOverrides
          );
        }
        // (filetypeSetupOptions cfg)
        // (commonSetupOptions cfg);
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("illuminate").configure(${helpers.toLuaObject setupOptions})
      '';
    };
}
