{lib}:
with lib; {
  options = {
    enable = mkEnableOption "nixvim";
    defaultEditor = mkEnableOption "nixvim as the default editor";
  };
}
