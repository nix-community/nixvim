{
  example = {
    plugins.lsp = {
      enable = true;

      servers.nixd = {
        enable = true;

        settings = {
          eval = {
            target = {
              args = [
                "foo"
                "bar"
              ];
              installable = "";
            };
            depth = 0;
            workers = 3;
          };
          formatting = {
            command = [ "nixpkgs-fmt" ];
          };
          options = {
            nixos.expr = "(toString ./.).nixosConfigurations.kaboom.options";
          };
        };
      };
    };
  };
}
