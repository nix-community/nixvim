{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cmp-git";
  moduleName = "cmp_git";

  imports = [
    { cmpSourcePlugins.git = "cmp-git"; }
  ];

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = import ./settings-options.nix { inherit lib; };

  settingsExample = {
    remotes = [
      "upstream"
      "origin"
      "foo"
    ];
    github.issues = {
      filter = "all";
      limit = 250;
      state = "all";
      format = ''
        function(_, issue)
          local icon = ({
            open = '',
            closed = '',
          })[string.lower(issue.state)]
          return string.format('%s #%d: %s', icon, issue.number, issue.title)
        end
      '';
      sort_by = ''
        function(issue)
          local kind_rank = issue.pull_request and 1 or 0
          local state_rank = issue.state == 'open' and 0 or 1
          local age = os.difftime(os.time(), require('cmp_git.utils').parse_github_date(issue.updatedAt))
          return string.format('%d%d%010d', kind_rank, state_rank, age)
        end
      '';
    };
    trigger_actions = [
      {
        debug_name = "git_commits";
        trigger_character = ":";
        action = ''
          function(sources, trigger_char, callback, params, git_info)
            return sources.git:get_commits(callback, params, trigger_char)
          end
        '';
      }
      {
        debug_name = "github_issues";
        trigger_character = "#";
        action = ''
          function(sources, trigger_char, callback, params, git_info)
            return sources.github:get_issues(callback, git_info, trigger_char)
          end
        '';
      }
    ];
  };
}
