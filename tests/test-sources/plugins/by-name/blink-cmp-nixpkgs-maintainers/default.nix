{
  empty = {
    plugins = {
      blink-cmp.enable = true;
      blink-cmp-nixpkgs-maintainers.enable = true;
    };
  };

  example = {
    plugins = {
      blink-cmp-nixpkgs-maintainers.enable = true;
      blink-cmp = {
        enable = true;

        settings.sources = {
          per_filetype = {
            markdown = [ "nixpkgs_maintainers" ];
          };
          providers = {
            nixpkgs_maintainers = {
              module = "blink_cmp_nixpkgs_maintainers";
              name = "nixpkgs maintainers";
              opts = {
                cache_lifetime = 14;
                silent = false;
                nixpkgs_flake_uri = "nixpkgs";
              };
            };
          };
        };
      };
    };
  };
}
