{
  lib,
  helpers,
  config,
  ...
}:
with lib;
let
  cfg = config.plugins.cmp-git;
in
{
  options.plugins.cmp-git.settings = helpers.neovim-plugin.mkSettingsOption {
    pluginName = "cmp_git";
    options = {
      filetypes =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "gitcommit"
            "octo"
          ]
          ''
            Filetypes for which to trigger.
          '';

      remotes =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "upstream"
            "origin"
          ]
          ''
            List of git remotes.
          '';

      enableRemoteUrlRewrites = helpers.defaultNullOpts.mkBool false ''
        Whether to enable remote URL rewrites.
      '';

      git = {
        commits = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of git commits to fetch.
          '';

          # FIXME should this by strLuaFn?
          sort_by = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.sort').git.commits";
          } "Function used to sort the commits.";

          # FIXME should this by strLuaFn?
          format = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.format').git.commits";
          } "Function used to format the commits.";
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

          # FIXME should this by strLuaFn?
          sort_by = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.sort').github.issues";
          } "Function used to sort the issues.";

          # FIXME should this by strLuaFn?
          format = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.format').github.issues";
          } "Function used to format the issues.";
        };

        mentions = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of mentions to fetch.
          '';

          # FIXME should this by strLuaFn?
          sort_by = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.sort').github.mentions";
          } "Function used to sort the mentions.";

          # FIXME should this by strLuaFn?
          format = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.format').github.mentions";
          } "Function used to format the mentions.";
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

          # FIXME should this by strLuaFn?
          sort_by = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.sort').github.pull_requests";
          } "Function used to sort the pull requests.";

          # FIXME should this by strLuaFn?
          format = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.format').github.pull_requests";
          } "Function used to format the pull requests.";
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

          # FIXME should this by strLuaFn?
          sort_by = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.sort').gitlab.issues";
          } "Function used to sort the issues.";

          # FIXME should this by strLuaFn?
          format = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.format').gitlab.issues";
          } "Function used to format the issues.";
        };

        mentions = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of mentions to fetch.
          '';

          # FIXME should this by strLuaFn?
          sort_by = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.sort').gitlab.mentions";
          } "Function used to sort the mentions.";

          # FIXME should this by strLuaFn?
          format = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.format').gitlab.mentions";
          } "Function used to format the mentions.";
        };

        merge_requests = {
          limit = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Max number of merge requests to fetch.
          '';

          state = helpers.defaultNullOpts.mkStr "open" ''
            Which issues to fetch (`"open"`, `"closed"`, `"locked"` or `"merged"`).
          '';

          # FIXME should this by strLuaFn?
          sort_by = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.sort').gitlab.merge_requests";
          } "Function used to sort the merge requests.";

          # FIXME should this by strLuaFn?
          format = helpers.defaultNullOpts.mkNullableWithRaw types.anything {
            __raw = "require('cmp_git.format').gitlab.merge_requests";
          } "Function used to format the merge requests.";
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
                type = helpers.nixvimTypes.strLuaFn;
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
        format.label.__raw = ''
          function(_, issue)
            local icon = ({
              open = '',
              closed = '',
            })[string.lower(issue.state)]
            return string.format('%s #%d: %s', icon, issue.number, issue.title)
          end
        '';
        sort_by.__raw = ''
          function(issue)
            local kind_rank = issue.pull_request and 1 or 0
            local state_rank = issue.state == 'open' and 0 or 1
            local age = os.difftime(os.time(), require('cmp_git.utils').parse_github_date(issue.updatedAt))
            return string.format('%d%d%010d', kind_rank, state_rank, age)
          end
        '';
        filter_fn.__raw = ''
          function(trigger_char, issue)
            return string.format('%s %s %s', trigger_char, issue.number, issue.title)
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
