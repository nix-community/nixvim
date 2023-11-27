{
  empty = {
    plugins.gitlinker.enable = true;
  };

  defaults = {
    plugins.gitlinker = {
      enable = true;

      remote = null;
      addCurrentLineOnNormalMode = true;
      actionCallback = "copy_to_clipboard";
      printUrl = true;
      mappings = "<leader>gy";

      callbacks = {
        "github.com" = "get_github_type_url";
        "gitlab.com" = "get_gitlab_type_url";
        "try.gitea.io" = "get_gitea_type_url";
        "codeberg.org" = "get_gitea_type_url";
        "bitbucket.org" = "get_bitbucket_type_url";
        "try.gogs.io" = "get_gogs_type_url";
        "git.sr.ht" = "get_srht_type_url";
        "git.launchpad.net" = "get_launchpad_type_url";
        "repo.or.cz" = "get_repoorcz_type_url";
        "git.kernel.org" = "get_cgit_type_url";
        "git.savannah.gnu.org" = "get_cgit_type_url";
      };
    };
  };
}
