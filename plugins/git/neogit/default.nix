{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "neogit";
  defaultPackage = pkgs.vimPlugins.neogit;

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-02-29: remove 2024-04-29
  deprecateExtraOptions = true;
  imports =
    map
      (
        optionPath:
        mkRemovedOptionModule
          (
            [
              "plugins"
              "neogit"
            ]
            ++ optionPath
          )
          "This option has been removed upstream. Please refer to the plugin documentation to update your configuration."
      )
      [
        [ "disableCommitConfirmation" ]
        [ "disableBuiltinNotifications" ]
        [ "useMagitKeybindings " ]
        [ "commitPopup" ]
        [
          "sections"
          "unmerged"
        ]
        [
          "sections"
          "unpulled"
        ]
      ];
  optionsRenamedToSettings = [
    "disableSigns"
    "disableHint"
    "disableContextHighlighting"
    "autoRefresh"
    "graphStyle"
    "kind"
    "signs"
    "integrations"
    [
      "sections"
      "untracked"
    ]
    [
      "sections"
      "unstaged"
    ]
    [
      "sections"
      "staged"
    ]
    [
      "sections"
      "stashes"
    ]
    [
      "sections"
      "recent"
    ]
    "mappings"
  ];

  settingsOptions = import ./options.nix { inherit lib helpers; };

  settingsExample = {
    kind = "floating";
    commit_popup.kind = "floating";
    preview_buffer.kind = "floating";
    popup.kind = "floating";
    integrations.diffview = false;
    disable_commit_confirmation = true;
    disable_builtin_notifications = true;
    sections = {
      untracked.folded = false;
      unstaged.folded = false;
      staged.folded = false;
      stashes.folded = false;
      unpulled.folded = false;
      unmerged.folded = true;
      recent.folded = true;
    };
    mappings = {
      status = {
        l = "Toggle";
        a = "Stage";
      };
    };
  };

  extraOptions = {
    gitPackage = helpers.mkPackageOption {
      name = "git";
      default = pkgs.git;
    };
  };

  extraConfig = cfg: {
    assertions =
      map
        (name: {
          assertion =
            let
              enabled = cfg.settings.integrations.${name};
              isEnabled = (isBool enabled) && enabled;
            in
            isEnabled -> config.plugins.${name}.enable;
          message = ''
            Nixvim (plugins.neogit): You have enabled the `${name}` integration, but `plugins.${name}.enable` is `false`.
          '';
        })
        [
          "telescope"
          "diffview"
          "fzf-lua"
        ];

    extraPackages = [
      cfg.gitPackage
    ] ++ optional (hasInfix "which" (cfg.settings.commit_view.verify_commit.__raw or "")) pkgs.which;

  };
}
