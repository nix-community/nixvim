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

  # TODO: added 2024-09-03 remove after 24.11
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;

  # Register nvim-cmp association
  imports = [
    { cmpSourcePlugins.codeium = "codeium-nvim"; }
  ];

  settingsExample = lib.literalExpression ''
    {
      enable_chat = true;
      tools = {
        curl = lib.getExe pkgs.curl;
        gzip = lib.getExe pkgs.gzip;
        uname = lib.getExe' pkgs.coreutils "uname";
        uuidgen = lib.getExe' pkgs.util-linux "uuidgen";
      };
    }
  '';
}
