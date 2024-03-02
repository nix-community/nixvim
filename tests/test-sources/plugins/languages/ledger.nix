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
        detailed_first = true;
        fold_blanks = false;
        decimal_sep = ".";
        align_last = false;
        align_at = 60;
        default_commodity = "";
        align_commodity = false;
        commodity_before = true;
        commodity_sep = "";
        commodity_spell = false;
        date_format = "%Y/%m/%d";
        main = "%";
        winpos = "B";
        qf_register_format = null;
        qf_reconcile_format = null;
        use_location_list = false;
        qf_vertical = false;
        qf_size = 10;
        qf_hide_file = true;
        cleared_string = "Cleared: ";
        pending_string = "Cleared or pending: ";
        target_string = "Difference from target: ";
      };
    };
  };
}
