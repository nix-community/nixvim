{ lib }:
let
  inherit (lib) types;
  inherit (lib.nixvim) mkNullOrOption;
in
rec {
  mkAdapterType =
    attrs:
    types.submodule {
      options = {
        id = mkNullOrOption types.str ''
          Identifier of the adapter. This is used for the
          `adapterId` property of the initialize request.
          For most debug adapters setting this is not necessary.
        '';

        enrichConfig = lib.nixvim.mkNullOrLuaFn ''
          A lua function (`func(config, on_config)`) which allows an adapter to enrich a
          configuration with additional information. It receives a configuration as first
          argument, and a callback that must be called with the final configuration as second argument.
        '';

        options = {
          initializeTimeoutSec = lib.nixvim.defaultNullOpts.mkInt 4 ''
            How many seconds the client waits for a response on a initialize request before emitting a warning.
          '';

          disconnectTimeoutSec = lib.nixvim.defaultNullOpts.mkInt 3 ''
            How many seconds the client waits for a disconnect response from the debug
            adapter before emitting a warning and closing the connection.
          '';

          sourceFiletype = mkNullOrOption types.str ''
            The filetype to use for content retrieved via a source request.
          '';
        };
      } // attrs;
    };

  executableAdapterOption = mkAdapterType {
    command = mkNullOrOption types.str "The command to invoke.";

    args = mkNullOrOption (types.listOf types.str) "Arguments for the command.";

    options = {
      env = mkNullOrOption types.attrs "Set the environment variables for the command.";

      cwd = mkNullOrOption types.str "Set the working directory for the command.";

      detached = lib.nixvim.defaultNullOpts.mkBool true "Start the debug adapter in a detached state.";
    };
  };

  serverAdapterOption = mkAdapterType {
    host = lib.nixvim.defaultNullOpts.mkStr "127.0.0.1" "Host to connect to.";

    port = mkNullOrOption (types.either types.int (types.enum [ "$\{port}" ])) ''
      Port to connect to.
      If "$\{port}" dap resolves a free port.
      This is intended to be used with `executable.args`.
    '';

    executable = {
      command = mkNullOrOption types.str "Command that spawns the adapter.";

      args = mkNullOrOption (types.listOf types.str) "Command arguments.";

      detached = lib.nixvim.defaultNullOpts.mkBool true "Spawn the debug adapter in detached state.";

      cwd = mkNullOrOption types.str "Working directory.";
    };

    options.maxRetries = lib.nixvim.defaultNullOpts.mkInt 14 ''
      Amount of times the client should attempt to connect before erroring out.
      There is a 250ms delay between each retry.
    '';
  };

  mkAdapterOption =
    name: type:
    mkNullOrOption (with types; attrsOf (either str type)) ''
      Debug adapters of `${name}` type.
      The adapters can also be set to a function which takes three arguments:

      - A `on_config` callback. This must be called with the actual adapter table.
      - The |dap-configuration| which the user wants to use.
      - An optional parent session. This is only available if the debug-adapter
        wants to start a child-session via a `startDebugging` request.

      This can be used to defer the resolving of the values to when a configuration
      is used. A use-case for this is starting an adapter asynchronous.
    '';

  configurationOption = types.submodule {
    freeformType = types.attrs;

    options = {
      type = lib.mkOption {
        description = "Which debug adapter to use.";
        type = types.str;
      };

      request = lib.mkOption {
        type = types.enum [
          "attach"
          "launch"
        ];
        description = ''
          Indicates whether the debug adapter should launch a debuggee or attach to one that is already running.
        '';
      };

      name = lib.mkOption {
        type = types.str;
        description = "A user readable name for the configuration.";
      };
    };
  };

  mkSignOption = default: desc: {
    text = lib.nixvim.defaultNullOpts.mkStr default desc;
    texthl = mkNullOrOption types.str "`texthl` for sign.";
    linehl = mkNullOrOption types.str "`linehl` for sign.";
    numhl = mkNullOrOption types.str "`numhl` for sign.";
  };

  processAdapters =
    type: adapters:
    lib.mapAttrs (
      _: adapter:
      if builtins.isString adapter then
        lib.nixvim.mkRaw adapter
      else
        lib.filterAttrs (n: _: n != "enrichConfig") (
          adapter
          // {
            inherit type;
            enrich_config = adapter.enrichConfig;
          }
        )
    ) adapters;
}
