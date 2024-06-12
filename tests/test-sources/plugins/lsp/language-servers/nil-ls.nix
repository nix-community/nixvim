{
  example = {
    plugins.lsp = {
      enable = true;

      servers.nil-ls = {
        enable = true;

        settings = {
          diagnostics = {
            ignored = [
              "unused_binding"
              "unused_with"
            ];
            excludedFiles = [ "Cargo.nix" ];
          };
          formatting = {
            command = [ "nixfmt" ];
          };
          nix = {
            binary = "nix";
            maxMemoryMB = 2048;
            flake = {
              autoArchive = true;
              autoEvalInputs = false;
              nixpkgsInputName = "nixpkgs";
            };
          };
        };
      };
    };
  };
}
