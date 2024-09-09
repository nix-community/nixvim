{ pkgs, ... }:
{
  empty = {
    # texpresso is broken on darwin
    plugins.texpresso.enable = !pkgs.stdenv.isDarwin;
  };
}
