{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts toLuaObject;

  name = "base16";
  luaName = "base16-colorscheme";
  originalName = "base16.nvim";
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  inherit name luaName originalName;
  setup = ".with_config";
  package = "base16-nvim";
  isColorscheme = true;

  maintainers = with lib.maintainers; [
    GaetanLepage
    MattSturgeon
  ];

  # TODO introduced 2024-03-12: remove after 24.11
  imports =
    let
      basePluginPath = [
        "colorschemes"
        name
      ];
    in
    [
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "customColorScheme" ]) (
        basePluginPath ++ [ "colorscheme" ]
      ))
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "useTruecolor" ]) [
        "options"
        "termguicolors"
      ])
    ];

  settingsExample = {
    telescope_borders = true;
    indentblankline = false;
    dapui = false;
  };

  settingsOptions = {
    telescope = defaultNullOpts.mkBool true ''
      Whether to enable telescope integration.
    '';

    telescope_borders = defaultNullOpts.mkBool false ''
      Whether to display borders around telescope's panel.
    '';

    indentblankline = defaultNullOpts.mkBool true ''
      Whether to enable indentblankline integration.
    '';

    notify = defaultNullOpts.mkBool true ''
      Whether to enable notify integration.
    '';

    ts_rainbow = defaultNullOpts.mkBool true ''
      Whether to enable ts_rainbow integration.
    '';

    cmp = defaultNullOpts.mkBool true ''
      Whether to enable cmp integration.
    '';

    illuminate = defaultNullOpts.mkBool true ''
      Whether to enable illuminate integration.
    '';

    lsp_semantic = defaultNullOpts.mkBool true ''
      Whether to enable lsp_semantic integration.
    '';

    mini_completion = defaultNullOpts.mkBool true ''
      Whether to enable mini_completion integration.
    '';

    dapui = defaultNullOpts.mkBool true ''
      Whether to enable dapui integration.
    '';
  };

  extraOptions = {
    colorscheme =
      let
        customColorschemeType = lib.types.submodule {
          options = lib.mapAttrs (
            name: example:
            lib.mkOption {
              type = with lib.types; maybeRaw str;
              description = "The value for color `${name}`.";
              inherit example;
            }
          ) customColorschemeExample;
        };

        customColorschemeExample = {
          base00 = "#16161D";
          base01 = "#2c313c";
          base02 = "#3e4451";
          base03 = "#6c7891";
          base04 = "#565c64";
          base05 = "#abb2bf";
          base06 = "#9a9bb3";
          base07 = "#c5c8e6";
          base08 = "#e06c75";
          base09 = "#d19a66";
          base0A = "#e5c07b";
          base0B = "#98c379";
          base0C = "#56b6c2";
          base0D = "#0184bc";
          base0E = "#c678dd";
          base0F = "#a06949";
        };

        builtinColorschemeExamples = import ./theme-list.nix;
      in
      defaultNullOpts.mkNullable' {
        type =
          with lib.types;
          oneOf [
            str
            customColorschemeType
            rawLua
          ];
        pluginDefault = lib.literalMD ''`vim.env.BASE16_THEME` or `"schemer-dark"`'';
        description = ''
          The base16 colorscheme to use.

          You may use the name of a builtin colorscheme or an attrs that specifies the colors explicitly.

          Examples of builtin themes include:
          ${lib.concatStrings (
            map (e: ''
              - "${e}"
            '') builtinColorschemeExamples
          )}

          `:h nvim-base16-builtin-colorschemes` includes a full list of builtin themes,
          however the [plugin's source code] may be more up to date.

          You can access `require('${luaName}')` as `base16` in any raw lua,
          for example, you could reuse some colors from the builtin colorschemes:

          ```nix
            base03.__raw = "base16.colorschemes['catppuccin'].base06";
          ```

          [plugin's source code]: https://github.com/RRethy/base16-nvim/blob/master/lua/colors/init.lua
        '';
        example = customColorschemeExample;
      };

    setUpBar = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Whether to set your status bar theme to 'base16'.";
    };
  };

  # We will manually set the colorscheme, using `setup`
  colorscheme = null;
  callSetup = false;

  extraConfig = cfg: {
    plugins.airline.settings.theme = lib.mkIf cfg.setUpBar (lib.mkDefault name);
    plugins.lualine.settings.options.theme = lib.mkIf cfg.setUpBar (lib.mkDefault name);
    plugins.lightline.settings.colorscheme = lib.mkDefault null;

    opts.termguicolors = lib.mkDefault true;

    # `settings` can either be passed to `with_config` before calling `setup`,
    # or it can be passed as `setup`'s 2nd argument.
    # See https://github.com/RRethy/base16-nvim/blob/6ac181b5733518040a33017dde654059cd771b7c/lua/base16-colorscheme.lua#L107-L125
    colorschemes.base16.luaConfig.content = ''
      do
        local base16 = require('${luaName}')
        base16.with_config(${toLuaObject cfg.settings})
        base16.setup(${toLuaObject cfg.colorscheme})
      end
    '';
  };
}
