{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  options.plugins.rainbow-delimiters =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "rainbow-delimiters.nvim";

      package =
        helpers.mkPackageOption
        "rainbow-delimiters.nvim"
        pkgs.vimPlugins.rainbow-delimiters-nvim;

      strategy =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf (
              either
              helpers.nixvimTypes.rawLua
              (enum ["global" "local" "noop"])
            )
        )
        ''
          {
            default = "global";
          }
        ''
        ''
          Attrs mapping Tree-sitter language names to strategies.
          See `|rb-delimiters-strategy|` for more information about strategies.

          Example:
          ```nix
            {
              # Use global strategy by default
              default = "global";

              # Use local for HTML
              html = "local";

              # Pick the strategy for LaTeX dynamically based on the buffer size
              latex.__raw = \'\'
                function()
                  -- Disabled for very large files, global strategy for large files,
                  -- local strategy otherwise
                  if vim.fn.line('$') > 10000 then
                      return nil
                  elseif vim.fn.line('$') > 1000 then
                      return require 'rainbow-delimiters'.strategy['global']
                  end
                  return require 'rainbow-delimiters'.strategy['local']
                end
              \'\';
            }
          ```
        '';

      query =
        helpers.defaultNullOpts.mkNullable
        (with types; attrsOf str)
        ''
          {
            default = "rainbow-delimiters";
            lua = "rainbow-blocks";
          }
        ''
        ''
          Attrs mapping Tree-sitter language names to queries.
          See `|rb-delimiters-query|` for more information about queries.
        '';

      highlight =
        helpers.defaultNullOpts.mkNullable (with types; listOf str)
        ''
          [
            "RainbowDelimiterRed"
            "RainbowDelimiterYellow"
            "RainbowDelimiterBlue"
            "RainbowDelimiterOrange"
            "RainbowDelimiterGreen"
            "RainbowDelimiterViolet"
            "RainbowDelimiterCyan"
          ]
        ''
        ''
          List of names of the highlight groups to use for highlighting, for more information see
          `|rb-delimiters-colors|`.
        '';

      whitelist = helpers.mkNullOrOption (with types; listOf str) ''
        List of Tree-sitter languages for which to enable rainbow delimiters.
        Rainbow delimiters will be disabled for all other languages.
      '';

      blacklist = helpers.mkNullOrOption (with types; listOf str) ''
        List of Tree-sitter languages for which to disable rainbow delimiters.
        Rainbow delimiters will be enabled for all other languages.
      '';

      log = {
        file =
          helpers.defaultNullOpts.mkNullable
          (with types; either str helpers.nixvimTypes.rawLua)
          ''
            {
              __raw = "vim.fn.stdpath('log') .. '/rainbow-delimiters.log'";
            }
          ''
          ''
            Path to the log file, default is `rainbow-delimiters.log` in your standard log path
            (see `|standard-path|`).
          '';

        level = helpers.defaultNullOpts.mkLogLevel "warn" ''
          Only messages equal to or above this value will be logged.
          The default is to log warnings or above.
          See `|log_levels|` for possible values.
        '';
      };
    };

  config = let
    cfg = config.plugins.rainbow-delimiters;
  in
    mkIf cfg.enable {
      warnings =
        optional
        (!config.plugins.treesitter.enable)
        "Nixvim: treesitter-rainbow needs treesitter to function as intended";
      assertions = [
        {
          assertion = (cfg.whitelist == null) || (cfg.blacklist == null);
          message = ''
            Both `rainbow-delimiters.whitelist` and `rainbow-delimiters.blacklist` should not be
            set simultaneously.
            Please remove one of them.
          '';
        }
      ];

      extraPlugins = [cfg.package];

      globals.rainbow_delimiters = with cfg;
        {
          strategy =
            helpers.ifNonNull' strategy
            (
              mapAttrs'
              (
                name: value: {
                  name =
                    if name == "default"
                    then "__emptyString"
                    else name;
                  value =
                    if isString value
                    then helpers.mkRaw "require 'rainbow-delimiters'.strategy['${value}']"
                    else value;
                }
              )
              strategy
            );
          query =
            helpers.ifNonNull' query
            (
              mapAttrs'
              (
                name: value: {
                  name =
                    if name == "default"
                    then "__emptyString"
                    else name;
                  inherit value;
                }
              )
              query
            );
          inherit
            highlight
            whitelist
            blacklist
            ;
          log = with log; {
            inherit
              file
              level
              ;
          };
        }
        // cfg.extraOptions;
    };
}
