{pkgs, ...}: {
  empty = {
    plugins.clipboard-image = {
      enable = true;
      clipboardPackage = null;
    };
  };

  example = {
    plugins.clipboard-image = {
      enable = true;

      clipboardPackage = pkgs.wl-clipboard;
      default = {
        imgDir = "img";
        imgDirTxt = "img";
        imgName.__raw = "function() return os.date('%Y-%m-%d-%H-%M-%S') end";
        imgHandler = "function(img) end";
        affix = "{img_path}";
      };
      filetypes = {
        markdown = {
          imgDir = [
            "src"
            "assets"
            "img"
          ];
          imgDirTxt = "/assets/img";
          imgHandler = ''
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
