{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "obsidian";
  package = "obsidian-nvim";
  description = "Neovim plugin for writing and navigating Obsidian vaults.";

  maintainers = [ maintainers.GaetanLepage ];

  ## DEPRECATIONS
  # Introduced 2024-03-12
  inherit (import ./deprecations.nix { inherit lib; })
    imports
    deprecateExtraOptions
    optionsRenamedToSettings
    ;

  settingsOptions =
    let
      opts = import ./settings-options.nix { inherit lib; };
    in
    {
      dir = helpers.mkNullOrOption types.str ''
        Alternatively to `workspaces` - and for backwards compatibility - you can set `dir` to a
        single path instead of `workspaces`.

        For example:
        ```nix
          dir = "~/vaults/work";
        ```
      '';

      workspaces =
        helpers.defaultNullOpts.mkNullable
          (
            with types;
            listOf (
              types.submodule {
                options = {
                  name = mkOption {
                    type = with lib.types; maybeRaw str;
                    description = "The name for this workspace";
                  };

                  path = mkOption {
                    type = with lib.types; maybeRaw str;
                    description = "The path of the workspace.";
                  };

                  overrides = opts;
                };
              }
            )
          )
          [ ]
          ''
            A list of vault names and paths.
            Each path should be the path to the vault root.
            If you use the Obsidian app, the vault root is the parent directory of the `.obsidian`
            folder.
            You can also provide configuration overrides for each workspace through the `overrides`
            field.
          '';
    }
    // opts;

  settingsExample = {
    workspaces = [
      {
        name = "work";
        path = "~/obsidian/work";
      }
      {
        name = "startup";
        path = "~/obsidian/startup";
      }
    ];
    new_notes_location = "current_dir";
    completion = {
      nvim_cmp = true;
      min_chars = 2;
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.obsidian" [
      {
        when = (cfg.settings.completion.nvim_cmp == true) && (!config.plugins.cmp.enable);
        message = ''
          You have enabled `completion.nvim_cmp` but `plugins.cmp.enable` is `false`.
          You should probably enable `nvim-cmp`.
        '';
      }
      {
        when = (cfg.settings.completion.blink == true) && (!config.plugins.blink-cmp.enable);
        message = ''
          You have enabled `completion.blink` but `plugins.blink-cmp.enable` is `false`.
          You should probably enable `blink-cmp`.
        '';
      }
    ];
  };
}
