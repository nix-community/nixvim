{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.navic;
  helpers = import ../helpers.nix {inherit lib;};
  mkListStr = helpers.defaultNullOpts.mkNullable (types.listOf types.str);
in {
  options.plugins.navic =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-navic";

      package = helpers.mkPackageOption "nvim-navic" pkgs.vimPlugins.nvim-navic;

      icons =
        mapAttrs
        (name: default:
          helpers.defaultNullOpts.mkStr default "icon for ${name}."
        )
        {
          File = "󰈙 ";
          ...
        };

      lsp = with helpers.defaultNullOpts; {
        autoAttach =
          helpers.defaultNullOpts.mkBool false
          ''
            Enable to have nvim-navic automatically attach to every LSP for current buffer. Its disabled by default.
          '';

        preference = mkListStr "[]" ''
          Table ranking lsp_servers. Lower the index, higher the priority of the server. If there are more than one server attached to a buffer. In the example below will prefer clangd over pyright

          Example: `[ "clangd" "pyright" ]`.
        '';
      };

      highlight =
        helpers.defaultNullOpts.mkBool false
        ''
          If set to true, will add colors to icons and text as defined by highlight groups NavicIcons* (NavicIconsFile, NavicIconsModule.. etc.), NavicText and NavicSeparator.
        '';

      separator =
        helpers.defaultNullOpts.mkStr " > "
        ''
          Icon to separate items. to use between items.
        '';

      depthLimit =
        helpers.defaultNullOpts.mkInt 0
        ''
          Maximum depth of context to be shown. If the context hits this depth limit, it is truncated.
        '';

      depthLimitIndicator =
        helpers.defaultNullOpts.mkStr ".."
        ''
          Icon to indicate that depth_limit was hit and the shown context is truncated.
        '';

      safeOutput =
        helpers.defaultNullOpts.mkBool true
        ''
          Sanitize the output for use in statusline and winbar.
        '';

      lazyUpdateContext =
        helpers.defaultNullOpts.mkBool false
        ''
          If true, turns off context updates for the "CursorMoved" event.
        '';

      click =
        helpers.defaultNullOpts.mkBool false
        ''
          Single click to goto element, double click to open nvim-navbuddy on the clicked element.
        '';
    };

  config = let
    setupOptions =
      {
        inherit (cfg) icons highlight separator click;
        lsp = with lsp; {
          auto_attach = autoAttach;
          inherit (lsp) preference;
        };
        depth_limit = depthLimit;
        safe_output = safeOutput;
        lazy_update_context = lazyUpdateContext;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        nvim-lspconfig
      ];

      extraConfigLua = ''
        require('nvim-navic').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
