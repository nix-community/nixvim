{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.plugins.gitlinker = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "gitlinker.nvim";

    package = lib.mkPackageOption pkgs "gitlinker.nvim" {
      default = [
        "vimPlugins"
        "gitlinker-nvim"
      ];
    };

    remote = helpers.mkNullOrOption types.str "Force the use of a specific remote.";

    addCurrentLineOnNormalMode = helpers.defaultNullOpts.mkBool true ''
      Adds current line nr in the url for normal mode.
    '';

    actionCallback =
      helpers.defaultNullOpts.mkNullable (with types; either str rawLua) "copy_to_clipboard"
        ''
          Callback for what to do with the url.

          Can be
            - the name of a built-in callback. Example: `actionCallback = "copy_to_clipboard";` is
            setting
            ```lua
              require('gitlinker.actions').copy_to_clipboard
            ```
            in lua.
            - Raw lua code `actionCallback.__raw = "function() ... end";`.
        '';

    printUrl = helpers.defaultNullOpts.mkBool true "Print the url after performing the action.";

    mappings = helpers.defaultNullOpts.mkStr "<leader>gy" "Mapping to call url generation.";

    callbacks =
      helpers.defaultNullOpts.mkAttrsOf types.str
        {
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
        }
        ''
          Each key can be
            - the name of a built-in callback. Example: `"get_gitlab_type_url";` is setting
            ```lua
              require('gitlinker.hosts').get_gitlab_type_url
            ```
            in lua.
            - Raw lua code `"github.com".__raw = "function(url_data) ... end";`.

          Learn more by reading `:h gitinker-callbacks`.
        '';
  };

  config =
    let
      cfg = config.plugins.gitlinker;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua =
        let
          setupOptions =
            with cfg;
            {
              opts = {
                inherit remote;
                add_current_line_on_normal_mode = addCurrentLineOnNormalMode;
                action_callback =
                  if isString actionCallback then
                    helpers.mkRaw "require('gitlinker.actions').${actionCallback}"
                  else
                    actionCallback;
                print_url = printUrl;
                inherit mappings;
              };
              callbacks = helpers.ifNonNull' callbacks (
                mapAttrs (
                  source: callback:
                  if isString callback then helpers.mkRaw "require('gitlinker.hosts').${callback}" else callback
                ) callbacks
              );
            }
            // cfg.extraOptions;
        in
        ''
          require('gitlinker').setup(${helpers.toLuaObject setupOptions})
        '';
    };
}
