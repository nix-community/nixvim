{ lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.nixvim) defaultNullOpts toLuaObject;

  linterOptions = with types; {
    cmd = {
      type = str;
      description = "The command to call the linter";
      example = "linter_cmd";
    };

    stdin = {
      type = bool;
      description = ''
        Whether this parser supports content input via stdin.
        In that case the filename is automatically added to the arguments.

        Default: `true`
      '';
      example = false;
    };

    append_fname = {
      type = bool;
      description = ''
        Automatically append the file name to `args` if `stdin = false`
        Whether this parser supports content input via stdin.
        In that case the filename is automatically added to the arguments.

        Default: `true`
      '';
      example = false;
    };

    args = {
      type = listOf (either str rawLua);
      description = ''
        List of arguments.
        Can contain functions with zero arguments that will be evaluated once the linter is used.

        Default: `[]`
      '';
    };

    stream = {
      type = enum [
        "stdout"
        "stderr"
        "both"
      ];
      description = ''
        configure the stream to which the linter outputs the linting result.

        Default: `"stdout"`
      '';
      example = "stderr";
    };

    ignore_exitcode = {
      type = bool;
      description = ''
        Whether the linter exiting with a code !=0 should be considered normal.

        Default: `false`
      '';
      example = true;
    };

    env = {
      type = attrsOf str;
      description = ''
        Custom environment table to use with the external process.
        Note that this replaces the **entire** environment, it is not additive.
      '';
      example = {
        FOO = "bar";
      };
    };

    parser = {
      type = strLuaFn;
      description = "The code for your parser function.";
      example = ''
        require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts)
      '';
    };
  };

  mkLinterOpts = types.submodule {
    freeformType = types.attrs;

    options = builtins.mapAttrs (
      optionName:
      (
        {
          apply ? x: x,
          example ? null,
          type,
          description,
        }:
        mkOption {
          inherit apply description example;
          type = types.nullOr type;
          default = null;
        }
      )
    ) linterOptions;
  };
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "lint";
  originalName = "nvim-lint";
  package = "nvim-lint";
  callSetup = false;
  hasSettings = false;

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  extraOptions = {
    autoCmd =
      let
        defaultEvent = "BufWritePost";
        defaultCallback = lib.nixvim.mkRaw ''
          function()
            require('lint').try_lint()
          end
        '';
      in
      mkOption {
        type =
          with types;
          nullOr (submodule {
            options = lib.nixvim.autocmd.autoCmdOptions // {
              callback = mkOption {
                type = with types; nullOr (either str rawLua);
                default = defaultCallback;
                description = "What action to perform for linting";
              };

              event = mkOption {
                type = with types; nullOr (either str (listOf str));
                default = defaultEvent;
                description = "The event or events that should trigger linting.";
              };
            };
          });
        description = ''
          The configuration for the linting autocommand.
          You can disable it by setting this option to `null`.
        '';
        default = {
          event = defaultEvent;
          callback = defaultCallback;
        };
      };

    linters =
      defaultNullOpts.mkAttrsOf mkLinterOpts
        {
          phpcs.args = [
            "-q"
            "--report=json"
            "-"
          ];
        }
        ''
          Configure the linters you want to run.
          You can also add custom linters here.
        '';

    linters_by_ft =
      defaultNullOpts.mkAttrsOf (types.listOf types.str)
        {
          text = [ "vale" ];
          json = [ "jsonlint" ];
          markdown = [ "vale" ];
          rst = [ "vale" ];
          ruby = [ "ruby" ];
          janet = [ "janet" ];
          inko = [ "inko" ];
          clojure = [ "clj-kondo" ];
          dockerfile = [ "hadolint" ];
          terraform = [ "tflint" ];
        }
        ''
          Configure the linters you want to run per file type.
        '';
  };

  imports = [
    ./deprecations.nix
  ];

  extraConfig = cfg: {
    autoCmd = lib.optionals (cfg.autoCmd != null) [ cfg.autoCmd ];
    plugins.lint.luaConfig.content =
      ''
        local lint = require('lint')
      ''
      + (lib.optionalString (cfg.linters_by_ft != null) ''
        lint.linters_by_ft = ${toLuaObject cfg.linters_by_ft}
      '')
      + (lib.optionalString (cfg.linters != null) (
        lib.concatLines (
          lib.mapAttrsToList (
            linter: linterConfig:
            let
              linterConfig' =
                if builtins.isString linterConfig then lib.nixvim.mkRaw linterConfig else linterConfig;
            in
            ''lint.linters.${linter} = ${toLuaObject linterConfig'}''
          ) cfg.linters
        )
      ));
  };
}
