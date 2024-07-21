{
  lib,
  config,
  helpers,
  ...
}:
let
  cfg = config.luaLoader;
in
{
  options.luaLoader.enable = helpers.mkNullOrOption lib.types.bool ''
    Whether to enable/disable the experimental lua loader:

    If `true`: Enables the experimental Lua module loader:
      - overrides loadfile
      - adds the lua loader using the byte-compilation cache
      - adds the libs loader
      - removes the default Neovim loader

    If `false`: Disables the experimental Lua module loader:
      - removes the loaders
      - adds the default Neovim loader

    If `null`: Nothing is configured.
  '';

  config = helpers.mkIfNonNull' cfg.enable {
    extraConfigLuaPre = if cfg.enable then "vim.loader.enable()" else "vim.loader.disable()";
  };
}
