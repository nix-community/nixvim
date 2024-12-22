{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "twilight";
  packPathName = "twilight.nvim";
  package = "twilight-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    dimming = {
      alpha = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.25 ''
        Amount of dimming.
      '';

      color =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "Normal"
            "#ffffff"
          ]
          ''
            Highlight groups / colors to use.
          '';

      term_bg = helpers.defaultNullOpts.mkStr "#000000" ''
        If `guibg=NONE`, this will be used to calculate text color.
      '';

      inactive = helpers.defaultNullOpts.mkBool false ''
        When true, other windows will be fully dimmed (unless they contain the same buffer).
      '';
    };

    context = helpers.defaultNullOpts.mkUnsignedInt 10 ''
      Amount of lines we will try to show around the current line.
    '';

    treesitter = helpers.defaultNullOpts.mkBool true ''
      Use `treesitter` when available for the filetype.
      `treesitter` is used to automatically expand the visible text, but you can further control
      the types of nodes that should always be fully expanded.
    '';

    expand = helpers.defaultNullOpts.mkListOf types.str [
      "function"
      "method"
      "table"
      "if_statement"
    ] "For treesitter, we will always try to expand to the top-most ancestor with these types.";

    exclude = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Exclude these filetypes.
    '';
  };

  settingsExample = {
    dimming.alpha = 0.4;
    context = 20;
    treesitter = true;
    expand = [
      "function"
      "method"
    ];
  };

  extraConfig = cfg: {
    warnings =
      optional
        ((isBool cfg.settings.treesitter) && cfg.settings.treesitter && (!config.plugins.treesitter.enable))
        ''
          Nixvim (plugins.twilight): You have set `plugins.twilight.treesitter` to `true` but `plugins.treesitter.enable` is false.
        '';
  };
}
