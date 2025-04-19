{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "windsurf-nvim";
  packPathName = "windsurf.nvim";
  moduleName = "codeium";

  maintainers = with lib.maintainers; [
    GaetanLepage
    khaneliman
  ];

  description = ''
    By default, enabling this plugin will also install the `curl`, `gzip`, `coreutils`, `util-linux` and `codeium` packages (via the `dependencies.*.enable` options`).

    You are free to configure `dependencies.*.enable` and `dependencies.*.package` to disable or customize this behavior, respectively.
  '';

  imports = [
    # Register nvim-cmp association
    { cmpSourcePlugins.codeium = "windsurf-nvim"; }
  ] ++ (import ./deprecations.nix { inherit lib; }).imports;

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
