{
  empty = {
    plugins.ledger.enable = true;
  };

  defaults = {
    plugins.ledger = {
      enable = true;

      settings = {
        bin = null;
        is_hledger = null;
        extra_options = "";
        accounts_cmd = null;
        descriptions_cmd = null;
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
        qf_register_format = null;
        qf_reconcile_format = null;
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
