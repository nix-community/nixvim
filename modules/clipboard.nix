{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.clipboard;
in
{
  options = {
    clipboard = {
      register = mkOption {
        description = ''
          Sets the register to use for the clipboard.
          Learn more at https://neovim.io/doc/user/options.html#'clipboard'.
        '';
        type = with types; nullOr (either str (listOf str));
        default = null;
        example = "unnamedplus";
      };

      providers = mkOption {
        type = types.submodule {
          options =
            mapAttrs
              (name: packageName: {
                enable = mkEnableOption name;
                package = mkPackageOption pkgs packageName { };
              })
              {
                wl-copy = "wl-clipboard";
                xclip = "xclip";
                xsel = "xsel";
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
    opts.clipboard = mkIf (cfg.register != null) cfg.register;

    extraPackages = mapAttrsToList (n: v: v.package) (filterAttrs (n: v: v.enable) cfg.providers);
  };
}
