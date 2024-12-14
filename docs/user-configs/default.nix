{
  callPackages,
  stdenvNoCC,
  yq,
  name ? "user-configs",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  enableParallelBuilding = true;
  phases = [ "buildPhase" ];

  inherit name;
  src = ./list.toml;

  nativeBuildInputs = [
    yq # provides tomlq
  ];

  # Function definitions for use in the jq query
  jqFunctions = ''
    def normalizeSpaces: . | gsub("\\s+"; " ") | ltrimstr(" ") | rtrimstr(" ");
  '';

  # The jq query passed to tomlq
  query = ''
    .config
    | sort_by(
        (.owner | ascii_downcase),
        (.title // .repo | ascii_downcase)
      )
    | .[]
    | .title = (.title // .repo | normalizeSpaces)
    | .owner_url = "https://github.com/\(.owner)"
    | .url = (.url // "\(.owner_url)/\(.repo)")
    | .description = (.description // "" | normalizeSpaces)
  '';

  # The markdown table heading
  heading = ''
    | Owner | Config | Comment |
    |-------|--------|---------|
  '';

  # A jq query "template" for the markdown table row
  template = ''
    "| [\(.owner)](\(.owner_url)) | [\(.title)](\(.url)) | \(.description) |"
  '';

  buildPhase = ''
    echo -n "$heading" > "$out"
    tomlq "$jqFunctions $query | $template" --raw-output "$src" >> "$out"
  '';

  passthru = {
    tests = callPackages ./tests.nix { drv = finalAttrs.finalPackage; };
  };
})
