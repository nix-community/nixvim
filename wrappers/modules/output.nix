{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options = {
    viAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink `vi` to `nvim` binary.
      '';
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink `vim` to `nvim` binary.
      '';
    };

    withNodeJs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Node provider.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      description = "Neovim to use for NixVim.";
    };

    wrapRc = mkOption {
      type = types.bool;
      description = "Should the config be included in the wrapper script.";
      default = false;
    };

    finalPackage = mkOption {
      type = types.package;
      description = "Wrapped Neovim.";
      readOnly = true;
    };

    nvimVersion = mkOption {
      type = types.package;
      description = ''
        The Neovim version included in `package`, as reported by `nvim --version`.

        Note: you can access the package version using `lib.getVersion`, the Neovim version may be different
        from the package version, especially for "nightly" builds of Neovim.

        For Neovim nightly, the package version may be something like "a44ac26",
        while this version will be something like "0.10.0-dev-a44ac26".
      '';
      readOnly = true;
    };

    initPath = mkOption {
      type = types.str;
      description = "The path to the `init.lua` file.";
      readOnly = true;
      visible = false;
    };

    initContent = mkOption {
      type = types.str;
      description = "The content of the `init.lua` file.";
      readOnly = true;
      visible = false;
    };

    printInitPackage = mkOption {
      type = types.package;
      description = "A tool to show the content of the generated `init.lua` file.";
      readOnly = true;
      visible = false;
    };
  };

  config = let
    defaultPlugin = {
      plugin = null;
      config = "";
      optional = false;
    };

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    config.extraPlugins;

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig ({
        inherit
          (config)
          extraPython3Packages
          viAlias
          vimAlias
          withNodeJs
          ;
        # inherit customRC;
        plugins = normalizedPlugins;
      }
      # Necessary to make sure the runtime path is set properly in NixOS 22.05,
      # or more generally before the commit:
      # cda1f8ae468 - neovim: pass packpath via the wrapper
      // optionalAttrs (functionArgs pkgs.neovimUtils.makeNeovimConfig ? configure) {
        configure.packages = {
          nixvim = {
            start = map (x: x.plugin) normalizedPlugins;
            opt = [];
          };
        };
      });

    customRC =
      ''
        vim.cmd([[
          ${neovimConfig.neovimRcContent}
        ]])
      ''
      + config.content;

    init = pkgs.writeText "init.lua" customRC;
    initPath = toString init;

    extraWrapperArgs = builtins.concatStringsSep " " (
      (optional (config.extraPackages != [])
        ''--prefix PATH : "${makeBinPath config.extraPackages}"'')
      ++ (optional config.wrapRc
        ''--add-flags -u --add-flags "${init}"'')
    );

    wrappedNeovim = pkgs.wrapNeovimUnstable config.package (neovimConfig
      // {
        wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
        wrapRc = false;
      });

    # Extract version from `nvim --version` by taking the first line and stripping the prefix.
    # `lib.getVersion config.package` may not be semver, e.g. when using neovim nightly.
    nvimVersion = let
      exe = getExe config.package;
      out = pkgs.runCommand "neovim-version" {} "${exe} --version > $out";
      lines = splitString "\n" (readFile out);
    in removePrefix "NVIM v" (head lines);
  in {
    inherit initPath nvimVersion;
    type = lib.mkForce "lua";
    finalPackage = wrappedNeovim;
    initContent = customRC;

    printInitPackage = pkgs.writeShellApplication {
      name = "nixvim-print-init";
      runtimeInputs = with pkgs; [stylua bat];
      text = ''
        stylua - <"${initPath}" | bat --language=lua
      '';
    };

    extraConfigLuaPre = lib.optionalString config.wrapRc ''
      -- Ignore the user lua configuration
      vim.opt.runtimepath:remove(vim.fn.stdpath('config'))              -- ~/.config/nvim
      vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. "/after")  -- ~/.config/nvim/after
      vim.opt.runtimepath:remove(vim.fn.stdpath('data') .. "/site")     -- ~/.local/share/nvim/site
    '';

    extraPlugins =
      if config.wrapRc
      then [config.filesPlugin]
      else [];
  };
}
