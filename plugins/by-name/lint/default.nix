{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.nixvim) defaultNullOpts toLuaObject;

  linterOptions = {
    cmd = {
      type = types.str;
      description = "The command to call the linter";
      example = "linter_cmd";
      mandatory = true;
    };

    stdin = {
      type = types.bool;
      description = ''
        Whether this parser supports content input via stdin.
        In that case the filename is automatically added to the arguments.

        Default: `true`
      '';
      example = false;
    };

    append_fname = {
      type = types.bool;
      description = ''
        Automatically append the file name to `args` if `stdin = false`
        Whether this parser supports content input via stdin.
        In that case the filename is automatically added to the arguments.

        Default: `true`
      '';
      example = false;
    };

    args = {
      type = with types; listOf (either str rawLua);
      description = ''
        List of arguments.
        Can contain functions with zero arguments that will be evaluated once the linter is used.

        Default: `[]`
      '';
    };

    stream = {
      type = types.enum [
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
      type = types.bool;
      description = ''
        Whether the linter exiting with a code !=0 should be considered normal.

        Default: `false`
      '';
      example = true;
    };

    env = {
      type = with types; attrsOf str;
      description = ''
        Custom environment table to use with the external process.
        Note that this replaces the **entire** environment, it is not additive.
      '';
      example = {
        FOO = "bar";
      };
    };

    parser = {
      type = types.strLuaFn;
      description = "The code for your parser function.";
      example = ''
        require('lint.parser').from_pattern(pattern, groups, severity_map, defaults, opts)
      '';
      mandatory = true;
    };
  };

  mkLinterOpts =
    noDefaults:
    types.submodule {
      freeformType = with types; attrsOf anything;

      options = builtins.mapAttrs (
        _:
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
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lint";
  package = "nvim-lint";
  callSetup = false;
  hasSettings = false;
  description = "An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol support.";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  extraOptions = {
    autoInstall = {
      enable = lib.mkEnableOption ''
        automatic installation of linters listed in `lintersByFt`
      '';

      enableWarnings = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable warnings.";
        type = lib.types.bool;
      };

      overrides = lib.mkOption {
        type = with types; attrsOf (nullOr package);
        default = { };
        example = lib.literalExpression ''
          {
            "jsonlint" = null;
            "my-linter" = pkgs.writeShellApplication {
              name = "my-linter";
              text = "exec my-linter \"$@\"";
            };
          }
        '';
        description = ''
          Attribute set of linter names to nix packages.
          You can set a linter to `null` to disable auto-installing its package.
        '';
      };
    };

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

    customLinters = defaultNullOpts.mkAttrsOf (with types; either str (mkLinterOpts true)) { } ''
      Configure the linters you want to run per file type.
      It can be both an attrs or a string containing the lua code that returns the appropriate
      table.
    '';

    linters =
      defaultNullOpts.mkAttrsOf (mkLinterOpts false)
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

    lintersByFt =
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

  extraConfig =
    cfg: opts:
    let
      inherit (cfg.autoInstall) enable enableWarnings;
      inherit (import ./auto-install.nix { inherit pkgs lib; })
        collectLinters
        getPackageOrStateByName
        mkWarnsFromStates
        ;
      configuredLinters = if cfg.linters == null then { } else cfg.linters;
      customLinters = if cfg.customLinters == null then { } else cfg.customLinters;
      definedLinters = builtins.attrNames configuredLinters ++ builtins.attrNames customLinters;
      getPackageOrStateByNameWith = getPackageOrStateByName {
        inherit definedLinters;
        inherit (cfg.autoInstall) overrides;
      };
      selectedLinters = lib.optionals (cfg.lintersByFt != null) (collectLinters cfg.lintersByFt);
      packagesAndStates = lib.foldAttrs (item: acc: [ item ] ++ acc) [ ] (
        map getPackageOrStateByNameWith selectedLinters
      );
    in
    {
      autoCmd = lib.optionals (cfg.autoCmd != null) [ cfg.autoCmd ];
      warnings = lib.mkIf (enable && enableWarnings) (
        mkWarnsFromStates opts (packagesAndStates.wrong or [ ])
      );
      extraPackages = lib.mkIf enable (packagesAndStates.right or [ ]);

      plugins.lint.luaConfig.content = ''
        local __lint = require('lint')
      ''
      + (lib.optionalString (cfg.lintersByFt != null) ''
        __lint.linters_by_ft = ${toLuaObject cfg.lintersByFt}
      '')
      + (lib.optionalString (cfg.customLinters != null) (
        lib.concatLines (
          lib.mapAttrsToList (
            customLinter: linterConfig:
            let
              linterConfig' =
                if builtins.isString linterConfig then lib.nixvim.mkRaw linterConfig else linterConfig;
            in
            ''__lint.linters["${customLinter}"] = ${toLuaObject linterConfig'}''
          ) cfg.customLinters
        )
      ))
      + (lib.optionalString (cfg.linters != null) (
        lib.concatLines (
          lib.flatten (
            lib.mapAttrsToList (
              linter: linterConfig:
              lib.mapAttrsToList (
                propName: propValue:
                lib.optionalString (
                  propValue != null
                ) ''__lint.linters["${linter}"].${propName} = ${toLuaObject propValue}''
              ) linterConfig
            ) cfg.linters
          )
        )
      ));
    };
}
