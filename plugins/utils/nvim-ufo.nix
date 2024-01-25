{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.nvim-ufo;
in {
  options.plugins.nvim-ufo =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-ufo";

      package = helpers.mkPackageOption "nvim-ufo" pkgs.vimPlugins.nvim-ufo;

      openFoldHlTimeout = helpers.defaultNullOpts.mkInt 400 ''
        Time in millisecond between the range to be highlgihted and to be cleared
        while opening the folded line, `0` value will disable the highlight
      '';

      providerSelector = helpers.defaultNullOpts.mkLuaFn "null" ''
        A lua function as a selector for fold providers.
      '';

      closeFoldKinds = helpers.mkNullOrOption types.attrs ''
        After the buffer is displayed (opened for the first time), close the
        folds whose range with `kind` field is included in this option. For now,
        'lsp' provider's standardized kinds are 'comment', 'imports' and 'region',
        run `UfoInspect` for details if your provider has extended the kinds.
      '';

      foldVirtTextHandler = helpers.defaultNullOpts.mkLuaFn "null" "A lua function to customize fold virtual text";

      enableGetFoldVirtText = helpers.defaultNullOpts.mkBool false ''
        Enable a function with `lnum` as a parameter to capture the virtual text
        for the folded lines and export the function to `get_fold_virt_text` field of
        ctx table as 6th parameter in `fold_virt_text_handler`
      '';

      preview = {
        winConfig = {
          border = helpers.defaultNullOpts.mkBorder "rounded" "preview window" "";

          winblend = helpers.defaultNullOpts.mkInt 12 "The winblend for preview window, `:h winblend`";

          winhighlight = helpers.defaultNullOpts.mkStr "Normal:Normal" "The winhighlight for preview window, `:h winhighlight`";

          maxheight = helpers.defaultNullOpts.mkInt 20 "The max height of preview window";
        };

        mappings = helpers.mkNullOrOption types.attrs "Mappings for preview window";
      };
    };

  config = let
    options = with cfg;
      {
        open_fold_hl_timeout = openFoldHlTimeout;
        provider_selector = providerSelector;
        close_fold_kinds = closeFoldKinds;
        fold_virt_text_handler = foldVirtTextHandler;
        enable_get_fold_virt_text = enableGetFoldVirtText;

        preview = with preview; {
          inherit mappings;
          win_config = winConfig;
        };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("ufo").setup(${helpers.toLuaObject options})
      '';
    };
}
