{
  mdbook,
  mdbook-alerts,
  runCommand,
  writeTOML,
  menu,
  settings,
  src,
}:
runCommand "html-docs"
  {
    inherit src;

    nativeBuildInputs = [
      mdbook
      mdbook-alerts
    ];

    settings = writeTOML "book.toml" settings;
    menu = builtins.toFile "menu.md" (builtins.unsafeDiscardStringContext menu);
  }
  ''
    mkdir src
    for input in $src/*; do
      name=$(basename "$input")
      ln -s "$input" "src/$name"
    done
    ln -s $settings book.toml
    ln -s $menu src/SUMMARY.md

    # Build the website
    mdbook build --dest-dir $out
  ''
