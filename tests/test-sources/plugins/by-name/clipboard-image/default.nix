{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) hostPlatform;
in
{
  empty = {
    plugins.clipboard-image = {
      enable = true;
      clipboardPackage = null;
    };
  };

  example = {
    plugins.clipboard-image = {
      enable = true;

      clipboardPackage = lib.mkMerge [
        (lib.mkIf hostPlatform.isLinux pkgs.wl-clipboard)
        (lib.mkIf hostPlatform.isDarwin pkgs.pngpaste)
      ];
      settings = {
        default = {
          img_dir = "img";
          img_dir_txt = "img";
          img_name.__raw = "function() return os.date('%Y-%m-%d-%H-%M-%S') end";
          img_handler.__raw = "function(img) end";
          affix = "![]({img_path})";
        };
        markdown = {
          img_dir = [
            "src"
            "assets"
            "img"
          ];
          img_dir_txt = "/assets/img";
          img_handler.__raw = ''
            function(img) -- New feature from PR #22
              local script = string.format('./image_compressor.sh "%s"', img.path)
              os.execute(script)
            end
          '';
        };
      };
    };
  };
}
