{
  callPackage,
  vimPlugins,
  runCommand,
  pandoc,
  jq,
}:
runCommand "lspconfig-servers.json"
  {
    lspconfig = vimPlugins.nvim-lspconfig;
    nativeBuildInputs = [
      jq
      pandoc
    ];
    passthru.unsupported = callPackage ./unsupported.nix { };
  }
  ''
    for file in "$lspconfig"/lsp/*.lua
    do
      name=$(basename --suffix=.lua "$file")

      # A lua @brief doc-comment has the description
      # NOTE: this is only needed for `plugins.lsp`
      description=$(
        awk '
          # Capture the @brief doc-comment
          /^---@brief/ {
            inbrief=1
            next
          }

          # Print each line in the doc-comment
          inbrief && /^--- / {
            sub(/^--- /, "")
            print
            next
          }

          # Until the end of the comment
          inbrief && !/^---/ {
            inbrief=0
          }
        ' "$file" \
        | pandoc -t markdown --lua-filter ${./desc-filter.lua}
      )

      # Map each server config to {name: description}
      jq --null-input \
          --arg name "$name" \
          --arg desc "$description" \
          '{ ($name): $desc }'

    done | jq --slurp add > "$out"
  ''
