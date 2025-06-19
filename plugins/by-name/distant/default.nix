{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    defaultNullOpts
    literalLua
    mkNullOrOption
    mkNullOrStr
    ;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "distant";
  packPathName = "distant.nvim";
  package = "distant-nvim";
  description = "Edit files, run programs, and work with LSP on a remote machine from the comfort of your local environment.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  setup = ":setup";

  dependencies = [ "distant" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "distant";
      packageName = "distant";
    })
  ];

  settingsOptions = {
    buffer = {
      watch = {
        enabled = defaultNullOpts.mkBool true ''
          If true, will watch buffers for changes.
        '';
        retry_timeout = defaultNullOpts.mkUnsignedInt 5000 ''
          Time in milliseconds between attempts to retry a watch request for a buffer when the path
          represented by the buffer does not exist.

          Set to `0` to disable.
        '';
      };
    };

    client = {
      bin = defaultNullOpts.mkStr' {
        example = lib.literalMD ''"\$\{lib.getExe distant}"'';
        pluginDefault = literalLua ''
          (function()
            local os_name = require('distant-core').utils.detect_os_arch()
            return os_name == 'windows' and 'distant.exe' or 'distant'
          end)()
        '';
        description = ''
          Binary to use locally with the client.

          Defaults to `"distant"` on Unix platforms and `"distant.exe"` on Windows.
        '';
      };

      log_file = defaultNullOpts.mkStr null ''
        Log file path.
      '';

      log_level =
        defaultNullOpts.mkEnum
          [
            "trace"
            "debug"
            "info"
            "warn"
            "error"
            "off"
          ]
          null
          ''
            Log level.
          '';
    };

    keymap =
      let
        keymapType = with types; either str (listOf str);
        mkKeymap = defaultNullOpts.mkNullable keymapType;
      in
      {
        dir = {
          enabled = defaultNullOpts.mkBool true ''
            If true, will apply keybindings when the buffer is created.
          '';

          copy = mkKeymap "C" ''
            Keymap to copy the file or directory under the cursor.
          '';

          edit = mkKeymap "<Return>" ''
            Keymap to edit the file or directory under the cursor.
          '';

          tabedit = mkKeymap "<C-t>" ''
            Keymap to open the file or directory under the cursor in a new tab.
          '';

          metadata = mkKeymap "M" ''
            Keymap to display metadata for the file or directory under the cursor.
          '';

          newdir = mkKeymap "K" ''
            Keymap to create a new directory within the open directory.
          '';

          newfile = mkKeymap "N" ''
            Keymap to create a new file within the open directory.
          '';

          rename = mkKeymap "R" ''
            Keymap to rename the file or directory under the cursor.
          '';

          remove = mkKeymap "D" ''
            Keymap to remove the file or directory under the cursor.
          '';

          up = mkKeymap "-" ''
            Keymap to navigate up into the parent directory.
          '';
        };

        file = {
          enabled = defaultNullOpts.mkBool true ''
            If true, will apply keybindings when the buffer is created.
          '';

          up = mkKeymap "-" ''
            Keymap to navigate up into the parent directory.
          '';
        };

        ui = {
          exit = mkKeymap [ "q" "<Esc>" ] ''
            Keymap used to exit the window.
          '';

          main = {
            connections = {
              kill = mkKeymap "K" ''
                Kill the connection under cursor.
              '';

              toggle_info = mkKeymap "I" ''
                Toggle information about the server/connection under cursor.
              '';
            };

            tabs = {
              goto_connections = mkKeymap "1" ''
                Keymap used to bring up the connections tab.
              '';

              goto_system_info = mkKeymap "2" ''
                Keymap used to bring up the system info tab.
              '';

              goto_help = mkKeymap "?" ''
                Keymap used to bring up the help menu.
              '';

              refresh = mkKeymap "R" ''
                Keymap used to refresh data in a tab.
              '';
            };
          };
        };
      };

    manager = {
      daemon = defaultNullOpts.mkBool false ''
        If true, when neovim starts a manager, it will be run as a daemon, which will detach it
        from the neovim process.
        This means that the manager will persist after neovim itself exits.
      '';

      lazy = defaultNullOpts.mkBool true ''
        If true, will avoid starting the manager until first needed.
      '';

      log_file = defaultNullOpts.mkStr null ''
        Log file path.
      '';

      log_level =
        defaultNullOpts.mkEnum
          [
            "trace"
            "debug"
            "info"
            "warn"
            "error"
            "off"
          ]
          null
          ''
            Log level.
          '';

      user = defaultNullOpts.mkBool false ''
        If true, when neovim starts a manager, it will listen on a user-local domain socket or
        windows pipe rather than the globally-accessible variant.
      '';
    };

    network = {
      private = defaultNullOpts.mkBool false ''
        If true, will create a private network for all operations associated with a singular
        neovim instance.
      '';

      timeout = {
        max = defaultNullOpts.mkUnsignedInt 15000 ''
          Maximum time to wait (in milliseconds) for requests to finish.
        '';

        interval = defaultNullOpts.mkUnsignedInt 256 ''
          Time to wait (in milliseconds) inbetween checks to see if a request timed out
        '';
      };

      windows_pipe = defaultNullOpts.mkStr null ''
        If provided, will overwrite the pipe name used for network communication on Windows
        machines.
      '';

      unix_socket = defaultNullOpts.mkStr null ''
        If provided, will overwrite the unix socket path used for network communication on Unix
        machines.
      '';
    };

    servers = defaultNullOpts.mkNullable' {
      type = types.attrsOf (
        types.submodule {
          freeformType = with types; attrsOf anything;

          options = {
            connect = {
              default = {
                scheme = mkNullOrStr ''
                  Scheme to use in place of letting distant infer an appropriate scheme (e.g. `"ssh"`).
                '';

                port = mkNullOrOption types.ints.unsigned ''
                  Port to use when connecting.
                '';

                username = mkNullOrStr ''
                  Username when connecting to the server (defaults to user running neovim).
                '';

                options = mkNullOrStr ''
                  Options to pass along to distant when connecting (e.g. ssh backend).
                '';
              };
            };

            cwd = defaultNullOpts.mkStr null ''
              If specified, will apply the current working directory to any cases of spawning
              processes, opening directories & files, starting shells, and wrapping commands.

              Will be overwritten if an explicit `cwd` or absolute path is provided in those
              situations.
            '';

            launch = {
              default = {
                scheme = mkNullOrStr ''
                  Scheme to use in place of letting distant infer an appropriate scheme (e.g. `"ssh"`).
                '';

                port = mkNullOrOption types.ints.unsigned ''
                  Port to use when launching (not same as what server listens on).
                '';

                username = mkNullOrStr ''
                  Username when accessing machine to launch server (defaults to user running
                  neovim).
                '';

                bin = mkNullOrStr ''
                  Path to distant binary on remote machine.
                '';

                args = mkNullOrOption (with types; listOf str) ''
                  Additional CLI arguments for binary upon launch.
                '';

                options = mkNullOrStr ''
                  Options to pass along to distant when launching (e.g. ssh backend).
                '';
              };
            };

            lsp =
              defaultNullOpts.mkAttrsOf
                (types.submodule {
                  freeformType = with types; attrsOf anything;
                  options = {
                    cmd = mkNullOrOption (with types; either str (listOf str)) ''
                      LSP command to run.
                    '';

                    root_dir = mkNullOrOption (with types; either str (listOf str)) ''
                      Path to the root directory or a function to locate it:
                      ```lua
                      fun(path:string, bufnr:number):string
                      ```
                    '';

                    filetypes = mkNullOrOption (with types; listOf str) ''
                      List of filetypes for which to enable this LSP server.
                    '';

                    on_exit = mkNullOrOption types.rawLua ''
                      Callback when exiting the LSP server.

                      ```lua
                      fun(code:number, signal?:number, client_id:string)
                      ```
                    '';
                  };
                })
                { }
                ''
                  Settings to use to start LSP instances.
                  Mapping of a label to the settings for that specific LSP server
                '';
          };
        }
      );
      description = ''
        Collection of settings for servers defined by their hostname.

        A key of `"*"` is special in that it is considered the default for all servers and will be
        applied first with any host-specific settings overwriting the default.
      '';
      example = {
        "192.168.1.42" = {
          default = {
            username = "me";
            port = 11451;
          };
        };
      };
      pluginDefault = {
        "*" = {
          connect.default = { };
          cwd = null;
          launch.default = { };
          lsp = { };
        };
      };
    };
  };

  settingsExample = {
    "network.unix_socket" = "/tmp/distant.sock";
    servers."192.168.1.42" = {
      default = {
        username = "me";
        port = 11451;
      };
    };
  };
}
