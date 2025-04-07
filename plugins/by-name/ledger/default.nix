{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.plugins;
mkVimPlugin {
  name = "ledger";
  packPathName = "vim-ledger";
  package = "vim-ledger";
  globalPrefix = "ledger_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "detailedFirst"
    "foldBlanks"
    {
      old = "maxWidth";
      new = "maxwidth";
    }
    {
      old = "fillString";
      new = "fillstring";
    }
  ];
  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "ledger";
      packageName = "ledger";
    })
  ];

  extraConfig = {
    dependencies.ledger.enable = lib.mkDefault true;
  };

  settingsOptions = {
    bin = helpers.mkNullOrStr ''
      Path to the `ledger` executable.
    '';

    is_hledger = helpers.mkNullOrOption types.bool ''
      Whether to use ledger or hledger specific features.
      Setting this value is optional and in most coses will be guessed correctly based on `bin`,
      but in the event it isn't guessed correctly or you want to use different syntax features
      even with your default tooling setup for the other engine this flag can be set to override
      the value.
    '';

    extra_options = helpers.defaultNullOpts.mkStr "" ''
      Additional default options for the `ledger` executable.
    '';

    accounts_cmd = helpers.mkNullOrStr ''
      To use a custom external system command to generate a list of account names for completion,
      set the following.
      If `bin` is set, this will default to running that command with arguments to parse the
      current file using the accounts subcommand (works with ledger or hledger), otherwise it will
      parse the postings in the current file itself.
    '';

    descriptions_cmd = helpers.mkNullOrStr ''
      To use a custom external system command to generate a list of descriptions for completion,
      set the following.
      If `bin` is set, this will default to running that command with arguments to parse the
      current file using the descriptions subcommand (works with ledger or hledger), otherwise it
      will parse the transactions in the current file itself.
    '';

    maxwidth = helpers.defaultNullOpts.mkUnsignedInt 0 ''
      Number of columns that will be used to display the foldtext.
      Set this when you think that the amount is too far off to the right.
      When `maxwidth` is zero, the amount will be displayed at the far right side of the screen.
    '';

    fillstring = helpers.defaultNullOpts.mkStr " " ''
      String that will be used to fill the space between account name and amount in the foldtext.
      Set this to get some kind of lines or visual aid.
    '';

    detailed_first = helpers.defaultNullOpts.mkFlagInt 1 ''
      If you want the account completion to be sorted by level of detail/depth instead of
      alphabetical, set this option to `1`.
    '';

    fold_blanks = helpers.defaultNullOpts.mkFlagInt 0 ''
      By default vim will fold ledger transactions, leaving surrounding blank lines unfolded.
      You can use this option to hide blank lines following a transaction.

      A value of `0` will disable folding of blank lines, `1` will allow folding of a
      single blank line between transactions; any larger value will enable folding
      unconditionally.

      Note that only lines containing no trailing spaces are considered for folding.
      You can take advantage of this to disable this feature on a case-by-case basis.
    '';

    decimal_sep = helpers.defaultNullOpts.mkStr "." ''
      Decimal separator.
    '';

    align_last = helpers.defaultNullOpts.mkFlagInt 0 ''
      Specify alignment on first or last matching separator.
    '';

    align_at = helpers.defaultNullOpts.mkUnsignedInt 60 ''
      Specify at which column decimal separators should be aligned.
    '';

    default_commodity = helpers.defaultNullOpts.mkStr "" ''
      Default commodity used by `ledger#align_amount_at_cursor()`.
    '';

    align_commodity = helpers.defaultNullOpts.mkFlagInt 0 ''
      Align on the commodity location instead of the amount
    '';

    commodity_before = helpers.defaultNullOpts.mkFlagInt 1 ''
      Flag that tells whether the commodity should be prepended or appended to the amount.
    '';

    commodity_sep = helpers.defaultNullOpts.mkStr "" ''
      String to be put between the commodity and the amount:
    '';

    commodity_spell = helpers.defaultNullOpts.mkFlagInt 0 ''
      Flag that enable the spelling of the amount.
    '';

    date_format = helpers.defaultNullOpts.mkStr "%Y/%m/%d" ''
      Format of transaction date.
    '';

    main = helpers.defaultNullOpts.mkStr "%" ''
      The file to be used to generate reports.
      The default is to use the current file.
    '';

    winpos = helpers.defaultNullOpts.mkStr "B" ''
      Position of a report buffer.

      Use `b` for bottom, `t` for top, `l` for left, `r` for right.
      Use uppercase letters if you want the window to always occupy the full width or height.
    '';

    qf_register_format = helpers.mkNullOrStr ''
      Format of quickfix register reports (see `|:Register|`).
      The format is specified using the standard Ledger syntax for `--format`.
    '';

    qf_reconcile_format = helpers.mkNullOrStr ''
      Format of the reconcile quickfix window (see `|:Reconcile|`).
      The format is specified using the standard Ledger syntax for `--format`.
    '';

    use_location_list = helpers.defaultNullOpts.mkFlagInt 0 ''
      Flag that tells whether a location list or a quickfix list should be used:
      The default is to use the quickfix window.
      Set to `1` to use a location list.
    '';

    qf_vertical = helpers.defaultNullOpts.mkFlagInt 0 ''
      Position of the quickfix/location list.
      Set to `1` to open the quickfix window in a vertical split.
    '';

    qf_size = helpers.defaultNullOpts.mkUnsignedInt 10 ''
      Size of the quickfix window.

      This is the number of lines of a horizontal quickfix window, or the number of columns of a
      vertical quickfix window.
    '';

    qf_hide_file = helpers.defaultNullOpts.mkFlagInt 1 ''
      Flag to show or hide filenames in the quickfix window:

      Filenames in the quickfix window are hidden by default. Set this to 1 is
      you want filenames to be visible.
    '';

    cleared_string = helpers.defaultNullOpts.mkStr "Cleared: " ''
      Text of the output of the `|:Balance|` command.
    '';

    pending_string = helpers.defaultNullOpts.mkStr "Cleared or pending: " ''
      Text of the output of the `|:Balance|` command.
    '';

    target_string = helpers.defaultNullOpts.mkStr "Difference from target: " ''
      Text of the output of the `|:Balance|` command.
    '';
  };

  settingsExample = {
    detailed_first = 1;
    fold_blanks = 0;
    maxwidth = 80;
    fillstring = " ";
  };
}
