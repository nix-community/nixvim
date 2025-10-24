{
  empty = {
    # TODO: shows a warning
    # > ERROR: ATTN: overseer.nvim will experience breaking changes soon. Pin to version v1.6.0 or earlier to avoid disruption.
    # > See: https://github.com/stevearc/overseer.nvim/pull/448
    test.runNvim = false;

    plugins.compiler.enable = true;
  };
}
