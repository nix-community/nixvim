let
  # This plugin is deprecated
  warnings = expect: [
    (expect "count" 1)
    (expect "any" "This plugin is obsolete and will be removed after 24.11.")
  ];
in
{
  empty = {
    plugins.nvim-osc52.enable = true;

    test = { inherit warnings; };
  };

  defaults = {
    plugins.nvim-osc52 = {
      enable = true;

      maxLength = 0;
      silent = false;
      trim = false;

      keymaps = {
        silent = false;
        enable = true;
      };
    };

    test = { inherit warnings; };
  };
}
