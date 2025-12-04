{
  call,
  lib,
}:
{
  mkNeovimPlugin = call ./mk-neovim-plugin.nix { };

  # TODO: DEPRECATED: use the `settings` option instead
  extraOptionsOptions = {
    extraOptions = lib.mkOption {
      default = { };
      type = with lib.types; attrsOf anything;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        Typically, it can override Nixvim's default settings.
      '';
    };
  };
}
