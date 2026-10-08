{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "jqx";
  moduleName = "nvim-jqx.config";
  package = "nvim-jqx";
  callSetup = false;

  maintainers = [ lib.maintainers.arne-zillhardt ];

  dependencies = [
    "jq"
    "yq"
  ];

  settingsExample = {
    geometry = {
      border = "single";
      width = 0.7;
    };
    query_key = "X";
    sort = false;
    show_legend = true;
    use_quickfix = false;
  };
}
