{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  (import ./_helpers.nix {
    inherit
      lib
      helpers
      config
      pkgs
      ;
  })
  .mkExtension
  {
    name = "media-files";
    extensionName = "media_files";
    defaultPackage = pkgs.vimPlugins.telescope-media-files-nvim;

    # TODO: introduced 2024-03-24, remove on 2024-05-24
    imports = let
      telescopeExtensionsPath = [
        "plugins"
        "telescope"
        "extensions"
      ];
    in
      mapAttrsToList
      (
        oldOptionName: newOptionPath:
          mkRenamedOptionModule (
            telescopeExtensionsPath
            ++ [
              "media_files"
              oldOptionName
            ]
          ) (telescopeExtensionsPath ++ ["media-files"] ++ newOptionPath)
      )
      {
        enable = ["enable"];
        package = ["package"];
        filetypes = [
          "settings"
          "filetypes"
        ];
        find_cmd = [
          "settings"
          "find_cmd"
        ];
      };

    extraOptions = {
      dependencies = let
        mkDepOption = {
          name,
          desc,
          package ? pkgs.${name},
          enabledByDefault ? false,
        }: {
          enable = mkOption {
            type = types.bool;
            default = enabledByDefault;
            description = ''
              Whether to install the ${name} dependency.
              ${desc}
            '';
          };

          package = mkOption {
            type = types.package;
            default = package;
            description = "The package to use for the ${name} dependency.";
          };
        };
      in {
        chafa = mkDepOption {
          name = "chafa";
          enabledByDefault = true;
          desc = "Required for image support.";
        };

        imageMagick = mkDepOption {
          name = "ImageMagick";
          package = pkgs.imagemagick;
          desc = "Required for svg previews.";
        };

        ffmpegthumbnailer = mkDepOption {
          name = "ffmpegthumbnailer";
          desc = "Required for video preview support.";
        };

        pdftoppm = mkDepOption {
          name = "pdmtoppm";
          package = pkgs.poppler_utils;
          desc = "Required for pdf preview support.";
        };

        epub-thumbnailer = mkDepOption {
          name = "epub-thumbnailer";
          desc = "Required for epub preview support";
        };

        fontpreview = mkDepOption {
          name = "fontpreview";
          desc = "Required for font preview support.";
        };
      };
    };

    extraConfig = cfg: {
      extraPackages = flatten (
        mapAttrsToList (name: {
          enable,
          package,
        }:
          optional enable package)
        cfg.dependencies
      );
    };

    settingsOptions = {
      filetypes = helpers.defaultNullOpts.mkListOf types.str ''
        [
          "png"
          "jpg"
          "gif"
          "mp4"
          "webm"
          "pdf"
        ]
      '' "Filetypes whitelist.";

      find_cmd = helpers.defaultNullOpts.mkStr "fd" ''
        Which find command to use.
      '';
    };

    settingsExample = {
      filetypes = [
        "png"
        "webp"
        "jpg"
        "jpeg"
      ];
      find_cmd = "rg";
    };
  }
