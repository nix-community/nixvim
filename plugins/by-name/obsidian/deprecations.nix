{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.plugins.obsidian;
  opts = options.plugins.obsidian;
in
{
  warnings = lib.nixvim.mkWarnings "plugins.obsidian" [
    # TODO: Added 2026-06-15; remove after 27.11
    {
      when = cfg.settings ? completion.nvim_cmp;
      message = ''
        `${opts.settings}.completion.nvim_cmp` is deprecated, please remove it from your config.
        Completion is now provided via the built-in obsidian-ls LSP server instead.
        Feature will be removed in obsidian.nvim 4.0
      '';
    }
    # TODO: Added 2026-06-15; remove after 27.11
    {
      when = cfg.settings ? completion.blink;
      message = ''
        `${opts.settings}.completion.blink` is deprecated, please remove it from your config.
        Completion is now provided via the built-in obsidian-ls LSP server instead.
        Feature will be removed in obsidian.nvim 4.0
      '';
    }
  ];
}
