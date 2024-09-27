{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.clipboard-image;

  pluginOptions = {
    imgDir =
      helpers.defaultNullOpts.mkNullable
        (
          with lib.types;
          oneOf [
            str
            (listOf str)
            rawLua
          ]
        )
        "img"
        ''
          Dir name where the image will be pasted to.

          Note: If you want to create nested dir, it is better to use table since windows and unix
          have different path separator.
        '';

    imgDirTxt = helpers.defaultNullOpts.mkNullable (
      with lib.types;
      oneOf [
        str
        (listOf str)
        rawLua
      ]
    ) "img" "Dir that will be inserted into text/buffer.";

    imgName = helpers.defaultNullOpts.mkStr {
      __raw = "function() return os.date('%Y-%m-%d-%H-%M-%S') end";
    } "Image's name.";

    imgHandler = helpers.defaultNullOpts.mkLuaFn "function(img) end" ''
      Function that will handle image after pasted.

      Note: `img` is a table that contain pasted image's `{name}` and `{path}`.
    '';

    affix = helpers.mkNullOrStr ''
      String that sandwiched the image's path.

      Default:
        - `default`: `"{img_path}"`
        - `markdown`: `"![]({img_path})"`

      Note:
        Affix can be multi lines, like this:

        ```nix
        # You can use line break escape sequence
        affix = "<\n  %s\n>";
        ```

        ```nix
        # Or lua's double square brackets
        affix.__raw = \'\'
          [[<
            %s
          >]]
        \'\'
        ```
    '';
  };

  processPluginOptions =
    opts: with opts; {
      img_dir = imgDir;
      img_dir_txt = imgDirTxt;
      img_name = imgName;
      img_handler = imgHandler;
      inherit affix;
    };
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.clipboard-image = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "clipboard-image.nvim";

    package = lib.mkPackageOption pkgs "clipboard-image.nvim" {
      default = [
        "vimPlugins"
        "clipboard-image-nvim"
      ];
    };

    clipboardPackage = mkOption {
      type = with types; nullOr package;
      description = ''
        Which clipboard provider to use.

        Recommended:
          - X11: `pkgs.xclip`
          - Wayland: `pkgs.wl-clipboard`
          - MacOS: `pkgs.pngpaste`
      '';
      example = pkgs.wl-clipboard;
    };

    default = pluginOptions;

    filetypes = mkOption {
      type =
        with types;
        attrsOf (submodule {
          options = pluginOptions;
        });
      apply = mapAttrs (_: processPluginOptions);
      default = { };
      description = "Override certain options for specific filetypes.";
      example = {
        markdown = {
          imgDir = [
            "src"
            "assets"
            "img"
          ];
          imgDirTxt = "/assets/img";
          imgHandler = ''
            function(img)
              local script = string.format('./image_compressor.sh "%s"', img.path)
              os.execute(script)
            end
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraPackages = [ cfg.clipboardPackage ];

    extraConfigLua =
      let
        setupOptions = {
          default = processPluginOptions cfg.default;
        } // cfg.filetypes // cfg.extraOptions;
      in
      ''
        require('clipboard-image').setup(${helpers.toLuaObject setupOptions})
      '';
  };
}
