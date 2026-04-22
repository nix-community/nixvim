{
  vimPlugins,
  runCommand,
  jq,
}:
runCommand "lint-linters.json"
  {
    src = vimPlugins.nvim-lint;
    nativeBuildInputs = [ jq ];
  }
  ''
    for file in "$src"/lua/lint/linters/*.lua
    do
      name=''${file##*/}
      printf '%s\n' "''${name%.lua}"
    done \
      | LC_ALL=C sort \
      | jq -R . \
      | jq -s . > "$out"
  ''
