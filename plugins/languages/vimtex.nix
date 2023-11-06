{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.vimtex;
in
  with lib; {
    options.plugins.vimtex = {
      enable = mkEnableOption "vimtex";

      package = helpers.mkPackageOption "vimtex" pkgs.vimPlugins.vimtex;

      extraConfig = mkOption {
        type = types.attrs;
        description = ''
          The configuration options for vimtex without the 'vimtex_' prefix.
          Example: To set 'vimtex_compiler_enabled' to 1, write
            extraConfig = {
              compiler_enabled = true;
            };
        '';
        default = {};
      };

      viewMethod = mkOption {
        type = types.str;
        description = ''
          The view method that vimtex will use to display PDF's.
          Check https://github.com/lervag/vimtex/blob/03c83443108a6984bf90100f6d00ec270b84a339/doc/vimtex.txt#L3322
          for more information.
        '';
        default = "general";
      };
      installTexLive = mkOption {
        type = types.bool;
        description = ''
                 Whether or not to install TexLive.
          See https://nixos.wiki/wiki/TexLive.
        '';
        default = false;
      };
      texLivePackage = helpers.mkPackageOption "texLivePackage" pkgs.texlive.combined.scheme-medium;
    };

    config = let
      globals =
        {
          enabled = cfg.enable;
          callback_progpath = "nvim";
          view_method = cfg.viewMethod;
        }
        // cfg.extraConfig;
      basePackages =
        [pkgs.pstree]
        ++ (
          lib.optional cfg.installTexLive cfg.texLivePackage
        );
      viewMethodAndPDFViewerPairs = {
        general = [pkgs.xdotool];
        zathura = [pkgs.xdotool pkgs.zathura];
        zathura_simple = [pkgs.zathura];
        mupdf = [pkgs.xdotool pkgs.mupdf];
      };
    in
      mkIf cfg.enable {
        extraPlugins = [cfg.package];

        extraPackages =
          basePackages ++ (lib.optionals (hasAttr "${cfg.viewMethod}" viewMethodAndPDFViewerPairs) viewMethodAndPDFViewerPairs."${cfg.viewMethod}");

        globals = mapAttrs' (name: nameValuePair ("vimtex_" + name)) globals;
      };
  }
