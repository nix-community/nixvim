{
  runCommand,
  jq,
  vimPlugins,
}:
/**
  Produces a JSON array of all nvim-lspconfig server configs that don't yet
  support the new system.

  I.e., files in the old `lua/lspconfig/configs/` directory, that aren't
  present in the new `lsp/` directory.
*/
runCommand "unsupported-lspconfig-servers.json"
  {
    nativeBuildInputs = [ jq ];
    lspconfig = vimPlugins.nvim-lspconfig;
  }
  ''
    for file in "$lspconfig"/lua/lspconfig/configs/*.lua
    do
      name=$(basename --suffix=.lua "$file")
      [ -f "$lspconfig"/lsp/"$name".lua ] || echo "$name"
    done | jq --raw-input . | jq --slurp [.] > "$out"
  ''
