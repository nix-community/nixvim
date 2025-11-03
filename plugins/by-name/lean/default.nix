{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lean";
  package = "lean-nvim";
  description = "Neovim support for the Lean theorem prover.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [ "lean" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "lean";
      packageName = "lean";
    })
  ];

  settingsOptions = {
    stderr = {
      on_lines = defaultNullOpts.mkLuaFn "nil" ''
        A callback which will be called with (multi-line) stderr output.
      '';
    };
  };

  settingsExample = {
    settings = {
      lsp = {
        enable = true;
      };
      ft = {
        default = "lean";
        nomodifiable = [ "_target" ];
      };
      abbreviations = {
        enable = true;
        extra = {
          wknight = "♘";
        };
      };
      mappings = false;
      infoview = {
        horizontal_position = "top";
        separate_tab = true;
        indicators = "always";
      };
      progress_bars = {
        enable = false;
      };
      stderr = {
        on_lines.__raw = "function(lines) vim.notify(lines) end";
      };
    };
  };

  # TODO: Deprecated in 2025-01-31
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;
}
