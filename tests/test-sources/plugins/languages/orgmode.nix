{
  empty = {
    plugins.orgmode.enable = true;
  };

  default = {
    plugins.orgmode = {
      enable = true;
      settings = {
        org_agenda_files = "";
        org_default_notes_file = "";
        org_startup_indented = false;
      };
    };
  };

  example = {
    plugins.orgmode = {
      enable = true;

      settings = {
        org_agenda_files = "~/orgfiles/**/*";
        org_default_notes_file = "~/orgfiles/refile.org";
        org_startup_indented = true;
      };
    };
  };
}
