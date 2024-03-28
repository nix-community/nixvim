{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  originalName = "hydra.nvim";
  name = "hydra-nvim";
  package = pkgs.vimPlugins.hydra-nvim;
  configOptionsSet = {
    exit = helpers.defaultNullOptions.mkBool false ''
      set the default exit value for each head in the hydra
    '';
    # TODO:is this right?
    foreign_keys = helpers.defaultNullOptions.mkEnum [null "warn" "run"] null ''
      decides what to do when a key which doesn't belong to any head is pressed
      nil: hydra exits and foreign key behaves normally, as if the hydra wasn't active
      "warn": hydra stays active, issues a warning and doesn't run the foreign key
      "run": hydra stays active, runs the foreign key
    '';
    color = helpers.defaultNullOptions.mkEnumFirstDefault ["red" "amaranth" "teal" "pink"] ''
      see `:h hydra-colors`
    '';
    # define a hydra for the given buffer, pass `true` for current buf
    # buffer = nil,
    invoke_on_body = helpers.defaultNullOptions.mkBool false ''
      when true, summon the hydra after pressing only the `body` keys.
      Normally a head is required
    '';
    desc = helpers.defaultNullOptions.mkStr null ''
      description used for the body keymap when `invoke_on_body` is true
    '';
    on_enter = helpers.mkNullOrLua ''
      called when the hydra is activated
    '';
    on_exit = helpers.mkNullOrLua ''
      called before the hydra is deactivated
    '';
    on_key = helpers.mkNullOrLua ''
      called after every hydra head
    '';
    # TODO: how do i make the type for this?
    timeout = helpers.defaultNullOptions.mkBool false ''
      timeout after which the hydra is automatically disabled. Calling any head
      will refresh the timeout
      true: timeout set to value of 'timeoutlen' (:h 'timeoutlen')
      5000: set to desired number of milliseconds
      false: will wait forever
    '';
    # TODO: how do i make the type for this?
    hint = helpers.defaultNullOptions.mkBool false ''
      see :h hydra-hint-hint-configuration
    '';
  };
  configOptions = helpers.mkSettingsOptions {options = configOptionsSet;};
  headSubmodule = {
    options = {
      head = lib.mkOption {
        type = lib.types.str;
        example = lib.literalExpression "<C-a>";
        description = lib.mdDoc "key sequence that you press to perform the action";
      };
      rhs = lib.mkOption {
        type = lib.types.either lib.types.str helpers.nixvimTypes.rawLua;
        example = lib.literalExpression ''{__raw = "function () require('luasnip').expand() end";}'';
        description = lib.mdDoc "key sequence pressed or lua function executed when the head is invoked";
      };
      opts = helpers.mkSettingOptions {
        options = {
          private = helpers.defaultNullOptions.mkBool false ''
            Private heads are unreachable outside of the hydra state.
          '';
          exit = helpers.defaultNullOptions.mkBool false ''
            When true, stops the hydra after executing this head
            NOTE:
              All exit heads are private
              If no exit head is specified, esc is set by default
          '';
        };
      };
    };
  };
  hydraSubmodule = {
    options = {
      name = mkOption {
        type = lib.types.str;
        example = "myHydra";
        description = lib.mdDoc "hydra's internal name";
      };
      mode = helpers.keymaps.mkModeOption null;
      body = mkOption {
        type = lib.types.str;
        example = lib.literalExpression "<leader>h";
        description = lib.mdDoc "key sequence that invokes hydra";
      };
      hint = helpers.defaultNullOptions.mkStr "";
      config = configOptions;
      heads = mkOption {
        type = lib.types.listOf (lib.types.submodule headSubmodule);
        default = [];
      };
    };
  };
  cfg = config.plugins.hydra-nvim;
in {
  options.plugins.hydra-nvim = {
    enable = lib.mkEnableOption originalName;
    package = helpers.mkPackageOption originalName package;
    globalConfig = configOptions;
    hydras = lib.types.listOf (lib.types.submodule hydraSubmodule);
  };
  config = mkIf cfg.enable {
    extraConfigLua = ''
      local Hydra = require("hydra")
      Hydra.setup(${helpers.toLuaObject cfg.globalConfig})
    '';
    # TODO: normalize and create hydras
  };
}
