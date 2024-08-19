{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "coq-nvim";
  originalName = "coq_nvim";
  package = "coq_nvim";

  maintainers = [
    maintainers.traxys
    helpers.maintainers.Kareem-Medhat
  ];

  extraOptions = {
    # TODO: should this enable option be replaced with `nullable = true` in the package option?
    installArtifacts = mkEnableOption "and install coq-artifacts";
    artifactsPackage = mkPackageOption pkgs "coq-artifacts" {
      extraDescription = "Installed when `installArtifacts` is enabled.";
      default = [
        "vimPlugins"
        "coq-artifacts"
      ];
    };
  };

  # TODO: Introduced 12-03-2022, remove 12-05-2022
  optionsRenamedToSettings = [
    "xdg"
    "autoStart"
  ];
  imports =
    let
      basePath = [
        "plugins"
        "coq-nvim"
      ];
      settingsPath = basePath ++ [ "settings" ];
    in
    [
      (mkRenamedOptionModule (basePath ++ [ "recommendedKeymaps" ]) (
        settingsPath
        ++ [
          "keymap"
          "recommended"
        ]
      ))

      (mkRenamedOptionModule (basePath ++ [ "alwaysComplete" ]) (
        settingsPath
        ++ [
          "completion"
          "always"
        ]
      ))
    ];

  callSetup = false;
  settingsOptions = {
    auto_start = helpers.mkNullOrOption (
      with helpers.nixvimTypes; maybeRaw (either bool (enum [ "shut-up" ]))
    ) "Auto-start or shut up";

    xdg = mkOption {
      type = types.bool;
      default = true;
      description = "Use XDG paths. May be required when installing coq with Nix.";
    };

    keymap.recommended = helpers.defaultNullOpts.mkBool true "Use the recommended keymaps";

    completion.always = helpers.defaultNullOpts.mkBool true "Always trigger completion on keystroke";
  };

  extraConfig = cfg: {
    extraPlugins = mkIf cfg.installArtifacts [ cfg.artifactsPackage ];

    globals = {
      coq_settings = cfg.settings;
    };

    plugins.coq-nvim.luaConfig.content = "require('coq')";

    plugins.lsp = {
      preConfig = ''
        local coq = require 'coq'
      '';
      setupWrappers = [ (s: ''coq.lsp_ensure_capabilities(${s})'') ];
    };
  };
}
