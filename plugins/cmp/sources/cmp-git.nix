{
  lib,
  helpers,
  config,
  ...
}:
with lib;
let
  cfg = config.plugins.cmp-git;

  mkAction =
    action: target:
    helpers.defaultNullOpts.mkLuaFn "require('cmp_git.${action}').git.${target}" ''
      Function used to ${action} the ${replaceStrings [ "_" ] [ " " ] target}.
    '';
in
{
  options.plugins.cmp-git.settings = helpers.mkSettingsOption {
    description = "Options provided to the `require('cmp_git').setup` function.";
    options = {
      filetypes = helpers.defaultNullOpts.mkListOf types.str [
        "gitcommit"
        "octo"
      ] "Filetypes for which to trigger.";

      remotes = helpers.defaultNullOpts.mkListOf types.str [
        "upstream"
        "origin"
      ] "List of git remotes.";

      enableRemoteUrlRewrites = helpers.defaultNullOpts.mkBool false ''
        Whether to enable remote URL rewrites.
      '';

      git = {
        commits = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of git commits to fetch.
          '';

          sort_by = mkAction "sort" "commits";
          format = mkAction "format" "commits";
        };
      };

      github = {
        hosts = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          List of private instances of github.
        '';

        issues = {
          fields = helpers.defaultNullOpts.mkListOf types.str [
            "title"
            "number"
            "body"
            "updatedAt"
            "state"
          ] "The fields used for issues.";

          filter = helpers.defaultNullOpts.mkStr "all" ''
            The filter to use when fetching issues.
          '';

          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of issues to fetch.
          '';

          state = helpers.defaultNullOpts.mkStr "open" ''
            Which issues to fetch (`"open"`, `"closed"` or `"all"`).
          '';

          sort_by = mkAction "sort" "issues";
          format = mkAction "format" "issues";
        };

        mentions = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of mentions to fetch.
          '';

          sort_by = mkAction "sort" "mentions";
          format = mkAction "format" "mentions";
        };

        pull_requests = {
          fields = helpers.defaultNullOpts.mkListOf types.str [
            "title"
            "number"
            "body"
            "updatedAt"
            "state"
          ] "The fields used for pull requests.";

          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of pull requests to fetch.
          '';

          state = helpers.defaultNullOpts.mkStr "open" ''
            Which issues to fetch (`"open"`, `"closed"`, `"merged"` or `"all"`).
          '';

          sort_by = mkAction "sort" "pull_requests";
          format = mkAction "format" "pull_requests";
        };
      };

      gitlab = {
        hosts = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          List of private instances of gitlab.
        '';

        issues = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of issues to fetch.
          '';

          state = helpers.defaultNullOpts.mkStr "open" ''
            Which issues to fetch (`"open"`, `"closed"` or `"all"`).
          '';

          sort_by = mkAction "sort" "issues";
          format = mkAction "format" "issues";
        };

        mentions = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of mentions to fetch.
          '';

          sort_by = mkAction "sort" "mentions";
          format = mkAction "format" "mentions";
        };

        merge_requests = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of merge requests to fetch.
          '';

          state = helpers.defaultNullOpts.mkStr "open" ''
            Which issues to fetch (`"open"`, `"closed"`, `"locked"` or `"merged"`).
          '';

          sort_by = mkAction "sort" "merge_requests";
          format = mkAction "format" "merge_requests";
        };
      };

      trigger_actions =
        helpers.defaultNullOpts.mkListOf
          (types.submodule {
            options = {
              debug_name = helpers.mkNullOrStr "Debug name.";

              trigger_character = mkOption {
                type = types.str;
                example = ":";
                description = ''
                  The trigger character.
                  Has to be a single character
                '';
              };

              action = mkOption {
                type = lib.types.strLuaFn;
                apply = helpers.mkRaw;
                description = ''
                  The parameters to the action function are the different sources (currently `git`,
                  `gitlab` and `github`), the completion callback, the trigger character, the
                  parameters passed to complete from nvim-cmp, and the current git info.
                '';
                example = ''
                  function(sources, trigger_char, callback, params, git_info)
                    return sources.git:get_commits(callback, params, trigger_char)
                  end
                '';
              };
            };
          })
          [
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
              debug_name = "gitlab_issues";
              trigger_character = "#";
              action = ''
                function(sources, trigger_char, callback, params, git_info)
                    return sources.gitlab:get_issues(callback, git_info, trigger_char)
                end
              '';
            }
            {
              debug_name = "gitlab_mentions";
              trigger_character = "@";
              action = ''
                function(sources, trigger_char, callback, params, git_info)
                    return sources.gitlab:get_mentions(callback, git_info, trigger_char)
                end
              '';
            }
            {
              debug_name = "gitlab_mrs";
              trigger_character = "!";
              action = ''
                function(sources, trigger_char, callback, params, git_info)
                  return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
                end
              '';
            }
            {
              debug_name = "github_issues_and_pr";
              trigger_character = "#";
              action = ''
                function(sources, trigger_char, callback, params, git_info)
                  return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
                end
              '';
            }
            {
              debug_name = "github_mentions";
              trigger_character = "@";
              action = ''
                function(sources, trigger_char, callback, params, git_info)
                  return sources.github:get_mentions(callback, git_info, trigger_char)
                end
              '';
            }
          ]
          ''
            If you want specific behaviour for a trigger or new behaviour for a trigger, you need to
            add an entry in the `trigger_actions` list of the config.
            The two necessary fields are the `trigger_character` and the `action`.
          '';
    };

    example = {
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
  };

  config = mkIf cfg.enable {
    extraConfigLua = ''
      require('cmp_git').setup(${helpers.toLuaObject cfg.settings})
    '';
  };
}
