# WARNING: DO NOT EDIT
# This file is generated with packages.<system>.rust-analyzer-options, which is run automatically by CI
{
  "rust-analyzer.assist.emitMustUse" = {
    description = ''
      Whether to insert #[must_use] when generating `as_` methods
      for enum variants.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.assist.expressionFillDefault" = {
    description = ''
      Placeholder expression to use for missing expressions in assists.

      Values:
      - todo: Fill missing expressions with the `todo` macro
      - default: Fill missing expressions with reasonable defaults, `new` or `default` constructors.
    '';
    pluginDefault = "todo";
    type = {
      kind = "enum";
      values = [
        "todo"
        "default"
      ];
    };
  };
  "rust-analyzer.assist.termSearch.borrowcheck" = {
    description = ''
      Enable borrow checking for term search code assists. If set to false, also there will be more suggestions, but some of them may not borrow-check.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.assist.termSearch.fuel" = {
    description = ''
      Term search fuel in "units of work" for assists (Defaults to 1800).
    '';
    pluginDefault = 1800;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.cachePriming.enable" = {
    description = ''
      Warm up caches on project load.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.cachePriming.numThreads" = {
    description = ''
      How many worker threads to handle priming caches. The default `0` means to pick automatically.

      Values:
      - physical: Use the number of physical cores
      - logical: Use the number of logical cores
    '';
    pluginDefault = "physical";
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "number";
          maximum = 255;
          minimum = 0;
        }
        {
          kind = "enum";
          values = [
            "physical"
            "logical"
          ];
        }
      ];
    };
  };
  "rust-analyzer.cargo.allTargets" = {
    description = ''
      Pass `--all-targets` to cargo invocation.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.cargo.autoreload" = {
    description = ''
      Automatically refresh project info via `cargo metadata` on
      `Cargo.toml` or `.cargo/config.toml` changes.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.cargo.buildScripts.enable" = {
    description = ''
      Run build scripts (`build.rs`) for more precise code analysis.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.cargo.buildScripts.invocationStrategy" = {
    description = ''
      Specifies the invocation strategy to use when running the build scripts command.
      If `per_workspace` is set, the command will be executed for each Rust workspace with the
      workspace as the working directory.
      If `once` is set, the command will be executed once with the opened project as the
      working directory.
      This config only has an effect when `#rust-analyzer.cargo.buildScripts.overrideCommand#`
      is set.

      Values:
      - per_workspace: The command will be executed for each Rust workspace with the workspace as the working directory.
      - once: The command will be executed once with the opened project as the working directory.
    '';
    pluginDefault = "per_workspace";
    type = {
      kind = "enum";
      values = [
        "per_workspace"
        "once"
      ];
    };
  };
  "rust-analyzer.cargo.buildScripts.overrideCommand" = {
    description = ''
      Override the command rust-analyzer uses to run build scripts and
      build procedural macros. The command is required to output json
      and should therefore include `--message-format=json` or a similar
      option.

      If there are multiple linked projects/workspaces, this command is invoked for
      each of them, with the working directory being the workspace root
      (i.e., the folder containing the `Cargo.toml`). This can be overwritten
      by changing `#rust-analyzer.cargo.buildScripts.invocationStrategy#`.

      By default, a cargo invocation will be constructed for the configured
      targets and features, with the following base command line:

      ```bash
      cargo check --quiet --workspace --message-format=json --all-targets --keep-going
      ```
      .
    '';
    pluginDefault = null;
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.cargo.buildScripts.rebuildOnSave" = {
    description = ''
      Rerun proc-macros building/build-scripts running when proc-macro
      or build-script sources change and are saved.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.cargo.buildScripts.useRustcWrapper" = {
    description = ''
      Use `RUSTC_WRAPPER=rust-analyzer` when running build scripts to
      avoid checking unnecessary things.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.cargo.cfgs" = {
    description = ''
      List of cfg options to enable with the given values.
    '';
    pluginDefault = {
      debug_assertions = null;
      miri = null;
    };
    type = {
      kind = "object";
    };
  };
  "rust-analyzer.cargo.extraArgs" = {
    description = ''
      Extra arguments that are passed to every cargo invocation.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.cargo.extraEnv" = {
    description = ''
      Extra environment variables that will be set when running cargo, rustc
      or other commands within the workspace. Useful for setting RUSTFLAGS.
    '';
    pluginDefault = { };
    type = {
      kind = "object";
    };
  };
  "rust-analyzer.cargo.features" = {
    description = ''
      List of features to activate.

      Set this to `"all"` to pass `--all-features` to cargo.

      Values:
      - all: Pass `--all-features` to cargo
    '';
    pluginDefault = [ ];
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "enum";
          values = [
            "all"
          ];
        }
        {
          item = {
            kind = "string";
          };
          kind = "list";
        }
      ];
    };
  };
  "rust-analyzer.cargo.noDefaultFeatures" = {
    description = ''
      Whether to pass `--no-default-features` to cargo.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.cargo.sysroot" = {
    description = ''
      Relative path to the sysroot, or "discover" to try to automatically find it via
      "rustc --print sysroot".

      Unsetting this disables sysroot loading.

      This option does not take effect until rust-analyzer is restarted.
    '';
    pluginDefault = "discover";
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.cargo.sysrootQueryMetadata" = {
    description = ''
      How to query metadata for the sysroot crate. Using cargo metadata allows rust-analyzer
      to analyze third-party dependencies of the standard libraries.

      Values:
      - none: Do not query sysroot metadata, always use stitched sysroot.
      - cargo_metadata: Use `cargo metadata` to query sysroot metadata.
    '';
    pluginDefault = "cargo_metadata";
    type = {
      kind = "enum";
      values = [
        "none"
        "cargo_metadata"
      ];
    };
  };
  "rust-analyzer.cargo.sysrootSrc" = {
    description = ''
      Relative path to the sysroot library sources. If left unset, this will default to
      `{cargo.sysroot}/lib/rustlib/src/rust/library`.

      This option does not take effect until rust-analyzer is restarted.
    '';
    pluginDefault = null;
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.cargo.target" = {
    description = ''
      Compilation target override (target triple).
    '';
    pluginDefault = null;
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.cargo.targetDir" = {
    description = ''
      Optional path to a rust-analyzer specific target directory.
      This prevents rust-analyzer's `cargo check` and initial build-script and proc-macro
      building from locking the `Cargo.lock` at the expense of duplicating build artifacts.

      Set to `true` to use a subdirectory of the existing target directory or
      set to a path relative to the workspace to use that path.
    '';
    pluginDefault = null;
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "boolean";
        }
        {
          kind = "string";
        }
      ];
    };
  };
  "rust-analyzer.cfg.setTest" = {
    description = ''
      Set `cfg(test)` for local crates. Defaults to true.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.check.allTargets" = {
    description = ''
      Check all targets and tests (`--all-targets`). Defaults to
      `#rust-analyzer.cargo.allTargets#`.
    '';
    pluginDefault = null;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.check.command" = {
    description = ''
      Cargo command to use for `cargo check`.
    '';
    pluginDefault = "check";
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.check.extraArgs" = {
    description = ''
      Extra arguments for `cargo check`.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.check.extraEnv" = {
    description = ''
      Extra environment variables that will be set when running `cargo check`.
      Extends `#rust-analyzer.cargo.extraEnv#`.
    '';
    pluginDefault = { };
    type = {
      kind = "object";
    };
  };
  "rust-analyzer.check.features" = {
    description = ''
      List of features to activate. Defaults to
      `#rust-analyzer.cargo.features#`.

      Set to `"all"` to pass `--all-features` to Cargo.

      Values:
      - all: Pass `--all-features` to cargo
    '';
    pluginDefault = null;
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "enum";
          values = [
            "all"
          ];
        }
        {
          item = {
            kind = "string";
          };
          kind = "list";
        }
      ];
    };
  };
  "rust-analyzer.check.ignore" = {
    description = ''
      List of `cargo check` (or other command specified in `check.command`) diagnostics to ignore.

      For example for `cargo check`: `dead_code`, `unused_imports`, `unused_variables`,...
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.check.invocationStrategy" = {
    description = ''
      Specifies the invocation strategy to use when running the check command.
      If `per_workspace` is set, the command will be executed for each workspace.
      If `once` is set, the command will be executed once.
      This config only has an effect when `#rust-analyzer.check.overrideCommand#`
      is set.

      Values:
      - per_workspace: The command will be executed for each Rust workspace with the workspace as the working directory.
      - once: The command will be executed once with the opened project as the working directory.
    '';
    pluginDefault = "per_workspace";
    type = {
      kind = "enum";
      values = [
        "per_workspace"
        "once"
      ];
    };
  };
  "rust-analyzer.check.noDefaultFeatures" = {
    description = ''
      Whether to pass `--no-default-features` to Cargo. Defaults to
      `#rust-analyzer.cargo.noDefaultFeatures#`.
    '';
    pluginDefault = null;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.check.overrideCommand" = {
    description = ''
      Override the command rust-analyzer uses instead of `cargo check` for
      diagnostics on save. The command is required to output json and
      should therefore include `--message-format=json` or a similar option
      (if your client supports the `colorDiagnosticOutput` experimental
      capability, you can use `--message-format=json-diagnostic-rendered-ansi`).

      If you're changing this because you're using some tool wrapping
      Cargo, you might also want to change
      `#rust-analyzer.cargo.buildScripts.overrideCommand#`.

      If there are multiple linked projects/workspaces, this command is invoked for
      each of them, with the working directory being the workspace root
      (i.e., the folder containing the `Cargo.toml`). This can be overwritten
      by changing `#rust-analyzer.check.invocationStrategy#`.

      If `$saved_file` is part of the command, rust-analyzer will pass
      the absolute path of the saved file to the provided command. This is
      intended to be used with non-Cargo build systems.
      Note that `$saved_file` is experimental and may be removed in the future.

      An example command would be:

      ```bash
      cargo check --workspace --message-format=json --all-targets
      ```
      .
    '';
    pluginDefault = null;
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.check.targets" = {
    description = ''
      Check for specific targets. Defaults to `#rust-analyzer.cargo.target#` if empty.

      Can be a single target, e.g. `"x86_64-unknown-linux-gnu"` or a list of targets, e.g.
      `["aarch64-apple-darwin", "x86_64-apple-darwin"]`.

      Aliased as `"checkOnSave.targets"`.
    '';
    pluginDefault = null;
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "string";
        }
        {
          item = {
            kind = "string";
          };
          kind = "list";
        }
      ];
    };
  };
  "rust-analyzer.check.workspace" = {
    description = ''
      Whether `--workspace` should be passed to `cargo check`.
      If false, `-p <package>` will be passed instead if applicable. In case it is not, no
      check will be performed.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.checkOnSave" = {
    description = ''
      Run the check command for diagnostics on save.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.addSemicolonToUnit" = {
    description = ''
      Whether to automatically add a semicolon when completing unit-returning functions.

      In `match` arms it completes a comma instead.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.autoimport.enable" = {
    description = ''
      Toggles the additional completions that automatically add imports when completed.
      Note that your client must specify the `additionalTextEdits` LSP client capability to truly have this feature enabled.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.autoself.enable" = {
    description = ''
      Toggles the additional completions that automatically show method calls and field accesses
      with `self` prefixed to them when inside a method.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.callable.snippets" = {
    description = ''
      Whether to add parenthesis and argument snippets when completing function.

      Values:
      - fill_arguments: Add call parentheses and pre-fill arguments.
      - add_parentheses: Add call parentheses.
      - none: Do no snippet completions for callables.
    '';
    pluginDefault = "fill_arguments";
    type = {
      kind = "enum";
      values = [
        "fill_arguments"
        "add_parentheses"
        "none"
      ];
    };
  };
  "rust-analyzer.completion.fullFunctionSignatures.enable" = {
    description = ''
      Whether to show full function/method signatures in completion docs.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.hideDeprecated" = {
    description = ''
      Whether to omit deprecated items from autocompletion. By default they are marked as deprecated but not hidden.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.limit" = {
    description = ''
      Maximum number of completions to return. If `None`, the limit is infinite.
    '';
    pluginDefault = null;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.completion.postfix.enable" = {
    description = ''
      Whether to show postfix snippets like `dbg`, `if`, `not`, etc.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.privateEditable.enable" = {
    description = ''
      Enables completions of private items and fields that are defined in the current workspace even if they are not visible at the current position.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.snippets.custom" = {
    description = ''
      Custom completion snippets.
    '';
    pluginDefault = {
      "Arc::new" = {
        body = "Arc::new(\${receiver})";
        description = "Put the expression into an `Arc`";
        postfix = "arc";
        requires = "std::sync::Arc";
        scope = "expr";
      };
      "Box::pin" = {
        body = "Box::pin(\${receiver})";
        description = "Put the expression into a pinned `Box`";
        postfix = "pinbox";
        requires = "std::boxed::Box";
        scope = "expr";
      };
      Err = {
        body = "Err(\${receiver})";
        description = "Wrap the expression in a `Result::Err`";
        postfix = "err";
        scope = "expr";
      };
      Ok = {
        body = "Ok(\${receiver})";
        description = "Wrap the expression in a `Result::Ok`";
        postfix = "ok";
        scope = "expr";
      };
      "Rc::new" = {
        body = "Rc::new(\${receiver})";
        description = "Put the expression into an `Rc`";
        postfix = "rc";
        requires = "std::rc::Rc";
        scope = "expr";
      };
      Some = {
        body = "Some(\${receiver})";
        description = "Wrap the expression in an `Option::Some`";
        postfix = "some";
        scope = "expr";
      };
    };
    type = {
      kind = "object";
    };
  };
  "rust-analyzer.completion.termSearch.enable" = {
    description = ''
      Whether to enable term search based snippets like `Some(foo.bar().baz())`.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.completion.termSearch.fuel" = {
    description = ''
      Term search fuel in "units of work" for autocompletion (Defaults to 1000).
    '';
    pluginDefault = 1000;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.diagnostics.disabled" = {
    description = ''
      List of rust-analyzer diagnostics to disable.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.diagnostics.enable" = {
    description = ''
      Whether to show native rust-analyzer diagnostics.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.diagnostics.experimental.enable" = {
    description = ''
      Whether to show experimental rust-analyzer diagnostics that might
      have more false positives than usual.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.diagnostics.remapPrefix" = {
    description = ''
      Map of prefixes to be substituted when parsing diagnostic file paths.
      This should be the reverse mapping of what is passed to `rustc` as `--remap-path-prefix`.
    '';
    pluginDefault = { };
    type = {
      kind = "object";
    };
  };
  "rust-analyzer.diagnostics.styleLints.enable" = {
    description = ''
      Whether to run additional style lints.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.diagnostics.warningsAsHint" = {
    description = ''
      List of warnings that should be displayed with hint severity.

      The warnings will be indicated by faded text or three dots in code
      and will not show up in the `Problems Panel`.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.diagnostics.warningsAsInfo" = {
    description = ''
      List of warnings that should be displayed with info severity.

      The warnings will be indicated by a blue squiggly underline in code
      and a blue icon in the `Problems Panel`.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.files.excludeDirs" = {
    description = ''
      These directories will be ignored by rust-analyzer. They are
      relative to the workspace root, and globs are not supported. You may
      also need to add the folders to Code's `files.watcherExclude`.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.files.watcher" = {
    description = ''
      Controls file watching implementation.

      Values:
      - client: Use the client (editor) to watch files for changes
      - server: Use server-side file watching
    '';
    pluginDefault = "client";
    type = {
      kind = "enum";
      values = [
        "client"
        "server"
      ];
    };
  };
  "rust-analyzer.highlightRelated.breakPoints.enable" = {
    description = ''
      Enables highlighting of related references while the cursor is on `break`, `loop`, `while`, or `for` keywords.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.highlightRelated.closureCaptures.enable" = {
    description = ''
      Enables highlighting of all captures of a closure while the cursor is on the `|` or move keyword of a closure.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.highlightRelated.exitPoints.enable" = {
    description = ''
      Enables highlighting of all exit points while the cursor is on any `return`, `?`, `fn`, or return type arrow (`->`).
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.highlightRelated.references.enable" = {
    description = ''
      Enables highlighting of related references while the cursor is on any identifier.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.highlightRelated.yieldPoints.enable" = {
    description = ''
      Enables highlighting of all break points for a loop or block context while the cursor is on any `async` or `await` keywords.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.actions.debug.enable" = {
    description = ''
      Whether to show `Debug` action. Only applies when
      `#rust-analyzer.hover.actions.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.actions.enable" = {
    description = ''
      Whether to show HoverActions in Rust files.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.actions.gotoTypeDef.enable" = {
    description = ''
      Whether to show `Go to Type Definition` action. Only applies when
      `#rust-analyzer.hover.actions.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.actions.implementations.enable" = {
    description = ''
      Whether to show `Implementations` action. Only applies when
      `#rust-analyzer.hover.actions.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.actions.references.enable" = {
    description = ''
      Whether to show `References` action. Only applies when
      `#rust-analyzer.hover.actions.enable#` is set.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.actions.run.enable" = {
    description = ''
      Whether to show `Run` action. Only applies when
      `#rust-analyzer.hover.actions.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.documentation.enable" = {
    description = ''
      Whether to show documentation on hover.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.documentation.keywords.enable" = {
    description = ''
      Whether to show keyword hover popups. Only applies when
      `#rust-analyzer.hover.documentation.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.links.enable" = {
    description = ''
      Use markdown syntax for links on hover.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.memoryLayout.alignment" = {
    description = ''
      How to render the align information in a memory layout hover.

      Values:
      - both: Render as 12 (0xC)
      - decimal: Render as 12
      - hexadecimal: Render as 0xC
    '';
    pluginDefault = "hexadecimal";
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "enum";
          values = [
            "both"
            "decimal"
            "hexadecimal"
          ];
        }
      ];
    };
  };
  "rust-analyzer.hover.memoryLayout.enable" = {
    description = ''
      Whether to show memory layout data on hover.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.memoryLayout.niches" = {
    description = ''
      How to render the niche information in a memory layout hover.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.hover.memoryLayout.offset" = {
    description = ''
      How to render the offset information in a memory layout hover.

      Values:
      - both: Render as 12 (0xC)
      - decimal: Render as 12
      - hexadecimal: Render as 0xC
    '';
    pluginDefault = "hexadecimal";
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "enum";
          values = [
            "both"
            "decimal"
            "hexadecimal"
          ];
        }
      ];
    };
  };
  "rust-analyzer.hover.memoryLayout.size" = {
    description = ''
      How to render the size information in a memory layout hover.

      Values:
      - both: Render as 12 (0xC)
      - decimal: Render as 12
      - hexadecimal: Render as 0xC
    '';
    pluginDefault = "both";
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "enum";
          values = [
            "both"
            "decimal"
            "hexadecimal"
          ];
        }
      ];
    };
  };
  "rust-analyzer.hover.show.enumVariants" = {
    description = ''
      How many variants of an enum to display when hovering on. Show none if empty.
    '';
    pluginDefault = 5;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.hover.show.fields" = {
    description = ''
      How many fields of a struct, variant or union to display when hovering on. Show none if empty.
    '';
    pluginDefault = 5;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.hover.show.traitAssocItems" = {
    description = ''
      How many associated items of a trait to display when hovering a trait.
    '';
    pluginDefault = null;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.imports.granularity.enforce" = {
    description = ''
      Whether to enforce the import granularity setting for all files. If set to false rust-analyzer will try to keep import styles consistent per file.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.imports.granularity.group" = {
    description = ''
      How imports should be grouped into use statements.

      Values:
      - preserve: Do not change the granularity of any imports and preserve the original structure written by the developer.
      - crate: Merge imports from the same crate into a single use statement. Conversely, imports from different crates are split into separate statements.
      - module: Merge imports from the same module into a single use statement. Conversely, imports from different modules are split into separate statements.
      - item: Flatten imports so that each has its own use statement.
      - one: Merge all imports into a single use statement as long as they have the same visibility and attributes.
    '';
    pluginDefault = "crate";
    type = {
      kind = "enum";
      values = [
        "preserve"
        "crate"
        "module"
        "item"
        "one"
      ];
    };
  };
  "rust-analyzer.imports.group.enable" = {
    description = ''
      Group inserted imports by the [following order](https://rust-analyzer.github.io/manual.html#auto-import). Groups are separated by newlines.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.imports.merge.glob" = {
    description = ''
      Whether to allow import insertion to merge new imports into single path glob imports like `use std::fmt::*;`.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.imports.preferNoStd" = {
    description = ''
      Prefer to unconditionally use imports of the core and alloc crate, over the std crate.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.imports.preferPrelude" = {
    description = ''
      Whether to prefer import paths containing a `prelude` module.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.imports.prefix" = {
    description = ''
      The path structure for newly inserted paths to use.

      Values:
      - plain: Insert import paths relative to the current module, using up to one `super` prefix if the parent module contains the requested item.
      - self: Insert import paths relative to the current module, using up to one `super` prefix if the parent module contains the requested item. Prefixes `self` in front of the path if it starts with a module.
      - crate: Force import paths to be absolute by always starting them with `crate` or the extern crate name they come from.
    '';
    pluginDefault = "plain";
    type = {
      kind = "enum";
      values = [
        "plain"
        "self"
        "crate"
      ];
    };
  };
  "rust-analyzer.imports.prefixExternPrelude" = {
    description = ''
      Whether to prefix external (including std, core) crate imports with `::`. e.g. "use ::std::io::Read;".
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.bindingModeHints.enable" = {
    description = ''
      Whether to show inlay type hints for binding modes.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.chainingHints.enable" = {
    description = ''
      Whether to show inlay type hints for method chains.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.closingBraceHints.enable" = {
    description = ''
      Whether to show inlay hints after a closing `}` to indicate what item it belongs to.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.closingBraceHints.minLines" = {
    description = ''
      Minimum number of lines required before the `}` until the hint is shown (set to 0 or 1
      to always show them).
    '';
    pluginDefault = 25;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.inlayHints.closureCaptureHints.enable" = {
    description = ''
      Whether to show inlay hints for closure captures.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = {
    description = ''
      Whether to show inlay type hints for return types of closures.

      Values:
      - always: Always show type hints for return types of closures.
      - never: Never show type hints for return types of closures.
      - with_block: Only show type hints for return types of closures with blocks.
    '';
    pluginDefault = "never";
    type = {
      kind = "enum";
      values = [
        "always"
        "never"
        "with_block"
      ];
    };
  };
  "rust-analyzer.inlayHints.closureStyle" = {
    description = ''
      Closure notation in type and chaining inlay hints.

      Values:
      - impl_fn: `impl_fn`: `impl FnMut(i32, u64) -> i8`
      - rust_analyzer: `rust_analyzer`: `|i32, u64| -> i8`
      - with_id: `with_id`: `{closure#14352}`, where that id is the unique number of the closure in r-a internals
      - hide: `hide`: Shows `...` for every closure type
    '';
    pluginDefault = "impl_fn";
    type = {
      kind = "enum";
      values = [
        "impl_fn"
        "rust_analyzer"
        "with_id"
        "hide"
      ];
    };
  };
  "rust-analyzer.inlayHints.discriminantHints.enable" = {
    description = ''
      Whether to show enum variant discriminant hints.

      Values:
      - always: Always show all discriminant hints.
      - never: Never show discriminant hints.
      - fieldless: Only show discriminant hints on fieldless enum variants.
    '';
    pluginDefault = "never";
    type = {
      kind = "enum";
      values = [
        "always"
        "never"
        "fieldless"
      ];
    };
  };
  "rust-analyzer.inlayHints.expressionAdjustmentHints.enable" = {
    description = ''
      Whether to show inlay hints for type adjustments.

      Values:
      - always: Always show all adjustment hints.
      - never: Never show adjustment hints.
      - reborrow: Only show auto borrow and dereference adjustment hints.
    '';
    pluginDefault = "never";
    type = {
      kind = "enum";
      values = [
        "always"
        "never"
        "reborrow"
      ];
    };
  };
  "rust-analyzer.inlayHints.expressionAdjustmentHints.hideOutsideUnsafe" = {
    description = ''
      Whether to hide inlay hints for type adjustments outside of `unsafe` blocks.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.expressionAdjustmentHints.mode" = {
    description = ''
      Whether to show inlay hints as postfix ops (`.*` instead of `*`, etc).

      Values:
      - prefix: Always show adjustment hints as prefix (`*expr`).
      - postfix: Always show adjustment hints as postfix (`expr.*`).
      - prefer_prefix: Show prefix or postfix depending on which uses less parenthesis, preferring prefix.
      - prefer_postfix: Show prefix or postfix depending on which uses less parenthesis, preferring postfix.
    '';
    pluginDefault = "prefix";
    type = {
      kind = "enum";
      values = [
        "prefix"
        "postfix"
        "prefer_prefix"
        "prefer_postfix"
      ];
    };
  };
  "rust-analyzer.inlayHints.genericParameterHints.const.enable" = {
    description = ''
      Whether to show const generic parameter name inlay hints.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.genericParameterHints.lifetime.enable" = {
    description = ''
      Whether to show generic lifetime parameter name inlay hints.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.genericParameterHints.type.enable" = {
    description = ''
      Whether to show generic type parameter name inlay hints.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.implicitDrops.enable" = {
    description = ''
      Whether to show implicit drop hints.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = {
    description = ''
      Whether to show inlay type hints for elided lifetimes in function signatures.

      Values:
      - always: Always show lifetime elision hints.
      - never: Never show lifetime elision hints.
      - skip_trivial: Only show lifetime elision hints if a return type is involved.
    '';
    pluginDefault = "never";
    type = {
      kind = "enum";
      values = [
        "always"
        "never"
        "skip_trivial"
      ];
    };
  };
  "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = {
    description = ''
      Whether to prefer using parameter names as the name for elided lifetime hints if possible.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.maxLength" = {
    description = ''
      Maximum length for inlay hints. Set to null to have an unlimited length.
    '';
    pluginDefault = 25;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.inlayHints.parameterHints.enable" = {
    description = ''
      Whether to show function parameter name inlay hints at the call
      site.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.rangeExclusiveHints.enable" = {
    description = ''
      Whether to show exclusive range inlay hints.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.reborrowHints.enable" = {
    description = ''
      Whether to show inlay hints for compiler inserted reborrows.
      This setting is deprecated in favor of #rust-analyzer.inlayHints.expressionAdjustmentHints.enable#.

      Values:
      - always: Always show reborrow hints.
      - never: Never show reborrow hints.
      - mutable: Only show mutable reborrow hints.
    '';
    pluginDefault = "never";
    type = {
      kind = "enum";
      values = [
        "always"
        "never"
        "mutable"
      ];
    };
  };
  "rust-analyzer.inlayHints.renderColons" = {
    description = ''
      Whether to render leading colons for type hints, and trailing colons for parameter hints.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.typeHints.enable" = {
    description = ''
      Whether to show inlay type hints for variables.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.typeHints.hideClosureInitialization" = {
    description = ''
      Whether to hide inlay type hints for `let` statements that initialize to a closure.
      Only applies to closures with blocks, same as `#rust-analyzer.inlayHints.closureReturnTypeHints.enable#`.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.inlayHints.typeHints.hideNamedConstructor" = {
    description = ''
      Whether to hide inlay type hints for constructors.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.interpret.tests" = {
    description = ''
      Enables the experimental support for interpreting tests.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.joinLines.joinAssignments" = {
    description = ''
      Join lines merges consecutive declaration and initialization of an assignment.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.joinLines.joinElseIf" = {
    description = ''
      Join lines inserts else between consecutive ifs.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.joinLines.removeTrailingComma" = {
    description = ''
      Join lines removes trailing commas.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.joinLines.unwrapTrivialBlock" = {
    description = ''
      Join lines unwraps trivial blocks.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.debug.enable" = {
    description = ''
      Whether to show `Debug` lens. Only applies when
      `#rust-analyzer.lens.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.enable" = {
    description = ''
      Whether to show CodeLens in Rust files.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.implementations.enable" = {
    description = ''
      Whether to show `Implementations` lens. Only applies when
      `#rust-analyzer.lens.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.location" = {
    description = ''
      Where to render annotations.

      Values:
      - above_name: Render annotations above the name of the item.
      - above_whole_item: Render annotations above the whole item, including documentation comments and attributes.
    '';
    pluginDefault = "above_name";
    type = {
      kind = "enum";
      values = [
        "above_name"
        "above_whole_item"
      ];
    };
  };
  "rust-analyzer.lens.references.adt.enable" = {
    description = ''
      Whether to show `References` lens for Struct, Enum, and Union.
      Only applies when `#rust-analyzer.lens.enable#` is set.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.references.enumVariant.enable" = {
    description = ''
      Whether to show `References` lens for Enum Variants.
      Only applies when `#rust-analyzer.lens.enable#` is set.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.references.method.enable" = {
    description = ''
      Whether to show `Method References` lens. Only applies when
      `#rust-analyzer.lens.enable#` is set.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.references.trait.enable" = {
    description = ''
      Whether to show `References` lens for Trait.
      Only applies when `#rust-analyzer.lens.enable#` is set.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.lens.run.enable" = {
    description = ''
      Whether to show `Run` lens. Only applies when
      `#rust-analyzer.lens.enable#` is set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.linkedProjects" = {
    description = ''
      Disable project auto-discovery in favor of explicitly specified set
      of projects.

      Elements must be paths pointing to `Cargo.toml`,
      `rust-project.json`, `.rs` files (which will be treated as standalone files) or JSON
      objects in `rust-project.json` format.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "oneOf";
        subTypes = [
          {
            kind = "string";
          }
          {
            kind = "object";
          }
        ];
      };
      kind = "list";
    };
  };
  "rust-analyzer.lru.capacity" = {
    description = ''
      Number of syntax trees rust-analyzer keeps in memory. Defaults to 128.
    '';
    pluginDefault = null;
    type = {
      kind = "integer";
      maximum = 65535;
      minimum = 0;
    };
  };
  "rust-analyzer.lru.query.capacities" = {
    description = ''
      Sets the LRU capacity of the specified queries.
    '';
    pluginDefault = { };
    type = {
      kind = "object";
    };
  };
  "rust-analyzer.notifications.cargoTomlNotFound" = {
    description = ''
      Whether to show `can't find Cargo.toml` error message.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.numThreads" = {
    description = ''
      How many worker threads in the main loop. The default `null` means to pick automatically.

      Values:
      - physical: Use the number of physical cores
      - logical: Use the number of logical cores
    '';
    pluginDefault = null;
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "number";
          maximum = 255;
          minimum = 0;
        }
        {
          kind = "enum";
          values = [
            "physical"
            "logical"
          ];
        }
      ];
    };
  };
  "rust-analyzer.procMacro.attributes.enable" = {
    description = ''
      Expand attribute macros. Requires `#rust-analyzer.procMacro.enable#` to be set.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.procMacro.enable" = {
    description = ''
      Enable support for procedural macros, implies `#rust-analyzer.cargo.buildScripts.enable#`.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.procMacro.ignored" = {
    description = ''
      These proc-macros will be ignored when trying to expand them.

      This config takes a map of crate names with the exported proc-macro names to ignore as values.
    '';
    pluginDefault = { };
    type = {
      kind = "object";
    };
  };
  "rust-analyzer.procMacro.server" = {
    description = ''
      Internal config, path to proc-macro server executable.
    '';
    pluginDefault = null;
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.references.excludeImports" = {
    description = ''
      Exclude imports from find-all-references.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.references.excludeTests" = {
    description = ''
      Exclude tests from find-all-references and call-hierarchy.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.runnables.command" = {
    description = ''
      Command to be executed instead of 'cargo' for runnables.
    '';
    pluginDefault = null;
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.runnables.extraArgs" = {
    description = ''
      Additional arguments to be passed to cargo for runnables such as
      tests or binaries. For example, it may be `--release`.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.runnables.extraTestBinaryArgs" = {
    description = ''
      Additional arguments to be passed through Cargo to launched tests, benchmarks, or
      doc-tests.

      Unless the launched target uses a
      [custom test harness](https://doc.rust-lang.org/cargo/reference/cargo-targets.html#the-harness-field),
      they will end up being interpreted as options to
      [`rustc`’s built-in test harness (“libtest”)](https://doc.rust-lang.org/rustc/tests/index.html#cli-arguments).
    '';
    pluginDefault = [
      "--show-output"
    ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.rustc.source" = {
    description = ''
      Path to the Cargo.toml of the rust compiler workspace, for usage in rustc_private
      projects, or "discover" to try to automatically find it if the `rustc-dev` component
      is installed.

      Any project which uses rust-analyzer with the rustcPrivate
      crates must set `[package.metadata.rust-analyzer] rustc_private=true` to use it.

      This option does not take effect until rust-analyzer is restarted.
    '';
    pluginDefault = null;
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.rustfmt.extraArgs" = {
    description = ''
      Additional arguments to `rustfmt`.
    '';
    pluginDefault = [ ];
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.rustfmt.overrideCommand" = {
    description = ''
      Advanced option, fully override the command rust-analyzer uses for
      formatting. This should be the equivalent of `rustfmt` here, and
      not that of `cargo fmt`. The file contents will be passed on the
      standard input and the formatted result will be read from the
      standard output.
    '';
    pluginDefault = null;
    type = {
      item = {
        kind = "string";
      };
      kind = "list";
    };
  };
  "rust-analyzer.rustfmt.rangeFormatting.enable" = {
    description = ''
      Enables the use of rustfmt's unstable range formatting command for the
      `textDocument/rangeFormatting` request. The rustfmt option is unstable and only
      available on a nightly build.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.doc.comment.inject.enable" = {
    description = ''
      Inject additional highlighting into doc comments.

      When enabled, rust-analyzer will highlight rust source in doc comments as well as intra
      doc links.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.nonStandardTokens" = {
    description = ''
      Whether the server is allowed to emit non-standard tokens and modifiers.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.operator.enable" = {
    description = ''
      Use semantic tokens for operators.

      When disabled, rust-analyzer will emit semantic tokens only for operator tokens when
      they are tagged with modifiers.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.operator.specialization.enable" = {
    description = ''
      Use specialized semantic tokens for operators.

      When enabled, rust-analyzer will emit special token types for operator tokens instead
      of the generic `operator` token type.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.punctuation.enable" = {
    description = ''
      Use semantic tokens for punctuation.

      When disabled, rust-analyzer will emit semantic tokens only for punctuation tokens when
      they are tagged with modifiers or have a special role.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.punctuation.separate.macro.bang" = {
    description = ''
      When enabled, rust-analyzer will emit a punctuation semantic token for the `!` of macro
      calls.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.punctuation.specialization.enable" = {
    description = ''
      Use specialized semantic tokens for punctuation.

      When enabled, rust-analyzer will emit special token types for punctuation tokens instead
      of the generic `punctuation` token type.
    '';
    pluginDefault = false;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.semanticHighlighting.strings.enable" = {
    description = ''
      Use semantic tokens for strings.

      In some editors (e.g. vscode) semantic tokens override other highlighting grammars.
      By disabling semantic tokens for strings, other grammars can be used to highlight
      their contents.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.signatureInfo.detail" = {
    description = ''
      Show full signature of the callable. Only shows parameters if disabled.

      Values:
      - full: Show the entire signature.
      - parameters: Show only the parameters.
    '';
    pluginDefault = "full";
    type = {
      kind = "enum";
      values = [
        "full"
        "parameters"
      ];
    };
  };
  "rust-analyzer.signatureInfo.documentation.enable" = {
    description = ''
      Show documentation.
    '';
    pluginDefault = true;
    type = {
      kind = "boolean";
    };
  };
  "rust-analyzer.typing.excludeChars" = {
    description = ''
      Specify the characters to exclude from triggering typing assists. The default trigger characters are `.`, `=`, `<`, `>`, `{`, and `(`.
    '';
    pluginDefault = "|<";
    type = {
      kind = "string";
    };
  };
  "rust-analyzer.workspace.discoverConfig" = {
    description = ''
      Enables automatic discovery of projects using
      \[`DiscoverWorkspaceConfig::command`\].

      \[`DiscoverWorkspaceConfig`\] also requires setting `progress_label` and
      `files_to_watch`. `progress_label` is used for the title in progress
      indicators, whereas `files_to_watch` is used to determine which build
      system-specific files should be watched in order to reload
      rust-analyzer.

      Below is an example of a valid configuration:

      ``` json
      "rust-analyzer.workspace.discoverConfig": {
              "command": [
                      "rust-project",
                      "develop-json"
              ],
              "progressLabel": "rust-analyzer",
              "filesToWatch": [
                      "BUCK"
              ]
      }
      ```

      **On `DiscoverWorkspaceConfig::command`**

      **Warning**: This format is provisional and subject to change.

      \[`DiscoverWorkspaceConfig::command`\] *must* return a JSON object
      corresponding to `DiscoverProjectData::Finished`:

      ``` norun
      #[derive(Debug, Clone, Deserialize, Serialize)]
      #[serde(tag = "kind")]
      #[serde(rename_all = "snake_case")]
      enum DiscoverProjectData {
              Finished { buildfile: Utf8PathBuf, project: ProjectJsonData },
              Error { error: String, source: Option<String> },
              Progress { message: String },
      }
      ```

      As JSON, `DiscoverProjectData::Finished` is:

      ``` json
      {
              // the internally-tagged representation of the enum.
              "kind": "finished",
              // the file used by a non-Cargo build system to define
              // a package or target.
              "buildfile": "rust-analyzer/BUILD",
              // the contents of a rust-project.json, elided for brevity
              "project": {
                      "sysroot": "foo",
                      "crates": []
              }
      }
      ```

      It is encouraged, but not required, to use the other variants on
      `DiscoverProjectData` to provide a more polished end-user experience.

      `DiscoverWorkspaceConfig::command` may *optionally* include an `{arg}`,
      which will be substituted with the JSON-serialized form of the following
      enum:

      ``` norun
      #[derive(PartialEq, Clone, Debug, Serialize)]
      #[serde(rename_all = "camelCase")]
      pub enum DiscoverArgument {
           Path(AbsPathBuf),
           Buildfile(AbsPathBuf),
      }
      ```

      The JSON representation of `DiscoverArgument::Path` is:

      ``` json
      {
              "path": "src/main.rs"
      }
      ```

      Similarly, the JSON representation of `DiscoverArgument::Buildfile` is:

          {
                  "buildfile": "BUILD"
          }

      `DiscoverArgument::Path` is used to find and generate a
      `rust-project.json`, and therefore, a workspace, whereas
      `DiscoverArgument::buildfile` is used to to update an existing
      workspace. As a reference for implementors, buck2's `rust-project` will
      likely be useful:
      https://github.com/facebook/buck2/tree/main/integrations/rust-project.

    '';
    pluginDefault = null;
    type = {
      kind = "oneOf";
      subTypes = [
        {
          kind = "submodule";
          options = {
            command = {
              item = {
                kind = "string";
              };
              kind = "list";
            };
            filesToWatch = {
              item = {
                kind = "string";
              };
              kind = "list";
            };
            progressLabel = {
              kind = "string";
            };
          };
        }
      ];
    };
  };
  "rust-analyzer.workspace.symbol.search.kind" = {
    description = ''
      Workspace symbol search kind.

      Values:
      - only_types: Search for types only.
      - all_symbols: Search for all symbols kinds.
    '';
    pluginDefault = "only_types";
    type = {
      kind = "enum";
      values = [
        "only_types"
        "all_symbols"
      ];
    };
  };
  "rust-analyzer.workspace.symbol.search.limit" = {
    description = ''
      Limits the number of items returned from a workspace symbol search (Defaults to 128).
      Some clients like vs-code issue new searches on result filtering and don't require all results to be returned in the initial search.
      Other clients requires all results upfront and might require a higher limit.
    '';
    pluginDefault = 128;
    type = {
      kind = "integer";
      maximum = null;
      minimum = 0;
    };
  };
  "rust-analyzer.workspace.symbol.search.scope" = {
    description = ''
      Workspace symbol search scope.

      Values:
      - workspace: Search in current workspace only.
      - workspace_and_dependencies: Search in current workspace and dependencies.
    '';
    pluginDefault = "workspace";
    type = {
      kind = "enum";
      values = [
        "workspace"
        "workspace_and_dependencies"
      ];
    };
  };
}
