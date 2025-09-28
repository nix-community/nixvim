{
  example = {
    lsp.servers = {
      "*".settings = {
        enable = true;
        root_markers = [ ".git" ];
        capabilities.textDocument.semanticTokens = {
          multilineTokenSupport = true;
        };
      };
      luals.enable = true;
      clangd = {
        enable = true;
        settings = {
          cmd = [
            "clangd"
            "--background-index"
          ];
          root_markers = [
            "compile_commands.json"
            "compile_flags.txt"
          ];
          filetypes = [
            "c"
            "cpp"
          ];
        };
      };
    };
  };

  package-fallback =
    { lib, config, ... }:
    {
      test.buildNixvim = false;

      lsp = {
        servers = {
          nil_ls.enable = true;
          rust_analyzer = {
            enable = true;
            packageFallback = true;
          };
          hls = {
            enable = true;
            packageFallback = true;
          };
        };
      };

      assertions =
        let
          assertPrefix = name: pkg: [
            {
              assertion = lib.all (x: x == pkg) config.extraPackages;
              message = "Expected `${name}` to be in extraPackages";
            }
            {
              assertion = lib.any (x: x != pkg) config.extraPackagesAfter;
              message = "Expected `${name}` not to be in extraPackagesAfter";
            }
          ];
          assertSuffix = name: pkg: [
            {
              assertion = lib.all (x: x != pkg) config.extraPackages;
              message = "Expected `${name}` not to be in extraPackages";
            }
            {
              assertion = lib.any (x: x == pkg) config.extraPackagesAfter;
              message = "Expected `${name}` to be in extraPackagesAfter";
            }
          ];
        in
        with config.lsp.servers;
        (
          assertPrefix "nil" nil_ls.package
          ++ assertSuffix "rust-analyzer" rust_analyzer.package
          ++ assertSuffix "haskell-language-server" hls.package
        );
    };
}
