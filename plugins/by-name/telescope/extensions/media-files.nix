{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts mkSettingsRenamedOptionModules;
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "media-files";
  extensionName = "media_files";
  package = "telescope-media-files-nvim";

  imports =
    let
      dependencies = {
        chafa = "chafa";
        imageMagick = "imagemagick";
        ffmpegthumbnailer = "ffmpegthumbnailer";
        pdftoppm = "poppler-utils";
        epub-thumbnailer = "epub-thumbnailer";
        fontpreview = "fontpreview";
      };

      # TODO: Added 2025-04-27. Remove after 25.11
      deprecations = lib.concatLists (
        lib.mapAttrsToList (
          oldName: newName:
          mkSettingsRenamedOptionModules
            [
              "plugins"
              "telescope"
              "extensions"
              "media-files"
              "dependencies"
              oldName
            ]
            [
              "dependencies"
              newName
            ]
            [ "enable" "package" ]
        ) dependencies
      );
    in
    deprecations
    ++ [
      {
        __depPackages = {
          chafa.default = "chafa";
          epub-thumbnailer.default = "epub-thumbnailer";
          ffmpegthumbnailer.default = "ffmpegthumbnailer";
          fontpreview.default = "fontpreview";
          poppler-utils.default = "poppler-utils";
        };
      }
    ];

  dependencies = [ "chafa" ];

  settingsOptions = {
    filetypes = defaultNullOpts.mkListOf lib.types.str [
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
