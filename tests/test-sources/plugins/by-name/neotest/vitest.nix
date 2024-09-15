{ lib, pkgs, ... }:
{
  # TODO: added 2024-09-15
  # TODO: Re-enable when upstream builds in darwin sandbox
  example = lib.mkIf pkgs.stdenv.isLinux {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters.vitest = {
          enable = true;

          settings = {
            filter_dir.__raw = ''
              function(name, rel_path, root)
                return name ~= "node_modules"
              end
            '';
          };
        };
      };
    };
  };
}
