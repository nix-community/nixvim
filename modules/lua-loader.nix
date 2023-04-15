{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.luaLoader;
in {
  options.luaLoader = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable/disable the experimental lua loader:

        If `true`: Enables the experimental Lua module loader:
          - overrides loadfile
          - adds the lua loader using the byte-compilation cache
          - adds the libs loader
          - removes the default Neovim loade

        If `false`: Disables the experimental Lua module loader:
          - removes the loaders
          - adds the default Neovim loader
      '';
    };
  };

  config = {
    extraConfigLuaPre =
      if cfg.enable
      then "vim.loader.enable()"
      else "vim.loader.disable()";
  };
}
