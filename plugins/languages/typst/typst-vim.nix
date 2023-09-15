{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.typst-vim;
  helpers = import ../../helpers.nix {inherit lib;};
in {
  options.plugins.typst-vim =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "typst.vim";

      package = helpers.mkPackageOption "typst-vim" pkgs.vimPlugins.typst-vim;

      keymaps = {
        silent = mkOption {
          type = types.bool;
          description = "Whether typst-vim keymaps should be silent.";
          default = false;
        };

        watch =
          helpers.mkNullOrOption types.str
          "Keymap to preview the document and recompile on change.";
      };
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    # Add the typst compiler to nixvim packages
    extraPackages = with pkgs; [typst];

    keymaps = with cfg.keymaps;
      helpers.mkKeymaps
      {
        mode = "n";
        options.silent = silent;
      }
      (
        optional
        (watch != null)
        {
          # mode = "n";
          key = watch;
          action = ":TypstWatch<CR>";
        }
      );
  };
}
