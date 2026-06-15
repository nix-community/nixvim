{
  empty = {
    plugins.coq-nvim.enable = true;
  };

  nixvim-defaults = {
    plugins.coq-nvim = {
      enable = true;

      settings = {
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
