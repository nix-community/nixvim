{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts literalLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "projections";
  package = "projections-nvim";
  description = "A tiny project + sessions manager for neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions =
    let
      hookGroupType =
        action:
        types.maybeRaw (
          types.submodule {
            options = {
              pre = defaultNullOpts.mkRaw null ''
                Callback to execute before `${action}`.
              '';

              post = defaultNullOpts.mkRaw null ''
                Callback to execute after `${action}`.
              '';
            };
          }
        );

      defaultHookGroup = {
        pre = null;
        post = null;
      };
    in
    {
      store_hooks = defaultNullOpts.mkNullable' {
        type = hookGroupType "store_session";
        pluginDefault = defaultHookGroup;
        description = ''
          Pre and post hooks for `store_session`.
        '';
        example = {
          pre.__raw = ''
            function()
              -- nvim-tree
              local nvim_tree_present, api = pcall(require, "nvim-tree.api")
              if nvim_tree_present then api.tree.close() end
                -- neo-tree
              if pcall(require, "neo-tree") then vim.cmd [[Neotree action=close]] end
            end
          '';
        };
      };

      restore_hooks = defaultNullOpts.mkNullable (hookGroupType "restore_session") defaultHookGroup ''
        Pre and post hooks for `restore_session`.
      '';

      workspaces = defaultNullOpts.mkListOf' {
        type = with types; either str (listOf (either str (listOf str)));
        pluginDefault = [ ];
        example = [
          [
            "~/Documents/dev"
            [ ".git" ]
          ]
          [
            "~/repos"
            [ ]
          ]
          "~/dev"
        ];
        description = ''
          Default workspaces to search for.
        '';
      };

      patterns = defaultNullOpts.mkListOf types.str [ ".git" ".svn" ".hg" ] ''
        Default patterns to use if none were specified. These are NOT regexps.
      '';

      workspaces_file = defaultNullOpts.mkStr' {
        pluginDefault = literalLua "vim.fn.stdpath('data') .. 'projections_workspaces.json'";
        example = "path/to/file";
        description = ''
          Path to workspaces json file.
        '';
      };

      sessions_directory = defaultNullOpts.mkStr' {
        pluginDefault = literalLua "vim.fn.stdpath('cache') .. 'projections_sessions'";
        example = "path/to/dir";
        description = ''
          Directory where sessions are stored.
        '';
      };
    };

  settingsExample = {
    workspaces = [
      [
        "~/Documents/dev"
        [ ".git" ]
      ]
      [
        "~/repos"
        [ ]
      ]
      "~/dev"
    ];
    patterns = [
      ".git"
      ".svn"
      ".hg"
    ];
    workspaces_file = "path/to/file";
    sessions_directory = "path/to/dir";
  };
}
