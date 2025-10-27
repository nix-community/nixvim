{
  empty = {
    plugins.ledger.enable = true;
  };

  defaults = {
    plugins.ledger = {
      enable = true;

      settings = {
        bin.__raw = "nil";
        is_hledger.__raw = "nil";
        extra_options = "";
        accounts_cmd.__raw = "nil";
        descriptions_cmd.__raw = "nil";
        maxwidth = 0;
        fillstring = " ";
        detailed_first = 1;
        fold_blanks = 0;
        decimal_sep = ".";
        align_last = 0;
        align_at = 60;
        default_commodity = "";
        align_commodity = 0;
        commodity_before = 1;
        commodity_sep = "";
        commodity_spell = 0;
        date_format = "%Y/%m/%d";
        main = "%";
        winpos = "B";
        qf_register_format.__raw = "nil";
        qf_reconcile_format.__raw = "nil";
        use_location_list = 0;
        qf_vertical = 0;
        qf_size = 10;
        qf_hide_file = 1;
        cleared_string = "Cleared: ";
        pending_string = "Cleared or pending: ";
        target_string = "Difference from target: ";
      };
    };
  };
}
