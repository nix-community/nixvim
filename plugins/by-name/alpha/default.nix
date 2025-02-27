{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "alpha";
  package = "alpha-nvim";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  # TODO Added 2025-10-26: remove after 26.05
  optionsRenamedToSettings = [
    "opts"
    "layout"
  ];

  settingsExample = {
    layout = [
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        opts = {
          position = "center";
          hl = "Type";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  New file";
            on_press = lib.nixvim.nestedLiteralLua "function() vim.cmd[[ene]] end";
            opts.shortcut = "n";
          }
          {
            type = "button";
            val = " Quit Neovim";
            on_press = lib.nixvim.nestedLiteralLua "function() vim.cmd[[qa]] end";
            opts.shortcut = "q";
          }
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = "Inspiring quote here.";
        opts = {
          position = "center";
          hl = "Keyword";
        };
      }
    ];
  };

  extraOptions = {
    theme = lib.mkOption {
      type =
        with lib.types;
        let
          # TODO: deprecated 2025-10-30, remove after 26.05
          old = nullOr (maybeRaw str);
          new = nullOr str;
        in
        old // { inherit (new) description; };
      default = null;
      example = "dashboard";
      description = "You can directly use a pre-defined theme.";
    };
  };

  callSetup = false;
  extraConfig = cfg: opts: {
    assertions = lib.nixvim.mkAssertions "plugins.alpha" {
      assertion = cfg.theme != null -> builtins.isString cfg.theme;
      message = ''
        Defining `${opts.theme}` as raw lua is deprecated. You can define `${opts.settings}` as raw lua instead:
        ${opts.settings} = lib.nixvim.mkRaw ${lib.generators.toPretty { } cfg.theme.__raw};
      '';
    };
    plugins.alpha = {
      settings = lib.mkIf (cfg.theme != null) (
        lib.mkDerivedConfig opts.theme (
          value:
          if builtins.isString value then
            lib.nixvim.mkRaw "require('alpha.themes.${value}').config"
          else
            value
        )
      );

      luaConfig.content = ''
        require('alpha').setup(${lib.nixvim.toLuaObject cfg.settings})
        require('alpha.term')
      '';
    };
  };
}
