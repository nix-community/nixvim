{
  example = {
    plugins.lsp = {
      enable = true;

      servers.nixd = {
        enable = true;

        settings = {
          nixpkgs.expr = ''
            import (builtins.getFlake "/home/lyc/workspace/CS/OS/NixOS/flakes").inputs.nixpkgs { }
          '';

          formatting = {
            command = [ "nixpkgs-fmt" ];
          };

          options = {
            nixos.expr = ''
              (builtins.getFlake "/home/lyc/flakes").nixosConfigurations.adrastea.options
            '';

            home-manager.expr = ''
              (builtins.getFlake "/home/lyc/flakes").homeConfigurations."lyc@adrastea".options
            '';
          };
        };
      };
    };
  };
}
