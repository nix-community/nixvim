{ lib, pkgs }:
{
  /*
    Write a lua file to the nix store, formatted using stylua.

    # Type

    ```
    writeLua :: String -> String -> Derivation
    ```

    # Arguments

    - [name] The name of the derivation
    - [text] The content of the lua file
  */
  writeLua =
    name: text:
    pkgs.runCommand name { inherit text; } ''
      echo -n "$text" > "$out"

      ${lib.getExe pkgs.stylua} \
        --no-editorconfig \
        --line-endings Unix \
        --indent-type Spaces \
        --indent-width 4 \
        "$out"
    '';
}
