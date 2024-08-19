{
  empty = {
    plugins.coq-nvim.enable = true;
  };

  nixvim-defaults =
    { pkgs, ... }:
    {
      plugins.coq-nvim = {
        # It seems that the plugin has issues being executed in the same derivation
        enable = !(pkgs.stdenv.isDarwin && pkgs.stdenv.isx86_64);

        settings = {
          xdg = true;
          auto_start = true;
          keymap.recommended = true;
          completion.always = true;
        };
      };
    };

  artifacts = {
    plugins.coq-nvim = {
      enable = true;
      installArtifacts = true;
    };
  };
}
