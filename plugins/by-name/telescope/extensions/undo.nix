{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
  inherit (import ./_helpers.nix lib) mkMappingsOption;
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "undo";
  package = "telescope-undo-nvim";

  settingsOptions = {
    use_delta = defaultNullOpts.mkBool true ''
      When set to true, [delta](https://github.com/dandavison/delta) is used for fancy diffs in
      the preview section.
      If set to false, `telescope-undo` will not use `delta` even when available and fall back to a
      plain diff with treesitter highlights.
    '';

    use_custom_command = mkNullOrOption (with types; listOf str) ''
      Should be in this format: `[ "bash" "-c" "echo '$DIFF' | delta" ]`
    '';

    side_by_side = defaultNullOpts.mkBool false ''
      If set to true tells `delta` to render diffs side-by-side. Thus, requires `delta` to be used.
      Be aware that `delta` always uses its own configuration, so it might be that you're getting
      the side-by-side view even if this is set to false.
    '';

    vim_diff_opts = {
      ctxlen = defaultNullOpts.mkStrLuaOr types.ints.unsigned "vim.o.scrolloff" ''
        Defaults to the scrolloff.
      '';
    };

    entry_format = defaultNullOpts.mkStr "state #$ID, $STAT, $TIME" ''
      The format to show on telescope for the different versions of the file.
    '';

    time_format = defaultNullOpts.mkStr "" ''
      Can be set to a [Lua date format string](https://www.lua.org/pil/22.1.html).
    '';

    mappings = mkMappingsOption {
      insertDefaults = ''
        {
          "<cr>" = "require('telescope-undo.actions').yank_additions";
          "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
          "<c-cr>" = "require('telescope-undo.actions').restore";
        }
      '';

      normalDefaults = ''
        {
          "y" = "require('telescope-undo.actions').yank_additions";
          "Y" = "require('telescope-undo.actions').yank_deletions";
          "u" = "require('telescope-undo.actions').restore";
        }
      '';
    };
  };

  settingsExample = {
    use_delta = true;
    use_custom_command = [
      "bash"
      "-c"
      "echo '$DIFF' | delta"
    ];
    side_by_side = true;
    vim_diff_opts.ctxlen = 8;
    entry_format = "state #$ID";
    time_format = "!%Y-%m-%dT%TZ";
    mappings = {
      i = {
        "<cr>" = "require('telescope-undo.actions').yank_additions";
        "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
        "<c-cr>" = "require('telescope-undo.actions').restore";
      };
      n = {
        "y" = "require('telescope-undo.actions').yank_additions";
        "Y" = "require('telescope-undo.actions').yank_deletions";
        "u" = "require('telescope-undo.actions').restore";
      };
    };
  };
}
