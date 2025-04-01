{
  lib,
  config,
  ...
}:
let
  cfg = config.luaLoader;
  inherit (lib.nixvim) mkNullOrOption mkIfNonNull' toLuaObject;
in
{
  options.luaLoader.enable = mkNullOrOption lib.types.bool ''
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

  config = mkIfNonNull' cfg.enable {
    extraConfigLuaPre = "vim.loader.enable(${toLuaObject cfg.enable})";
  };
}
