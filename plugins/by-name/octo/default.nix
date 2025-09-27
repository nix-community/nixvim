{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "octo";
  package = "octo-nvim";
  description = "Edit and review GitHub issues and pull requests from the comfort of your favorite editor.";

  maintainers = [ lib.maintainers.svl ];

  dependencies = [ "gh" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "octo";
      packageName = "gh";
    })
  ];

  settingsOptions = {
    use_local_fs = defaultNullOpts.mkBool false ''
      Use local files on right side of reviews.
    '';

    enable_builtin = defaultNullOpts.mkBool false ''
      Shows a list of builtin actions when no action is provided.
    '';

    default_remote =
      defaultNullOpts.mkListOf types.str
        [
          "upstream"
          "origin"
        ]
        ''
          Order to try remotes
        '';

    ssh_aliases = defaultNullOpts.mkAttrsOf types.str { } ''
      SSH aliases.
    '';

    picker_config = {
      use_emojis = defaultNullOpts.mkBool false ''
        Use emojis in picker. Only used by "fzf-lua" picker for now.
      '';

      mappings =
        let
          mkMappingOption = lhs: desc: {
            lhs = defaultNullOpts.mkStr lhs ''
              Key to map.
            '';

            desc = defaultNullOpts.mkStr desc ''
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

    reaction_viewer_hint_icon = defaultNullOpts.mkStr "" ''
      Marker for user reactions.
    '';

    user_icon = defaultNullOpts.mkStr " " ''
      User Icon.
    '';

    timeline_marker = defaultNullOpts.mkStr "" ''
      Timeline marker.
    '';

    timeline_indent = defaultNullOpts.mkStr "2" ''
      Timeline indentation.
    '';

    right_bubble_delimiter = defaultNullOpts.mkStr "" ''
      Bubble delimiter.
    '';

    left_bubble_delimiter = defaultNullOpts.mkStr "" ''
      Bubble delimiter.
    '';

    github_hostname = defaultNullOpts.mkStr "" ''
      Github Enterprise host.
    '';

    snippet_context_lines = defaultNullOpts.mkInt 4 ''
      Number of lines around commented lines.
    '';

    gh_env = defaultNullOpts.mkAttributeSet { } ''
      Extra environment variables to pass on to GitHub CLI, can be a table or function returning a table.
    '';

    timeout = defaultNullOpts.mkInt 5000 ''
      Timeout for requests between the remote server.
    '';

    ui = {
      use_sign_column = defaultNullOpts.mkBool true ''
        Show "modified" marks on the sign column.
      '';
    };

    picker =
      defaultNullOpts.mkEnumFirstDefault
        [
          "telescope"
          "fzf-lua"
          "snacks"
        ]
        ''
          Picker to use.
        '';

    issues = {
      order_by = {
        field =
          defaultNullOpts.mkEnumFirstDefault
            [
              "CREATED_AT"
              "COMMENTS"
              "UPDATED_AT"
            ]
            ''
              See GitHub's [`IssueOrderField`](https://docs.github.com/en/graphql/reference/enums#issueorderfield) documentation.
            '';
        direction =
          defaultNullOpts.mkEnumFirstDefault
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

  extraConfig =
    cfg:
    lib.mkMerge [
      (lib.mkIf (cfg.settings.picker == null || cfg.settings.picker == "telescope") {
        plugins.telescope.enable = lib.mkDefault true;
      })
      (lib.mkIf (cfg.settings.picker == "fzf-lua") { plugins.fzf-lua.enable = lib.mkDefault true; })
      (lib.mkIf (cfg.settings.picker == "snacks") {
        plugins.snacks = {
          enable = lib.mkDefault true;
          settings.picker.enabled = lib.mkDefault true;
        };
      })
    ];
}
