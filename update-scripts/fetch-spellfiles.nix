{
  writeShellApplication,
  curl,
  nix,
  ...
}:
writeShellApplication {
  name = "fetch-spellfiles";

  runtimeInputs = [
    curl
    nix
  ];

  text = ''
    echo "{"

    BASE_URL="https://ftp.nluug.nl/pub/vim/runtime/spell/"

    html=$(curl -s "$BASE_URL")

    # Extract only .spl and .sug file links
    readarray -t filenames < <(echo "$html" | grep -oP '(?<=href=")[^"]+\.(spl|sug)' | sort -u)

    for filename in "''${filenames[@]}"; do

      url="$BASE_URL$filename"

      # Special characters (like '%40', standing for `@`) are invalid for nix store paths
      # -> We replace all non-alphanumeric characters with '_' and used this sanitized filename for
      # the derivation name
      sanitized_filename="''${filename//[^a-zA-Z0-9]/_}"
      sha256=$(nix-prefetch-url "$url" --name "$sanitized_filename")

      hash=$(nix hash convert --to sri --hash-algo sha256 "$sha256")

      # Ugly hardcoding of the `%40` -> `@` substitution
      filename="''${filename//%40/@}"
      echo -e "  \"$filename\": { url: \"$url\", hash: \"$hash\" },"
    done

    echo "}"
  '';
}
