{
  lib,
  helpers,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin {
  name = "glow";
  originalName = "glow.nvim";
  package = "glow-nvim";

  maintainers = [ lib.maintainers.getchoo ];

  settingsOptions = {
    glow_path = helpers.defaultNullOpts.mkStr (helpers.mkRaw "vim.fn.exepath('glow')") ''
      Path to `glow` binary.

      If null or `""`, `glow` in your `$PATH` with be used if available.

      Using `glowPackage` is the recommended way to make `glow` available in your `$PATH`.
    '';

    install_path = helpers.defaultNullOpts.mkStr "~/.local/bin" ''
      Path for installing `glow` binary if one is not found at `glow_path` or in your `$PATH`.

      Consider using `glowPackage` instead.
    '';

    border = helpers.defaultNullOpts.mkEnumFirstDefault [
      "shadow"
      "none"
      "double"
      "rounded"
      "solid"
      "single"
    ] "Style of the floating window's border.";

    style = helpers.defaultNullOpts.mkEnum [
      "dark"
      "light"
    ] (helpers.mkRaw "vim.opt.background") "Glow style.";

    pager = helpers.defaultNullOpts.mkBool false ''
      Display output in a pager style.
    '';

    width = helpers.defaultNullOpts.mkInt 100 ''
      Width of the floating window.
    '';

    height = helpers.defaultNullOpts.mkInt 100 ''
      Height of the floating window.
    '';

    width_ratio = helpers.defaultNullOpts.mkNum 0.7 ''
      Maximum width of the floating window relative to the window size.
    '';

    height_ratio = helpers.defaultNullOpts.mkNum 0.7 ''
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
    glowPackage = helpers.mkPackageOption {
      description = ''
        Which package to use for `glow` in your `$PATH`.
        Set to `null` to disable its automatic installation.
      '';
      default = pkgs.glow;
      defaultText = lib.literalExpression "pkgs.glow";
    };
  };

  extraConfig = cfg: { extraPackages = [ cfg.glowPackage ]; };
}
