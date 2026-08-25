{
  empty = {
    plugins.coq-nvim.enable = true;
  };

  nixvim-defaults = {
    plugins.coq-nvim = {
      enable = true;

      settings = {
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

  call-setup =
    { config, lib, ... }:
    {
      plugins.coq-nvim = {
        enable = true;
        callSetup = true;
      };

      assertions = [
        {
          assertion =
            builtins.length (lib.splitString "require('coq')" config.plugins.coq-nvim.luaConfig.content) == 2;
          message = "Forced coq-nvim setup should require the coq module once.";
        }
      ];
    };
}
