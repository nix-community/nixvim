{pkgs}: {
  example = {
    plugins.lsp = {
      enable = true;

      servers.nixd = {
        # TODO nixd is currently broken on Darwin
        # https://github.com/nix-community/nixd/issues/107
        # Thus, this test is currently disabled.
        enable = !pkgs.stdenv.isDarwin;

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
