{
  lib,
  config,
  options,
  ...
}:
let
  # cfg = config.plugins.lspconfig;
  opts = options.plugins.lspconfig;
  oldCfg = config.plugins.lsp;
  oldOpts = options.plugins.lsp;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lspconfig";
  package = "nvim-lspconfig";

  maintainers = with lib.maintainers; [
    GaetanLepage
    HeitorAugustoLN
    MattSturgeon
    khaneliman
    traxys
  ];

  description = ''
    [nvim-lspconfig] provides default configs for many language servers, but it does not enable any of them.
    You should use the [`lsp`] module to configure and enable LSP servers.

    > [!NOTE]
    > This plugin module will soon replace [`plugins.lsp`].
    >
    > Both `${opts.enable}` and `${oldOpts.enable}` will install nvim-lspconfig,
    > however the older [`plugins.lsp`] module includes additional options and
    > setup that relate to neovim's builtin LSP and are now being moved to the
    > new [`lsp`] module.

    [`lsp`]: ../../lsp/servers/index.md
    [`plugins.lsp`]: ../lsp/index.md
    [nvim-lspconfig]: ${opts.package.default.meta.homepage}
  '';

  # nvim-lspconfig provides configs for `vim.lsp.config` and requires no setup
  # all configuration should be done via nvim's builtin `vim.lsp` API
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.lspconfig" [
      {
        when = oldCfg.enable;
        message = ''
          Both `${opts.enable}' and `${oldOpts.enable}' configure the same plugin (nvim-lspconfig).
          ${lib.pipe
            [ opts oldOpts ]
            [
              (builtins.catAttrs "enable")
              (map (o: "`${o}' defined in ${lib.options.showFiles o.files}."))
              lib.strings.concatLines
            ]
          }
        '';
      }
    ];
  };
}
