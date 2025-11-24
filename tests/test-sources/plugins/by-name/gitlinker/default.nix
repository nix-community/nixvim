{ lib }:
{
  empty = {
    plugins.gitlinker.enable = true;
  };

  example = {
    plugins.gitlinker = {
      enable = true;

      settings = {
        opts = {
          action_callback = lib.nixvim.mkRaw ''
            function(url)
              -- yank to unnamed register
              vim.api.nvim_command("let @\" = '" .. url .. "'")
              -- copy to the system clipboard using OSC52
              vim.fn.OSCYankString(url)
            end
          '';
          print_url = false;
        };
      };
    };
  };

  defaults = {
    plugins.gitlinker = {
      enable = true;

      settings = {
        opts = {
          remote.__raw = "nil";
          add_current_line_on_normal_mode = true;
          action_callback = lib.nixvim.mkRaw "require('gitlinker.actions').copy_to_clipboard";
          print_url = true;
          mappings = "<leader>gy";
        };
        callbacks = {
          "github.com" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_github_type_url";
          "gitlab.com" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_gitlab_type_url";
          "try.gitea.io" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_gitea_type_url";
          "codeberg.org" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_gitea_type_url";
          "bitbucket.org" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_bitbucket_type_url";
          "try.gogs.io" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_gogs_type_url";
          "git.sr.ht" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_srht_type_url";
          "git.launchpad.net" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_launchpad_type_url";
          "repo.or.cz" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_repoorcz_type_url";
          "git.kernel.org" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_cgit_type_url";
          "git.savannah.gnu.org" = lib.nixvim.mkRaw "require('gitlinker.hosts').get_cgit_type_url";
        };
      };
    };
  };
}
