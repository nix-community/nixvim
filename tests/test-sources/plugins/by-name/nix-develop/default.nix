{
  empty = {
    plugins.nix-develop.enable = true;
  };

  example = {
    plugins.nix-develop = {
      enable = true;
      ignoredVariables = {
        HOME = true;
      };
      separatedVariables = {
        LUA_PATH = ":";
      };
    };
  };
}
