{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.plugins.tagbar;
  helpers = import ../helpers.nix { inherit lib; };
in
with lib;
{
  options.plugins.tagbar = {

    enable = mkEnableOption "tagbar";

    package = helpers.mkPackageOption "tagbar" pkgs.vimPlugins.tagbar;

    extraConfig = helpers.mkNullOrOption types.attrs ''
      The configuration options for tagbar without the 'tagbar_' prefix.
      Example: To set 'tagbar_show_tag_count' to 1, write
        extraConfig = {
          show_tag_count= true;
        };
    '';
  };

  config = mkIf cfg.enable {

    extraPlugins = [ cfg.package ];

    extraPackages = [ pkgs.ctags ];

    globals = mapAttrs' (name: value: nameValuePair ("tagbar_" + name) value) cfg.extraConfig;
  };
}
