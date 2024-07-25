{ lib, pkgs }:
rec {
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

  /*
    Write a byte compiled lua file to the nix store.

    # Type

    ```
    writeByteCompiledLua :: String -> String -> Derivation
    ```

    # Arguments

    - [name] The name of the derivation
    - [text] The content of the lua file
  */
  writeByteCompiledLua =
    name: text:
    pkgs.runCommandLocal name { inherit text; } ''
      echo -n "$text" > "$out"

      ${lib.getExe' pkgs.luajit "luajit"} -bd -- "$out" "$out"
    '';

  /*
    Get a source lua file and write a byte compiled copy of it
    to the nix store.

    # Type

    ```
    byteCompileLuaFile :: String -> String -> Derivation
    ```

    # Arguments

    - [name] The name of the derivation
    - [src] The path to the source lua file
  */
  byteCompileLuaFile =
    name: src:
    pkgs.runCommandLocal name { inherit src; } ''
      ${lib.getExe' pkgs.luajit "luajit"} -bd -- "$src" "$out"
    '';

  # Setup hook to byte compile all lua files in the output directory.
  # Invalid lua files are ignored.
  byteCompileLuaHook = pkgs.makeSetupHook { name = "byte-compile-lua-hook"; } (
    let
      luajit = lib.getExe' pkgs.luajit "luajit";
    in
    pkgs.writeText "byte-compile-lua-hook.sh" # bash
      ''
        byteCompileLuaPostFixup() {
            # Target is a single file
            if [[ -f $out ]]; then
                if [[ $out = *.lua ]]; then
                    tmp=$(mktemp)
                    ${luajit} -bd -- "$out" "$tmp"
                    mv "$tmp" "$out"
                fi
                return
            fi

            # Target is a directory
            while IFS= read -r -d "" file; do
                tmp=$(mktemp -u "$file.XXXX")
                # Ignore invalid lua files
                if ${luajit} -bd -- "$file" "$tmp"; then
                    mv "$tmp" "$file"
                else
                    echo "WARNING: Ignoring byte compiling error for '$file' lua file" >&2
                fi
            done < <(find "$out" -type f,l -name "*.lua" -print0)
        }

        postFixupHooks+=(byteCompileLuaPostFixup)
      ''
  );

  /*
    Returns an overridden derivation with all lua files byte compiled.

    # Type

    ```
    byteCompileLuaDrv :: Derivation -> Derivation
    ```

    # Arguments

    - [drv] Input derivation
  */
  byteCompileLuaDrv =
    drv:
    drv.overrideAttrs (
      prev:
      {
        nativeBuildInputs = prev.nativeBuildInputs or [ ] ++ [ byteCompileLuaHook ];
      }
      // lib.optionalAttrs (prev ? buildCommand) {
        buildCommand = ''
          ${prev.buildCommand}
          runHook postFixup
        '';
      }
    );
}
