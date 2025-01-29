{ lib, config, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "copilot-cmp";
  moduleName = "copilot_cmp";

  imports = [
    { cmpSourcePlugins.copilot = "copilot-cmp"; }
  ];

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-12-19: remove after 25.05
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "event"
    "fixPairs"
  ];

  settingsOptions = {
    event =
      defaultNullOpts.mkListOf types.str
        [
          "InsertEnter"
          "LspAttach"
        ]
        ''
          Configures when the source is registered.

          Unless you have a unique problem for your particular configuration you probably don't want to
          touch this.
        '';

    fix_pairs = defaultNullOpts.mkBool true ''
      Suppose you have the following code: `print('h')`.
      Copilot might try to account for the `'` and `)` and complete it with this: `print('hello`.

      This is not good behavior for consistency reasons and will just end up deleting the two ending
      characters.
      This option fixes that.
      Don't turn this off unless you are having problems with pairs and believe this might be
      causing them.
    '';
  };

  settingsExample = {
    event = [
      "InsertEnter"
      "LspAttach"
    ];
    fix_pairs = false;
  };

  extraConfig = {
    warnings =
      let
        copilot-lua-cfg = config.plugins.copilot-lua.settings;
      in
      lib.nixvim.mkWarnings "plugins.copilot-cmp" [
        {
          when = copilot-lua-cfg.suggestion.enabled == true;
          message = ''
            It is recommended to disable copilot's `suggestion` module, as it can interfere with
            completions properly appearing in copilot-cmp.
          '';
        }
        {
          when = copilot-lua-cfg.panel.enabled == true;
          message = ''
            It is recommended to disable copilot's `panel` module, as it can interfere with completions
            properly appearing in copilot-cmp.
          '';
        }
      ];

    plugins.copilot-lua.enable = lib.mkDefault true;
  };
}
