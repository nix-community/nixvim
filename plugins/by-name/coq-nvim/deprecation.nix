{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.plugins.coq-nvim;
  opts = options.plugins.coq-nvim;
in
{
  assertions = lib.nixvim.mkAssertions "plugins.coq-nvim" [
    # TODO: Added 2026-06-15; remove after 27.11
    {
      assertion = !(cfg.settings ? xdg);
      message = "xdg has been removed in v2. The field is ignored — delete it from `${opts.settings}`.";
    }
    # TODO: Added 2026-06-15; remove after 27.11
    {
      assertion = !(cfg.settings ? auto_start);
      message = "auto_start has been removed in v2. The field is ignored — delete it from `${opts.settings}`.";
    }
  ];
}
