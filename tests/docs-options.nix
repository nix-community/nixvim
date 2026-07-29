{
  jq,
  pkgs,
  runCommandLocal,
  selfPackages,
}:
let
  expected = pkgs.writeText "expected-lsp-server-docs.json" (
    builtins.toJSON {
      clangd = {
        configExample = "{\n  cmd = [\n    \"clangd\"\n    \"--background-index\"\n  ];\n  filetypes = [\n    \"c\"\n    \"cpp\"\n  ];\n  root_markers = [\n    \"compile_commands.json\"\n    \"compile_flags.txt\"\n  ];\n}";
        description = "The clangd language server.\n";
      };
      tinymist = {
        configDescription = ''
          Configurations for tinymist. Configuration options are described in the [Tinymist documentation](https://myriad-dreamin.github.io/tinymist/).

        '';
        configExample = "{\n  settings = {\n    formatterMode = \"typstyle\";\n  };\n}";
        description = "Tinymist is a language server for the typesetting system Typst.";
      };
    }
    + "\n"
  );

  actual = runCommandLocal "actual-lsp-server-docs.json" { nativeBuildInputs = [ jq ]; } ''
    jq --compact-output --sort-keys '
      {
        clangd: {
          description: .["lsp.servers.clangd"].description,
          configExample: .["lsp.servers.clangd.config"].example.text
        },
        tinymist: {
          description: .["lsp.servers.tinymist"].description,
          configDescription: .["lsp.servers.tinymist.config"].description,
          configExample: .["lsp.servers.tinymist.config"].example.text
        }
      }
    ' ${selfPackages.options-json}/share/doc/nixos/options.json > "$out"
  '';
in
pkgs.testers.testEqualContents {
  assertion = "generated LSP server documentation";
  inherit actual expected;
}
