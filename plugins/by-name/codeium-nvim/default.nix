{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codeium-nvim";
  packPathName = "codeium.nvim";
  moduleName = "codeium";

  maintainers = with lib.maintainers; [
    GaetanLepage
    khaneliman
  ];

  description = ''
    By default, enabling this plugin will also install the `curl`, `gzip`, `coreutils`, `util-linux` and `codeium` packages (via the `dependencies.*.enable` options`).

    You are free to configure `dependencies.*.enable` and `dependencies.*.package` to disable or customize this behavior, respectively.
  '';

  # TODO: added 2024-09-03 remove after 24.11
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;

  # Register nvim-cmp association
  imports = [
    { cmpSourcePlugins.codeium = "codeium-nvim"; }
  ];

  settingsExample = {
    enable_chat = true;
  };

  extraConfig = {
    dependencies =
      lib.genAttrs
        [
          "curl"
          "gzip"
          "coreutils"
          "util-linux"
          "codeium"
        ]
        (_: {
          enable = lib.mkDefault true;
        });
  };
}
