{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
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

  settingsOptions = {
    config_path = defaultNullOpts.mkStr {
      __raw = "vim.fn.stdpath('cache') .. '/codeium/config.json'";
    } "The path to the config file, used to store the API key.";

    bin_path = defaultNullOpts.mkStr {
      __raw = "vim.fn.stdpath('cache') .. '/codeium/bin'";
    } "The path to the directory where the Codeium server will be downloaded to.";

    api = {
      host = defaultNullOpts.mkStr "server.codeium.com" ''
        The hostname of the API server to use.
      '';

      port = defaultNullOpts.mkNullableWithRaw' {
        # TODO: Added 2024-09-05; remove after 24.11
        type = with lib.types; lib.nixvim.transitionType ints.positive toString (strMatching "[0-9]+");
        pluginDefault = "443";
        description = ''
          The port of the API server to use.
        '';
      };
    };

    tools = {
      uname = defaultNullOpts.mkStr null "The path to the `uname` binary.";

      uuidgen = defaultNullOpts.mkStr null "The path to the `uuidgen` binary.";

      curl = defaultNullOpts.mkStr null "The path to the `curl` binary.";

      gzip = defaultNullOpts.mkStr null "The path to the `gzip` binary.";

      language_server = defaultNullOpts.mkStr null ''
        The path to the language server downloaded from the official source.
      '';
    };

    wrapper = defaultNullOpts.mkStr null ''
      The path to a wrapper script/binary that is used to execute any binaries not listed under
      tools.
      This is primarily useful for NixOS, where a FHS wrapper can be used for the downloaded
      codeium server.
    '';

    detect_proxy = defaultNullOpts.mkBool false "Whether to enable the proxy detection.";

    enable_chat = defaultNullOpts.mkBool false "Whether to enable the chat functionality.";

    enterprise_mode = defaultNullOpts.mkBool false "Whether to enable the enterprise mode.";
  };

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
