{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "clipboard-image";
  package = "clipboard-image-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    Plugin to paste images from clipboard into Neovim.
  '';

  extraOptions = {
    clipboardPackage = lib.mkPackageOption pkgs "clipboard provider" {
      nullable = true;
      default = null;
      example = [ "wl-clipboard" ];
      extraDescription = ''
        ${"\n\n"}
        Recommended:
          - X11: `pkgs.xclip`
          - Wayland: `pkgs.wl-clipboard`
          - MacOS: `pkgs.pngpaste`
      '';
    };
  };

  settingsOptions = {
    default = {
      img_dir =
        defaultNullOpts.mkNullable
          (types.oneOf [
            types.str
            (types.listOf types.str)
            types.rawLua
          ])
          "img"
          ''
            Directory name where the image will be pasted to.

            > [!Note]
            > If you want to create nested dir, it is better to use table since windows and unix have different path separator.
          '';

      img_dir_txt = defaultNullOpts.mkNullable (types.oneOf [
        types.str
        (types.listOf types.str)
        types.rawLua
      ]) "img" "Directory that will be inserted into text/buffer.";

      img_name = defaultNullOpts.mkStr {
        __raw = "function() return os.date('%Y-%m-%d-%H-%M-%S') end";
      } "Image's name.";

      img_handler = defaultNullOpts.mkLuaFn "function(img) end" ''
        Function that will handle image after pasted.

        > [!Note]
        > `img` is a table that contain pasted image's `{name}` and `{path}`.
      '';

      affix = defaultNullOpts.mkStr' {
        pluginDefault = lib.literalMD ''
          `default`: `"{img_path}"`
          `markdown`: `"![]({img_path})"`
        '';
        description = "String that sandwiches the image's path.";
        example = lib.literalExpression ''
          > [!Note]

          >  ```nix
          >  # You can use line break escape sequence
          >  affix = "<\n  %s\n>";
          >  ```

          >  ```nix
          >  # Or lua's double square brackets
          >  affix.__raw = \'\'
          >    [[<
          >      %s
          >    >]]
          >  \'\'
          >  ```
        '';
      };
    };
  };

  settingsExample = {
    settings = {
      img_dir = "img";
      img_dir_txt = "img";
      img_name.__raw = "function() return os.date('%Y-%m-%d-%H-%M-%S') end";
      img_handler.__raw = "function(img) end";
      affix = "![]({img_path})";
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.clipboardPackage ];
  };

  # TODO: Deprecated in 2025-02-01
  inherit (import ./deprecations.nix { inherit lib; })
    imports
    deprecateExtraOptions
    optionsRenamedToSettings
    ;
}
