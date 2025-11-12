{ lib, ... }:
{
  empty = {
    plugins.gitportal.enable = true;
  };

  defaults = {
    plugins.gitportal = {
      enable = true;

      settings = {
        always_include_current_line = false;
        always_use_commit_hash_in_url = false;
        browser_command = lib.nixvim.mkRaw "nil";
        default_remote = "origin";
        git_provider_map = lib.nixvim.mkRaw "nil";
        switch_branch_or_commit_upon_ingestion = "always";
      };
    };
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
