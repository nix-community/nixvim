{
  example = {
    plugins.lsp = {
      enable = true;

      servers.nixd = {
        enable = true;

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
