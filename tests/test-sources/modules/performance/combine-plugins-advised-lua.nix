{ pkgs }:
let
  advising =
    name:
    pkgs.vimUtils.buildVimPlugin {
      pname = "advising_${name}";
      version = "1";
      src = pkgs.emptyDirectory;
      passthru.initLua = ''
        vim.g.nixvim_advice_${name} = "${name}"
      '';
    };

  dependent = pkgs.vimUtils.buildVimPlugin {
    pname = "advising_dependent";
    version = "1";
    src = pkgs.emptyDirectory;
    dependencies = [ (advising "dep") ];
  };

  # Advice is generated config, so packaging must not change it.
  invariant =
    label:
    {
      combine,
      standalone ? [ ],
    }:
    { config, ... }:
    {
      autoconfigure = true;
      performance.combinePlugins = {
        enable = combine;
        standalonePlugins = standalone;
      };

      extraPlugins = [
        (advising "first")
        (advising "middle")
        (advising "third")
        dependent
      ];

      # Avoid a cycle: an `extraPlugins` member cannot reference `build.initFile`.
      test.extraInputs = [
        (pkgs.runCommandLocal "advised-lua-invariants-${label}" { } ''
          init=${config.build.initFile}

          for name in first middle third; do
              grep -qF "vim.g.nixvim_advice_$name = \"$name\"" "$init" || {
                  echo "missing advice for $name" >&2
                  exit 1
              }
          done

          # Nixpkgs does not collect from dependencies, and neither do we.
          if grep -qF 'nixvim_advice_dep' "$init"; then
              echo "dependency advice should not be collected" >&2
              exit 1
          fi

          order=$(grep -oE 'nixvim_advice_(first|middle|third)' "$init" | head -3 | tr '\n' ' ')
          if [ "$order" != "nixvim_advice_first nixvim_advice_middle nixvim_advice_third " ]; then
              echo "advice order changed: $order" >&2
              exit 1
          fi

          touch $out
        '')
      ];
    };
in
{
  plain = invariant "plain" { combine = false; };
  combined = invariant "combined" { combine = true; };
  # Extract the middle plugin to verify standalone ordering.
  combined-with-standalone = invariant "standalone" {
    combine = true;
    standalone = [ "advising_middle" ];
  };
}
