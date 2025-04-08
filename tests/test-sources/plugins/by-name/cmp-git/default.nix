{
  defaults = {
    plugins = {
      cmp.enable = true;

      cmp-git.enable = true;
      cmp-git.settings = {
        filetypes = [
          "gitcommit"
          "octo"
        ];
        remotes = [
          "upstream"
          "origin"
        ];
        enableRemoteUrlRewrites = false;
        git = {
          commits = {
            limit = 100;
            sort_by = "require('cmp_git.sort').git.commits";
            format = "require('cmp_git.format').git.commits";
          };
        };
        github = {
          hosts = [ ];
          issues = {
            fields = [
              "title"
              "number"
              "body"
              "updatedAt"
              "state"
            ];
            filter = "all";
            limit = 100;
            state = "open";
            sort_by = "require('cmp_git.sort').github.issues";
            format = "require('cmp_git.format').github.issues";
          };
          mentions = {
            limit = 100;
            sort_by = "require('cmp_git.sort').github.mentions";
            format = "require('cmp_git.format').github.mentions";
          };
          pull_requests = {
            fields = [
              "title"
              "number"
              "body"
              "updatedAt"
              "state"
            ];
            limit = 100;
            state = "open";
            sort_by = "require('cmp_git.sort').github.pull_requests";
            format = "require('cmp_git.format').github.pull_requests";
          };
        };
        gitlab = {
          hosts = [ ];
          issues = {
            limit = 100;
            state = "opened";
            sort_by = "require('cmp_git.sort').gitlab.pull_requests";
            format = "require('cmp_git.format').gitlab.pull_requests";
          };
          mentions = {
            limit = 100;
            sort_by = "require('cmp_git.sort').gitlab.mentions";
            format = "require('cmp_git.format').gitlab.mentions";
          };
          merge_requests = {
            limit = 100;
            state = "opened";
            sort_by = "require('cmp_git.sort').gitlab.merge_requests";
            format = "require('cmp_git.format').gitlab.merge_requests";
          };
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
        ];
      };
    };
  };

  example = {
    plugins = {
      cmp.enable = true;

      cmp-git.enable = true;
      cmp-git.settings = {
        remotes = [
          "upstream"
          "origin"
          "foo"
        ];
        github = {
          issues = {
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
            filter_fn.__raw = ''
              function(trigger_char, issue)
                return string.format('%s %s %s', trigger_char, issue.number, issue.title)
              end
            '';
          };
          mentions = {
            limit = 250;
            sort_by = null;
            filter_fn.__raw = ''
              function(trigger_char, mention)
                return string.format('%s %s %s', trigger_char, mention.username)
              end
            '';
          };
          pull_requests = {
            limit = 250;
            state = "all";
            format = ''
              function(_, pr)
                local icon = ({
                  open = '',
                  closed = '',
                })[string.lower(pr.state)]
                return string.format('%s #%d: %s', icon, pr.number, pr.title)
              end
            '';
            sort_by = ''
              function(pr)
                local state_rank = pr.state == 'open' and 0 or 1
                local age = os.difftime(os.time(), require('cmp_git.utils').parse_github_date(pr.updatedAt))
                return string.format('%d%010d', state_rank, age)
              end
            '';
            filter_fn.__raw = ''
              function(trigger_char, pr)
                return string.format('%s %s %s', trigger_char, pr.number, pr.title)
              end
            '';
          };
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
          {
            debug_name = "github_pulls";
            trigger_character = "!";
            action = ''
              function(sources, trigger_char, callback, params, git_info)
                return sources.github:get_pull_requests(callback, git_info, trigger_char)
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
        ];
      };
    };
  };
}
