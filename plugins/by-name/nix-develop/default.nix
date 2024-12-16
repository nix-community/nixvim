{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts toLuaObject;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "nix-develop";
  packPathName = "nix-develop.nvim";
  package = "nix-develop-nvim";
  callSetup = false;
  hasSettings = false;

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  extraOptions = {
    ignoredVariables =
      defaultNullOpts.mkAttrsOf types.bool
        {
          BASHOPTS = true;
          HOME = true;
          NIX_BUILD_TOP = true;
          NIX_ENFORCE_PURITY = true;
          NIX_LOG_FD = true;
          NIX_REMOTE = true;
          PPID = true;
          SHELL = true;
          SHELLOPTS = true;
          SSL_CERT_FILE = true;
          TEMP = true;
          TEMPDIR = true;
          TERM = true;
          TMP = true;
          TMPDIR = true;
          TZ = true;
          UID = true;
        }
        ''
          Variables that should be ignored when generating the environment.
        '';

    separatedVariables =
      defaultNullOpts.mkAttrsOf types.str
        {
          PATH = ":";
          XDG_DATA_DIRS = ":";
        }
        ''
          Specified separators to use for particular environment variables.
        '';
  };

  extraConfig = cfg: {
    plugins.nix-develop.luaConfig.content =
      lib.optionalString (cfg.ignoredVariables != null) ''
        local ignored_variables = ${toLuaObject cfg.ignoredVariables}
        for ignored_variable, should_ignore in pairs(ignored_variables) do
          require("nix-develop").ignored_variables[ignored_variable] = should_ignore
        end
      ''
      + lib.optionalString (cfg.separatedVariables != null) ''
        local separated_variables = ${toLuaObject cfg.separatedVariables}
        for separated_variable, separator in pairs(separated_variables) do
          require("nix-develop").separated_variables[separated_variable] = separator
        end
      '';
  };
}
