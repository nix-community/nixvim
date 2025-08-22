{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.clipboard;
in
{
  options = {
    clipboard = {
      register = lib.mkOption {
        description = ''
          Sets the register to use for the clipboard.
          Learn more in [`:h 'clipboard'`](https://neovim.io/doc/user/options.html#'clipboard').
        '';
        type = with lib.types; nullOr (maybeRaw (either str (listOf (maybeRaw str))));
        default = null;
        example = "unnamedplus";
      };

      providers = lib.mkOption {
        type = lib.types.submodule {
          options =
            lib.mapAttrs
              (
                name: packageName:
                {
                  enable = lib.mkEnableOption name;
                }
                // lib.optionalAttrs (packageName != null) {
                  package = lib.mkPackageOption pkgs packageName { };
                }
              )
              {
                wl-copy = "wl-clipboard";
                xclip = "xclip";
                xsel = "xsel";
                pbcopy = null;
              };
        };
        default = { };
        description = ''
          Package(s) to use as the clipboard provider.
          Learn more at `:h clipboard`.
        '';
      };
    };
  };

  config = {
    opts.clipboard = lib.mkIf (cfg.register != null) cfg.register;

    extraPackages = lib.mapAttrsToList (n: v: v.package) (
      lib.filterAttrs (n: v: v.enable && v ? package) cfg.providers
    );
  };
}
