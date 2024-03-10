{
  example = {
    plugins.lsp = {
      enable = true;

      servers.nixd = {
        # TODO As of 2024-03-10, nixd is broken (see https://github.com/nix-community/nixd/issues/357)
        enable = false;

        settings = {
          eval = {
            target = {
              args = ["foo" "bar"];
              installable = "";
            };
            depth = 0;
            workers = 3;
          };
          formatting = {
            command = "nixpkgs-fmt";
          };
          options = {
            enable = true;
            target = {
              args = ["yes" "no" "maybe"];
              installable = "";
            };
          };
        };
      };
    };
  };
}
