{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lint;

  linterOptions = with types; {
    cmd = {
      type = str;
      description = "The command to call the linter";
      example = "linter_cmd";
      mandatory = true;
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
      type = lib.types.strLuaFn;
      description = "The code for your parser function.";
      example = ''
        require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts)
      '';
      apply = helpers.mkRaw;
      mandatory = true;
    };
  };

  mkLinterOpts =
    noDefaults:
    types.submodule {
      freeformType = types.attrs;

      options = mapAttrs (
        optionName:
        (
          {
            mandatory ? false,
            apply ? x: x,
            example ? null,
            type,
            description,
          }:
          mkOption (
            {
              inherit apply description example;
            }
            // (
              if
                noDefaults && mandatory
              # Make this option mandatory
              then
                { inherit type; }
              # make it optional
              else
                {
                  type = types.nullOr type;
                  default = null;
                }
            )
          )
        )
      ) linterOptions;
    };
in
{
  options.plugins.lint = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "nvim-lint";

    package = lib.mkPackageOption pkgs "nvim-lint" {
      default = [
        "vimPlugins"
        "nvim-lint"
      ];
    };

    lintersByFt = mkOption {
      type = with types; attrsOf (listOf str);
      default = { };
      description = ''
        Configure the linters you want to run per file type.
      '';
      example = {
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
      };
    };

    linters = mkOption {
      type = with types; attrsOf (mkLinterOpts false);
      default = { };
      description = ''
        Customize the existing linters by overriding some of their properties.
      '';
      example = {
        phpcs.args = [
          "-q"
          "--report=json"
          "-"
        ];
      };
    };

    customLinters = mkOption {
      type = with types; attrsOf (either str (mkLinterOpts true));
      default = { };
      description = ''
        Configure the linters you want to run per file type.
        It can be both an attrs or a string containing the lua code that returns the appropriate
        table.
      '';
      example = { };
    };

    autoCmd =
      let
        defaultEvent = "BufWritePost";
        defaultCallback = helpers.mkRaw ''
          function()
            require('lint').try_lint()
          end
        '';
      in
      mkOption {
        type =
          with types;
          nullOr (submodule {
            options = helpers.autocmd.autoCmdOptions // {
              event = mkOption {
                type = with types; nullOr (either str (listOf str));
                default = defaultEvent;
                description = "The event or events that should trigger linting.";
              };

              callback = mkOption {
                type = with types; nullOr (either str rawLua);
                default = defaultCallback;
                description = "What action to perform for linting";
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
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraConfigLua =
      ''
        __lint = require('lint')
        __lint.linters_by_ft = ${helpers.toLuaObject cfg.lintersByFt}
      ''
      + (optionalString (cfg.linters != { }) (
        concatLines (
          flatten (
            mapAttrsToList (
              linter: linterConfig:
              mapAttrsToList (
                propName: propValue:
                optionalString (
                  propValue != null
                ) ''__lint.linters["${linter}"]["${propName}"] = ${helpers.toLuaObject propValue}''
              ) linterConfig
            ) cfg.linters
          )
        )
      ))
      + (optionalString (cfg.customLinters != { }) (
        concatLines (
          mapAttrsToList (
            customLinter: linterConfig:
            let
              linterConfig' = if isString linterConfig then helpers.mkRaw linterConfig else linterConfig;
            in
            ''__lint.linters["${customLinter}"] = ${helpers.toLuaObject linterConfig'}''
          ) cfg.customLinters
        )
      ));

    autoCmd = optional (cfg.autoCmd != null) cfg.autoCmd;
  };
}
