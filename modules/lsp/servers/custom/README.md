# Custom LSP server modules

This directory contains modules that relate to a specific server.
Files are auto-imported into the submodule based on their name.

For example, a file named `foo.nix` or `foo/default.nix` would be imported into the `lsp.servers.foo` submodule.

A corresponding `lsp.servers.<name>` option must exist for every module in this directory.
