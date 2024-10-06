{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;

  cfg = config.plugins.nvim-ufo;
in
{
  options.plugins.nvim-ufo = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = lib.mkEnableOption "nvim-ufo";

    package = lib.mkPackageOption pkgs "nvim-ufo" {
      default = [
        "vimPlugins"
        "nvim-ufo"
      ];
    };

    openFoldHlTimeout = defaultNullOpts.mkInt 400 ''
      Time in millisecond between the range to be highlgihted and to be cleared
      while opening the folded line, `0` value will disable the highlight
    '';

    providerSelector = defaultNullOpts.mkLuaFn null ''
      A lua function as a selector for fold providers.
    '';

    closeFoldKinds = lib.nixvim.mkNullOrOption lib.types.attrs ''
      After the buffer is displayed (opened for the first time), close the
      folds whose range with `kind` field is included in this option. For now,
      'lsp' provider's standardized kinds are 'comment', 'imports' and 'region',
      run `UfoInspect` for details if your provider has extended the kinds.
    '';

    foldVirtTextHandler = defaultNullOpts.mkLuaFn null "A lua function to customize fold virtual text";

    enableGetFoldVirtText = defaultNullOpts.mkBool false ''
      Enable a function with `lnum` as a parameter to capture the virtual text
      for the folded lines and export the function to `get_fold_virt_text` field of
      ctx table as 6th parameter in `fold_virt_text_handler`
    '';

    preview = {
      winConfig = {
        border = defaultNullOpts.mkBorder "rounded" "preview window" "";

        winblend = defaultNullOpts.mkInt 12 "The winblend for preview window, `:h winblend`";

        winhighlight = defaultNullOpts.mkStr "Normal:Normal" "The winhighlight for preview window, `:h winhighlight`";

        maxheight = defaultNullOpts.mkInt 20 "The max height of preview window";
      };

      mappings = lib.nixvim.mkNullOrOption lib.types.attrs "Mappings for preview window";
    };
  };

  config =
    let
      options =
        with cfg;
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
    lib.mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("ufo").setup(${lib.nixvim.toLuaObject options})
      '';
    };
}
