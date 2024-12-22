{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "glow";
  packPathName = "glow.nvim";
  package = "glow-nvim";

  maintainers = [ lib.maintainers.getchoo ];

  settingsOptions = {
    glow_path = defaultNullOpts.mkStr (lib.nixvim.mkRaw "vim.fn.exepath('glow')") ''
      Path to `glow` binary.

      If null or `""`, `glow` in your `$PATH` with be used if available.

      Using `glowPackage` is the recommended way to make `glow` available in your `$PATH`.
    '';

    install_path = defaultNullOpts.mkStr "~/.local/bin" ''
      Path for installing `glow` binary if one is not found at `glow_path` or in your `$PATH`.

      Consider using `glowPackage` instead.
    '';

    border = defaultNullOpts.mkEnumFirstDefault [
      "shadow"
      "none"
      "double"
      "rounded"
      "solid"
      "single"
    ] "Style of the floating window's border.";

    style = defaultNullOpts.mkNullable (
      with lib.types;
      either (maybeRaw str) (enum [
        "dark"
        "light"
      ])
    ) (lib.nixvim.mkRaw "vim.opt.background") "Glow style.";

    pager = defaultNullOpts.mkBool false ''
      Display output in a pager style.
    '';

    width = defaultNullOpts.mkInt 100 ''
      Width of the floating window.
    '';

    height = defaultNullOpts.mkInt 100 ''
      Height of the floating window.
    '';

    width_ratio = defaultNullOpts.mkNum 0.7 ''
      Maximum width of the floating window relative to the window size.
    '';

    height_ratio = defaultNullOpts.mkNum 0.7 ''
      Maximum height of the floating window relative to the window size.
    '';
  };

  settingsExample = {
    border = "shadow";
    style = "dark";
    pager = false;
    width = 80;
    height = 100;
    width_ratio = 0.7;
    height_ratio = 0.7;
  };

  extraOptions = {
    glowPackage = lib.mkPackageOption pkgs "glow" {
      nullable = true;
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.glowPackage ]; };
}
