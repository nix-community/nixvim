{
  lib,
  callPackage,
  vimPlugins,
  neovimUtils,
  wrapNeovimUnstable,
  neovim-unwrapped,
  runCommand,
  pandoc,
  python3,
}:
let
  nvimConfig = neovimUtils.makeNeovimConfig {
    plugins = [
      {
        plugin = vimPlugins.nvim-lspconfig;
        config = null;
        optional = false;
      }
    ];
  };

  nvim = (wrapNeovimUnstable neovim-unwrapped nvimConfig).overrideAttrs {
    dontFixup = true;
  };

in
runCommand "lspconfig-servers"
  {
    lspconfig = "${vimPlugins.nvim-lspconfig}";
    nativeBuildInputs = [
      pandoc
      python3
    ];
    passthru.unsupported = callPackage ./unsupported.nix { };
  }
  ''
    export HOME=$(realpath .)
    # Generates `lsp.json`
    ${lib.getExe nvim} -u NONE -E -R --headless +'luafile ${./lspconfig-servers.lua}' +q
    LUA_FILTER=${./desc-filter.lua} python3 ${./clean-desc.py} "lsp.json" >$out
  ''
