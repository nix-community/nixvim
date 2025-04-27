{
  lib,
  pkgs,
  ...
}:
with lib;
let
  inherit (lib.nixvim) defaultNullOpts;
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "media-files";
  extensionName = "media_files";
  package = "telescope-media-files-nvim";

  extraOptions = {
    dependencies =
      let
        mkDepOption =
          {
            name,
            desc,
            package ? name,
            enabledByDefault ? false,
          }:
          {
            enable = mkOption {
              type = types.bool;
              default = enabledByDefault;
              description = ''
                Whether to install the ${name} dependency.
                ${desc}
              '';
            };

            package = mkPackageOption pkgs name { default = package; };
          };
      in
      {
        chafa = mkDepOption {
          name = "chafa";
          enabledByDefault = true;
          desc = "Required for image support.";
        };

        imageMagick = mkDepOption {
          name = "ImageMagick";
          package = "imagemagick";
          desc = "Required for svg previews.";
        };

        ffmpegthumbnailer = mkDepOption {
          name = "ffmpegthumbnailer";
          desc = "Required for video preview support.";
        };

        pdftoppm = mkDepOption {
          name = "pdmtoppm";
          package = "poppler_utils";
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
      mapAttrsToList (name: { enable, package }: optional enable package) cfg.dependencies
    );
  };

  settingsOptions = {
    filetypes = defaultNullOpts.mkListOf types.str [
      "png"
      "jpg"
      "gif"
      "mp4"
      "webm"
      "pdf"
    ] "Filetypes whitelist.";

    find_cmd = defaultNullOpts.mkStr "fd" ''
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
