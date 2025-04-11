{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    getExe
    getExe'
    mkIf
    mkDefault
    ;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codeium-nvim";
  packPathName = "codeium.nvim";
  moduleName = "codeium";

  maintainers = with lib.maintainers; [
    GaetanLepage
    khaneliman
  ];

  description = ''
    By default, Nixvim will install the `curl`, `gzip`, `coreutils`, `util-linux` and `codeium` packages and populate settings.tools.*` accordingly.

    You are free to override `dependencies.*.enable` and `dependencies.*.package` to respectively disable and customize this behavior.
  '';

  # Register nvim-cmp association
  imports = [
    { cmpSourcePlugins.codeium = "codeium-nvim"; }
  ];

  settingsExample = {
    enable_chat = true;
  };

  extraConfig = {
    dependencies = lib.genAttrs [ "curl" "gzip" "coreutils" "util-linux" "codeium" ] (_: {
      enable = lib.mkDefault true;
    });

    plugins.codeium-nvim.settings.tools =
      let
        depsCfg = config.dependencies;
      in
      {
        curl = mkIf depsCfg.curl.enable (mkDefault (getExe depsCfg.curl.package));
        gzip = mkIf depsCfg.gzip.enable (mkDefault (getExe depsCfg.gzip.package));
        coreutils = mkIf depsCfg.coreutils.enable (mkDefault (getExe' depsCfg.coreutils.package "uname"));
        util-linux = mkIf depsCfg.util-linux.enable (
          mkDefault (getExe' depsCfg.util-linux.package "uuidgen")
        );
        language_server = mkIf depsCfg.codeium.enable (getExe depsCfg.codeium.package);
      };
  };
}
