{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.lsp;
  opts = options.lsp;

  features = {
    inlayHints.luaName = "inlay_hint";
    codelens.luaName = "codelens";
    semanticTokens = {
      luaName = "semantic_tokens";
      enabledByDefault = true;
    };
    documentColor = {
      luaName = "document_color";
      enabledByDefault = true;
      hasSettings = true;
      settingsExample = {
        style = "virtual";
      };
    };
    linkedEditingRange.luaName = "linked_editing_range";
    onTypeFormatting.luaName = "on_type_formatting";
    inlineCompletion.luaName = "inline_completion";
  };

  mkFeatureOptions =
    name:
    {
      luaName,
      enabledByDefault ? false,
      hasSettings ? false,
      settingsExample ? null,
    }:
    {
      enable = lib.mkEnableOption null // {
        description = ''
          Whether Nixvim manages `vim.lsp.${luaName}`.

          See [`:h lsp-${luaName}`](https://neovim.io/doc/user/lsp/#lsp-${luaName})
        '';
      };

      activate = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Value passed to `vim.lsp.${luaName}.enable()`.
        ''
        + lib.optionalString enabledByDefault ''

          Neovim enables this feature by default. To disable it, set
          `${opts.${name}.enable}` to `true` and this option to `false`.
        '';
      };
    }
    // lib.optionalAttrs hasSettings {
      settings = lib.nixvim.mkSettingsOption {
        description = ''
          Options passed as the `opts` argument to
          `vim.lsp.${luaName}.enable()`. Nixvim passes `nil` for `filter`. Use
          `${opts.luaConfig}.content` to filter by buffer or client.
        '';
        example = settingsExample;
      };
    };

  mkFeatureLua =
    name:
    {
      luaName,
      ...
    }:
    let
      featureCfg = cfg.${name};
      # The `opts` parameter follows `filter`, so pass `nil` as the second argument.
      optsArg = lib.optionalString (
        featureCfg ? settings && featureCfg.settings != { }
      ) ", nil, ${lib.nixvim.toLuaObject featureCfg.settings}";
    in
    lib.mkIf featureCfg.enable "vim.lsp.${luaName}.enable(${lib.boolToString featureCfg.activate}${optsArg})";
in
{
  options.lsp = {
    luaConfig = lib.mkOption {
      type = lib.types.pluginLuaConfig;
      default = { };
      description = ''
        Lua code configuring LSP.
      '';
    };
  }
  // lib.mapAttrs mkFeatureOptions features;

  imports = [
    ./servers
    ./keymaps.nix
    ./on-attach.nix
  ];

  config = {
    lsp.luaConfig.content = lib.mkMerge (lib.mapAttrsToList mkFeatureLua features);

    extraConfigLua = lib.mkIf (cfg.luaConfig.content != "") ''
      -- LSP {{{
      do
        ${cfg.luaConfig.content}
      end
      -- }}}
    '';
  };
}
