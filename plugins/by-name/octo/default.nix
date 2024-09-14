{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "octo";
  originalName = "octo.nvim";
  package = "octo-nvim";

  maintainers = [ helpers.maintainers.svl ];

  settingsOptions = {
    use_local_fs = helpers.defaultNullOpts.mkBool false ''
      Use local files on right side of reviews.
    '';

    enable_builtin = helpers.defaultNullOpts.mkBool false ''
      Shows a list of builtin actions when no action is provided.
    '';

    default_remote =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "upstream"
          "origin"
        ]
        ''
          Order to try remotes
        '';

    ssh_aliases = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
      SSH aliases.
    '';

    picker_config = {
      use_emojis = helpers.defaultNullOpts.mkBool false ''
        Use emojis in picker. Only used by "fzf-lua" picker for now.
      '';

      mappings =
        let
          mkMappingOption = lhs: desc: {
            lhs = helpers.defaultNullOpts.mkStr lhs ''
              Key to map.
            '';

            desc = helpers.defaultNullOpts.mkStr desc ''
              Description of the mapping.
            '';
          };
        in
        {
          open_in_browser = mkMappingOption "<C-b>" ''
            Open issue in browser.
          '';

          copy_url = mkMappingOption "<C-y>" ''
            Copy url to system clipboard.
          '';

          checkout_pr = mkMappingOption "<C-o>" ''
            Checkout pull request.
          '';

          merge_pr = mkMappingOption "<C-r>" ''
            Merge pull request.
          '';
        };
    };

    reaction_viewer_hint_icon = helpers.defaultNullOpts.mkStr "" ''
      Marker for user reactions.
    '';

    user_icon = helpers.defaultNullOpts.mkStr " " ''
      User Icon.
    '';

    timeline_marker = helpers.defaultNullOpts.mkStr "" ''
      Timeline marker.
    '';

    timeline_indent = helpers.defaultNullOpts.mkStr "2" ''
      Timeline indentation.
    '';

    right_bubble_delimiter = helpers.defaultNullOpts.mkStr "" ''
      Bubble delimiter.
    '';

    left_bubble_delimiter = helpers.defaultNullOpts.mkStr "" ''
      Bubble delimiter.
    '';

    github_hostname = helpers.defaultNullOpts.mkStr "" ''
      Github Enterprise host.
    '';

    snippet_context_lines = helpers.defaultNullOpts.mkInt 4 ''
      Number of lines around commented lines.
    '';

    gh_env = helpers.defaultNullOpts.mkAttributeSet { } ''
      Extra environment variables to pass on to GitHub CLI, can be a table or function returning a table.
    '';

    timeout = helpers.defaultNullOpts.mkInt 5000 ''
      Timeout for requests between the remote server.
    '';

    ui = {
      use_sign_column = helpers.defaultNullOpts.mkBool true ''
        Show "modified" marks on the sign column.
      '';
    };

    picker =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "telescope"
          "fzf-lua"
        ]
        ''
          Picker to use.
        '';

    issues = {
      order_by = {
        field =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "CREATED_AT"
              "COMMENTS"
              "UPDATED_AT"
            ]
            ''
              See GitHub's [`IssueOrderField`](https://docs.github.com/en/graphql/reference/enums#issueorderfield) documentation.
            '';
        direction =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "DESC"
              "ASC"
            ]
            ''
              See GitHub's [`OrderDirection`](https://docs.github.com/en/graphql/reference/enums#orderdirection) documentation.
            '';
      };
    };
  };

  settingsExample = {
    ssh_aliases = {
      "github.com-work" = "github.com";
    };

    # options not defined
    mappings_disable_default = true;
    mappings = {
      issue.react_heart = "<leader>rh";
      file_panel.select_prev_entry = "[q";
    };
  };

  extraOptions = {
    ghPackage = lib.mkPackageOption pkgs "GitHub CLI" {
      default = "gh";
      nullable = true;
    };
  };

  extraConfig =
    cfg:
    mkMerge [
      { extraPackages = [ cfg.ghPackage ]; }
      (mkIf (cfg.settings.picker == null || cfg.settings.picker == "telescope") {
        plugins.telescope.enable = mkDefault true;
      })
      (mkIf (cfg.settings.picker == "fzf-lua") { plugins.fzf-lua.enable = mkDefault true; })
    ];
}
