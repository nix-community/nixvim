{
  lib,
  runCommand,
  pandoc,
  githubUrl ? "https://github.com/nix-community/nixvim/blob/main/",
  docsUrl ? "https://nix-community.github.io/nixvim/",
}:
src:
runCommand (src.name or (builtins.baseNameOf src))
  {
    inherit src;
    bindings =
      lib.generators.toLua
        {
          asBindings = true;
        }
        {
          inherit githubUrl docsUrl;
        };
    filter = ./filter.lua;
    nativeBuildInputs = [ pandoc ];
  }
  ''
    echo "$bindings" > filter.lua
    cat $filter >> filter.lua

    pandoc \
        --output $out \
        --from gfm \
        --to gfm \
        --lua-filter filter.lua \
        $src
  ''
