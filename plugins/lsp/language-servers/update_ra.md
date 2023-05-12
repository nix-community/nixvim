# Updating rust-analyzer options

Because there a large number of rust-analyzer options it's difficult to handle them by hand.

The options can be fetched from the [rust-analyzer package.json](https://github.com/rust-lang/rust-analyzer/blob/master/editors/code/package.json).

There is a derivation on the top-level flake that allows to build it easily, you just have to run:

```bash
nix build .#rustAnalyzerOptions
```

You can then copy the `result/share/rust-analyzer-config.nix` to the correct location.
