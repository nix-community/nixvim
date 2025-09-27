{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "coq-nvim";
  package = "coq_nvim";
  description = "A fast nvim completion engine.";

  maintainers = with lib.maintainers; [
    traxys
    Kareem-Medhat
  ];

  extraOptions = {
    # TODO: should this enable option be replaced with `nullable = true` in the package option?
    installArtifacts = lib.mkEnableOption "and install coq-artifacts";
    artifactsPackage = lib.mkPackageOption pkgs "coq-artifacts" {
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
    {
      old = "recommendedKeymaps";
      new = [
        "keymap"
        "recommended"
      ];
    }
    {
      old = "alwaysComplete";
      new = [
        "completion"
        "always"
      ];
    }
  ];

  callSetup = false;
  settingsOptions = {
    auto_start = lib.nixvim.mkNullOrOption (
      with types; maybeRaw (either bool (enum [ "shut-up" ]))
    ) "Auto-start or shut up";

    xdg = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Use XDG paths. May be required when installing coq with Nix.";
    };

    keymap.recommended = defaultNullOpts.mkBool true "Use the recommended keymaps";

    completion.always = defaultNullOpts.mkBool true "Always trigger completion on keystroke";
  };

  extraConfig = cfg: {
    extraPlugins = lib.mkIf cfg.installArtifacts [ cfg.artifactsPackage ];

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
