{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "coq-thirdparty";
  maintainers = [ lib.maintainers.GaetanLepage ];

  # The lua setup call is: `require('coq_3p')({...})`
  moduleName = "coq_3p";
  setup = "";

  # TODO: Added 2025-10-24, remove after 26.05
  imports =
    let
      basePluginPath = [
        "plugins"
        "coq-thirdparty"
      ];
    in
    [
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "sources" ]) (basePluginPath ++ [ "settings" ]))
    ];

  settingsExample = [
    {
      src = "nvimlua";
      short_name = "nLUA";
    }
    {
      src = "vimtex";
      short_name = "vTEX";
    }
    { src = "demo"; }
  ];
}
