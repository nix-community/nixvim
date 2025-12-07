{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neogit";
  description = "An interactive and powerful Git interface for Neovim, inspired by Magit.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [
    "git"
    {
      name = "which";
      enable = lib.hasInfix "which" (
        config.plugins.neogit.settings.commit_view.verify_commit.__raw or ""
      );
    }
  ];

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

  settingsOptions = {
    telescope_sorter = lib.nixvim.mkNullOrLuaFn ''
      Allows a different telescope sorter.
      Defaults to 'fuzzy_with_index_bias'.
      The example below will use the native fzf sorter instead.
      By default, this function returns `nil`.

      Example:
      ```lua
        require("telescope").extensions.fzf.native_fzf_sorter
      ```
    '';

    commit_view.verify_commit = lib.nixvim.mkNullOrStrLuaOr lib.types.bool ''
      Show commit signature information in the buffer.
      Can be set to true or false, otherwise we try to find the binary.

      Default: "os.execute('which gpg') == 0"
    '';
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.neogit" (
      map
        (name: {
          assertion =
            let
              extensionEnabled = (cfg.settings.integrations.${name} or false) == true;
              pluginEnabled = config.plugins.${name}.enable;
            in
            extensionEnabled -> pluginEnabled;

          message = ''
            You have enabled the `${name}` integration, but `plugins.${name}.enable` is `false`.
          '';
        })
        [
          "telescope"
          "diffview"
          "fzf-lua"
        ]
    );
  };
}
