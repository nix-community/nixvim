{
  empty = {
    plugins.gitportal.enable = true;
  };

  example = {
    plugins.gitportal = {
      enable = true;
      settings = {
        always_include_current_line = true;
        default_remote = "upstream";
        switch_branch_or_commit_upon_ingestion = "ask_first";
      };
    };
  };
}
