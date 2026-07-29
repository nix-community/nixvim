{
  jq,
  pkgs,
  runCommandLocal,
  selfPackages,
}:
let
  renderExample = builtins.concatStringsSep "\n";

  expected = pkgs.writeText "expected-lsp-server-docs.json" (
    builtins.toJSON {
      clangd = {
        configExample = renderExample [
          "{"
          "  cmd = ["
          "    \"clangd\""
          "    \"--background-index\""
          "  ];"
          "  filetypes = ["
          "    \"c\""
          "    \"cpp\""
          "  ];"
          "  root_markers = ["
          "    \"compile_commands.json\""
          "    \"compile_flags.txt\""
          "  ];"
          "}"
        ];
        description = "The clangd language server.\n";
      };
      gopls = {
        configDescription = ''
          Configurations for gopls. Server settings belong under `settings.gopls` and are described in the [gopls settings documentation](https://go.dev/gopls/settings).

        '';
        configExample = renderExample [
          "{"
          "  settings = {"
          "    gopls = {"
          "      gofumpt = true;"
          "    };"
          "  };"
          "}"
        ];
        description = "gopls is the official language server for Go.";
      };
      nixd = {
        configDescription = ''
          Configurations for nixd. Configuration options are described in the [nixd configuration documentation](https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md).

          Replace `hostname` in the example with the relevant `nixosConfigurations` output name.

        '';
        configExample = renderExample [
          "{"
          "  settings = {"
          "    nixd = {"
          "      options = {"
          "        nixos = {"
          "          expr = \"(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.hostname.options\";"
          "        };"
          "      };"
          "    };"
          "  };"
          "}"
        ];
        description = "nixd is a Nix language server based on Nix libraries.";
      };
      rust_analyzer = {
        configDescription = ''
          Configurations for rust_analyzer. Server settings belong under `settings."rust-analyzer"` and are described in the [rust-analyzer configuration documentation](https://rust-analyzer.github.io/book/configuration.html).

        '';
        configExample = renderExample [
          "{"
          "  settings = {"
          "    rust-analyzer = {"
          "      check = {"
          "        command = \"clippy\";"
          "      };"
          "    };"
          "  };"
          "}"
        ];
        description = "rust-analyzer is a language server that provides IDE functionality for Rust.";
      };
      terraformls = {
        configDescription = ''
          Configurations for terraformls. Terraform Language Server reads static configuration from `init_options`; `settings` is not supported. See the [Terraform Language Server settings documentation](https://github.com/hashicorp/terraform-ls/blob/main/docs/SETTINGS.md).

        '';
        configExample = renderExample [
          "{"
          "  init_options = {"
          "    ignoreSingleFileWarning = true;"
          "    indexing = {"
          "      ignoreDirectoryNames = ["
          "        \".direnv\""
          "      ];"
          "    };"
          "  };"
          "}"
        ];
        description = "Terraform Language Server provides language features for Terraform configuration.";
      };
      tinymist = {
        configDescription = ''
          Configurations for tinymist. Configuration options are described in the [Tinymist documentation](https://myriad-dreamin.github.io/tinymist/).

        '';
        configExample = renderExample [
          "{"
          "  settings = {"
          "    formatterMode = \"typstyle\";"
          "  };"
          "}"
        ];
        description = "Tinymist is a language server for the typesetting system Typst.";
      };
      yamlls = {
        configDescription = ''
          Configurations for yamlls. Configuration options are described in the [YAML Language Server settings documentation](https://github.com/redhat-developer/yaml-language-server#language-server-settings).

        '';
        configExample = renderExample [
          "{"
          "  settings = {"
          "    yaml = {"
          "      schemas = {"
          "        \"https://json.schemastore.org/github-workflow.json\" = \"/.github/workflows/*\";"
          "      };"
          "    };"
          "  };"
          "}"
        ];
        description = "YAML Language Server provides validation, completion, formatting, and schema-based intelligence for YAML.";
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
        gopls: {
          description: .["lsp.servers.gopls"].description,
          configDescription: .["lsp.servers.gopls.config"].description,
          configExample: .["lsp.servers.gopls.config"].example.text
        },
        nixd: {
          description: .["lsp.servers.nixd"].description,
          configDescription: .["lsp.servers.nixd.config"].description,
          configExample: .["lsp.servers.nixd.config"].example.text
        },
        rust_analyzer: {
          description: .["lsp.servers.rust_analyzer"].description,
          configDescription: .["lsp.servers.rust_analyzer.config"].description,
          configExample: .["lsp.servers.rust_analyzer.config"].example.text
        },
        terraformls: {
          description: .["lsp.servers.terraformls"].description,
          configDescription: .["lsp.servers.terraformls.config"].description,
          configExample: .["lsp.servers.terraformls.config"].example.text
        },
        tinymist: {
          description: .["lsp.servers.tinymist"].description,
          configDescription: .["lsp.servers.tinymist.config"].description,
          configExample: .["lsp.servers.tinymist.config"].example.text
        },
        yamlls: {
          description: .["lsp.servers.yamlls"].description,
          configDescription: .["lsp.servers.yamlls.config"].description,
          configExample: .["lsp.servers.yamlls.config"].example.text
        }
      }
    ' ${selfPackages.options-json}/share/doc/nixos/options.json > "$out"
  '';
in
pkgs.testers.testEqualContents {
  assertion = "generated LSP server documentation";
  inherit actual expected;
}
