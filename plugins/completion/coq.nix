{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.coq-nvim;
  helpers = import ../helpers.nix {inherit lib;};
  plugins = import ../plugin-defs.nix {inherit pkgs;};
in {
  options = {
    plugins.coq-nvim = {
      enable = mkEnableOption "coq-nvim";

      package = helpers.mkPackageOption "coq-nvim" pkgs.vimPlugins.coq_nvim;

      installArtifacts = mkEnableOption "Install coq-artifacts";

      autoStart = mkOption {
        type = with types; nullOr (oneOf [bool (enum ["shut-up"])]);
        default = null;
        description = "Auto-start or shut up";
      };

      recommendedKeymaps = mkOption {
        type = with types; nullOr bool;
        default = null;
        description = "Use the recommended keymaps";
      };
    };
  };
  config = let
    settings = {
      auto_start = cfg.autoStart;
      "keymap.recommended" = cfg.recommendedKeymaps;
    };
  in
    mkIf cfg.enable {
      extraPlugins =
        [
          cfg.package
        ]
        ++ optional cfg.installArtifacts plugins.coq-artifacts;
      plugins.lsp = {
        preConfig = ''
          vim.g.coq_settings = ${helpers.toLuaObject settings}
          local coq = require 'coq'
        '';
        setupWrappers = [(s: ''coq.lsp_ensure_capabilities(${s})'')];
      };
    };
}
