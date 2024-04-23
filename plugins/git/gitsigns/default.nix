{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "gitsigns";
    originalName = "gitsigns.nvim";
    defaultPackage = pkgs.vimPlugins.gitsigns-nvim;

    maintainers = [maintainers.GaetanLepage];

    # TODO: introduced 2024-03-12, remove on 2024-05-12
    deprecateExtraOptions = true;
    optionsRenamedToSettings = [
      ["signs" "add" "hl"]
      ["signs" "add" "text"]
      ["signs" "add" "numhl"]
      ["signs" "add" "linehl"]
      ["signs" "add" "showCount"]
      ["signs" "change" "hl"]
      ["signs" "change" "text"]
      ["signs" "change" "numhl"]
      ["signs" "change" "linehl"]
      ["signs" "change" "showCount"]
      ["signs" "topdelete" "hl"]
      ["signs" "topdelete" "text"]
      ["signs" "topdelete" "numhl"]
      ["signs" "topdelete" "linehl"]
      ["signs" "topdelete" "showCount"]
      ["signs" "changedelete" "hl"]
      ["signs" "changedelete" "text"]
      ["signs" "changedelete" "numhl"]
      ["signs" "changedelete" "linehl"]
      ["signs" "changedelete" "showCount"]
      ["signs" "untracked" "hl"]
      ["signs" "untracked" "text"]
      ["signs" "untracked" "numhl"]
      ["signs" "untracked" "linehl"]
      ["signs" "untracked" "showCount"]
      "worktrees"
      "signPriority"
      "signcolumn"
      "numhl"
      "linehl"
      "showDeleted"
      ["diffOpts" "algorithm"]
      ["diffOpts" "internal"]
      ["diffOpts" "indentHeuristic"]
      ["diffOpts" "vertical"]
      ["diffOpts" "linematch"]
      "base"
      "countChars"
      "maxFileLength"
      "previewConfig"
      "attachToUntracked"
      "updateDebounce"
      "currentLineBlame"
      ["currentLineBlameOpts" "virtText"]
      ["currentLineBlameOpts" "virtTextPos"]
      ["currentLineBlameOpts" "delay"]
      ["currentLineBlameOpts" "ignoreWhitespace"]
      ["currentLineBlameOpts" "virtTextPriority"]
      "trouble"
      ["yadm" "enable"]
      "wordDiff"
      "debugMode"
    ];
    imports = let
      basePluginPaths = ["plugins" "gitsigns"];
      settingsPath = basePluginPaths ++ ["settings"];
    in [
      (
        mkRenamedOptionModule
        (basePluginPaths ++ ["onAttach" "function"])
        (settingsPath ++ ["on_attach"])
      )
      (
        mkRenamedOptionModule
        (basePluginPaths ++ ["watchGitDir" "enable"])
        (settingsPath ++ ["watch_gitdir" "enable"])
      )
      (
        mkRemovedOptionModule
        (basePluginPaths ++ ["watchGitDir" "interval"])
        "The option has been removed from upstream."
      )
      (
        mkRenamedOptionModule
        (basePluginPaths ++ ["watchGitDir" "followFiles"])
        (settingsPath ++ ["watch_gitdir" "follow_files"])
      )
      (
        mkRenamedOptionModule
        (basePluginPaths ++ ["statusFormatter" "function"])
        (settingsPath ++ ["status_formatter"])
      )
      (
        mkRenamedOptionModule
        (basePluginPaths ++ ["currentLineBlameFormatter" "normal"])
        (settingsPath ++ ["current_line_blame_formatter"])
      )
      (
        mkRenamedOptionModule
        (basePluginPaths ++ ["currentLineBlameFormatter" "nonCommitted"])
        (settingsPath ++ ["current_line_blame_formatter_nc"])
      )
    ];

    extraOptions = {
      gitPackage = mkOption {
        type = with types; nullOr package;
        default = pkgs.git;
        description = ''
          Which package to use for `git`.
          Set to `null` to prevent the installation.
        '';
      };
    };

    settingsOptions = import ./options.nix {inherit lib helpers;};

    settingsExample = {
      signs = {
        add.text = "│";
        change.text = "│";
        delete.text = "_";
        topdelete.text = "‾";
        changedelete.text = "~";
        untracked.text = "┆";
      };
      signcolumn = true;
      watch_gitdir.follow_files = true;
      current_line_blame = false;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
      };
    };

    extraConfig = cfg: {
      warnings =
        optional
        ((isBool cfg.settings.trouble && cfg.settings.trouble) && !config.plugins.trouble.enable)
        ''
          Nixvim (plugins.gitsigns): You have enabled `plugins.gitsigns.settings.trouble` but
          `plugins.trouble.enable` is `false`.
          You should maybe enable the `trouble` plugin.
        '';
      extraPackages = [cfg.gitPackage];
    };
  }
