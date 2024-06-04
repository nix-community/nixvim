# All available settings are documented here:
# https://luals.github.io/wiki/settings/
{
  lib,
  helpers,
}:
with lib; {
  addonManager = {
    enable = helpers.defaultNullOpts.mkBool true ''
      Set the on/off state of the addon manager.
      Disabling the addon manager prevents it from registering its command.
    '';
  };

  completion = {
    autoRequire = helpers.defaultNullOpts.mkBool true ''
      When the input looks like a file name, automatically require the file.
    '';

    callSnippet =
      helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "Disable"
        "Both"
        "Replace"
      ]
      ''
        - `"Disable"` - Only show function name
        - `"Both"` - Show function name and snippet
        - `"Replace"` - Only show the call snippet

        Whether to show call snippets or not.
        When disabled, only the function name will be completed.
        When enabled, a "more complete" snippet will be offered.
      '';

    displayContext = helpers.defaultNullOpts.mkUnsignedInt 0 ''
      When a snippet is being suggested, this setting will set the amount of lines around the
      snippet to preview to help you better understand its usage.

      Setting to `0` will disable this feature.
    '';

    enable = helpers.defaultNullOpts.mkBool true ''
      Enable/disable completion.
      Completion works like any autocompletion you already know of.
      It helps you type less and get more done.
    '';

    keywordSnippet =
      helpers.defaultNullOpts.mkEnum
      [
        "Disable"
        "Both"
        "Replace"
      ]
      "Replace"
      ''
        - `"Disable"` - Only completes the keyword
        - `"Both"` - Offers a completion for the keyword and snippet
        - `"Replace"` - Only shows a snippet

        Whether to show a snippet for key words like `if`, `while`, etc. When disabled, only the keyword will be completed. When enabled, a "more complete" snippet will be offered.
      '';

    postfix = helpers.defaultNullOpts.mkStr "@" ''
      The character to use for triggering a "postfix suggestion".
      A postfix allows you to write some code and then trigger a snippet after (post) to "fix" the
      code you have written.
      This can save some time as instead of typing `table.insert(myTable, )`, you can just type
      `myTable@`.
    '';

    requireSeparator = helpers.defaultNullOpts.mkStr "." ''
      The separator to use when `require`-ing a file.
    '';

    showParams = helpers.defaultNullOpts.mkBool true ''
      Display a function's parameters in the list of completions.
      When a function has multiple definitions, they will be displayed separately.
    '';

    showWord =
      helpers.defaultNullOpts.mkEnum
      [
        "Enable"
        "Fallback"
        "Disable"
      ]
      "Fallback"
      ''
        - `"Enable"` - Always show contextual words in completion suggestions
        - `"Fallback"` - Only show contextual words when smart suggestions based on semantics cannot be provided
        - `"Disable"` - Never show contextual words

        Show "contextual words" that have to do with Lua but are not suggested based on their
        usefulness in the current semantic context.
      '';

    workspaceWord = helpers.defaultNullOpts.mkBool true ''
      Whether words from other files in the workspace should be suggested as "contextual words".
      This can be useful for completing similar strings.
      `completion.showWord` must not be disabled for this to have an effect.
    '';
  };

  diagnostics = {
    disable = helpers.defaultNullOpts.mkListOf types.str [] ''
      Disable certain diagnostics globally.
      For example, if you want all warnings for `lowercase-global` to be disabled, the value for
      `diagnostics.disable` would be `["lowercase-global"]`.
    '';

    disableScheme = helpers.defaultNullOpts.mkListOf types.str ["git"] ''
      Disable diagnosis of Lua files that have the set schemes.
    '';

    enable = helpers.defaultNullOpts.mkBool true ''
      Whether all diagnostics should be enabled or not.
    '';

    globals = helpers.defaultNullOpts.mkListOf types.str [] ''
      An array of variable names that will be declared as global.
    '';

    groupFileStatus =
      helpers.defaultNullOpts.mkAttrsOf
      (types.enum [
        "Any"
        "Opened"
        "None"
        "Fallback"
      ])
      {
        ambiguity = "Fallback";
        await = "Fallback";
        codestyle = "Fallback";
        duplicate = "Fallback";
        global = "Fallback";
        luadoc = "Fallback";
        redefined = "Fallback";
        strict = "Fallback";
        strong = "Fallback";
        type-check = "Fallback";
        unbalanced = "Fallback";
        unused = "Fallback";
      }
      ''
        Set the file status required for each diagnostic group.
        This setting is an `Object` of `key`-`value` pairs where the `key` is the name of the
        diagnostic group and the `value` is the state that a file must be in in order for the
        diagnostic group to apply.

        Valid state values:
        - `"Any"` - Any loaded file (workspace, library, etc.) will use this diagnostic group
        - `"Opened"` - Only opened files will use this diagnostic group
        - `"None"` - This diagnostic group will be disabled
        - `"Fallback"` - The diagnostics in this group are controlled individually by [`diagnostics.neededFileStatus`](https://github.com/LuaLS/lua-language-server/wiki/Settings#diagnosticsneededfilestatus)
      '';

    groupSeverity =
      helpers.defaultNullOpts.mkAttrsOf
      (types.enum [
        "Error"
        "Warning"
        "Information"
        "Hint"
        "Fallback"
      ])
      {
        ambiguity = "Fallback";
        await = "Fallback";
        codestyle = "Fallback";
        duplicate = "Fallback";
        global = "Fallback";
        luadoc = "Fallback";
        redefined = "Fallback";
        strict = "Fallback";
        strong = "Fallback";
        type-check = "Fallback";
        unbalanced = "Fallback";
        unused = "Fallback";
      }
      ''
        Maps diagnostic groups to severity levels.

        Valid severity values:
        - `"Error"` - An error will be raised
        - `"Warning"` - A warning will be raised
        - `"Information"` - An information or note will be raised
        - `"Hint"` - The affected code will be "hinted" at
        - `"Fallback"` - The diagnostics in this group will be controlled individually by [`diagnostics.severity`](https://github.com/LuaLS/lua-language-server/wiki/Settings#diagnosticsseverity)
      '';

    ignoredFiles =
      helpers.defaultNullOpts.mkEnum
      [
        "Enable"
        "Opened"
        "Disable"
      ]
      "Opened"
      ''
        Set how files that have been ignored should be diagnosed.

        - `"Enable"` - Always diagnose ignored files... kind of defeats the purpose of ignoring them.
        - `"Opened"` - Only diagnose ignored files when they are open
        - `"Disable"` - Ignored files are fully ignored
      '';

    libraryFiles =
      helpers.defaultNullOpts.mkEnum
      [
        "Enable"
        "Opened"
        "Disable"
      ]
      "Opened"
      ''
        Set how files loaded with [`workspace.library`](https://github.com/LuaLS/lua-language-server/wiki/Settings#workspacelibrary) are diagnosed.

        - `"Enable"` - Always diagnose library files
        - `"Opened"` - Only diagnose library files when they are open
        - `"Disable"` - Never diagnose library files
      '';

    neededFileStatus =
      helpers.defaultNullOpts.mkAttrsOf
      (types.enum [
        "Any"
        "Opened"
        "None"
        "Any!"
        "Opened!"
        "None!"
      ])
      {
        ambiguity-1 = "Any";
        assign-type-mismatch = "Opened";
        await-in-sync = "None";
        cast-local-type = "Opened";
        cast-type-mismatch = "Any";
        circle-doc-class = "Any";
        close-non-object = "Any";
        code-after-break = "Opened";
        codestyle-check = "None";
        count-down-loop = "Any";
        deprecated = "Any";
        different-requires = "Any";
        discard-returns = "Any";
        doc-field-no-class = "Any";
        duplicate-doc-alias = "Any";
        duplicate-doc-field = "Any";
        duplicate-doc-param = "Any";
        duplicate-index = "Any";
        duplicate-set-field = "Any";
        empty-block = "Opened";
        global-in-nil-env = "Any";
        lowercase-global = "Any";
        missing-parameter = "Any";
        missing-return = "Any";
        missing-return-value = "Any";
        need-check-nil = "Opened";
        newfield-call = "Any";
        newline-call = "Any";
        no-unknown = "None";
        not-yieldable = "None";
        param-type-mismatch = "Opened";
        redefined-local = "Opened";
        redundant-parameter = "Any";
        redundant-return = "Opened";
        redundant-return-value = "Any";
        redundant-value = "Any";
        return-type-mismatch = "Opened";
        spell-check = "None";
        trailing-space = "Opened";
        unbalanced-assignments = "Any";
        undefined-doc-class = "Any";
        undefined-doc-name = "Any";
        undefined-doc-param = "Any";
        undefined-env-child = "Any";
        undefined-field = "Opened";
        undefined-global = "Any";
        unknown-cast-variable = "Any";
        unknown-diag-code = "Any";
        unknown-operator = "Any";
        unreachable-code = "Opened";
        unused-function = "Opened";
        unused-label = "Opened";
        unused-local = "Opened";
        unused-vararg = "Opened";
      }
      ''
        Maps diagnostic groups to file states.

        Valid states:
        - `"Any"` - Any loaded file (workspace, library, etc.) will use this diagnostic group
        - `"Opened"` - Only opened files will use this diagnostic group
        - `"None"` - This diagnostic group will be disabled
        - `"Any!"` - Like `"Any"` but overrides `diagnostics.groupFileStatus`
        - `"Opened!"` - Like `"Opened"` but overrides `diagnostics.groupFileStatus`
        - `"None!"` - Like `"None"` but overrides `diagnostics.groupFileStatus`
      '';

    severity =
      helpers.defaultNullOpts.mkAttrsOf
      (types.enum [
        "Error"
        "Warning"
        "Information"
        "Hint"
        "Error!"
        "Warning!"
        "Information!"
        "Hint!"
      ])
      {
        ambiguity-1 = "Warning";
        assign-type-mismatch = "Warning";
        await-in-sync = "Warning";
        cast-local-type = "Warning";
        cast-type-mismatch = "Warning";
        circle-doc-class = "Warning";
        close-non-object = "Warning";
        code-after-break = "Hint";
        codestyle-check = "Warning";
        count-down-loop = "Warning";
        deprecated = "Warning";
        different-requires = "Warning";
        discard-returns = "Warning";
        doc-field-no-class = "Warning";
        duplicate-doc-alias = "Warning";
        duplicate-doc-field = "Warning";
        duplicate-doc-param = "Warning";
        duplicate-index = "Warning";
        duplicate-set-field = "Warning";
        empty-block = "Hint";
        global-in-nil-env = "Warning";
        lowercase-global = "Information";
        missing-parameter = "Warning";
        missing-return = "Warning";
        missing-return-value = "Warning";
        need-check-nil = "Warning";
        newfield-call = "Warning";
        newline-call = "Warning";
        no-unknown = "Warning";
        not-yieldable = "Warning";
        param-type-mismatch = "Warning";
        redefined-local = "Hint";
        redundant-parameter = "Warning";
        redundant-return = "Hint";
        redundant-return-value = "Warning";
        redundant-value = "Warning";
        return-type-mismatch = "Warning";
        spell-check = "Information";
        trailing-space = "Hint";
        unbalanced-assignments = "Warning";
        undefined-doc-class = "Warning";
        undefined-doc-name = "Warning";
        undefined-doc-param = "Warning";
        undefined-env-child = "Information";
        undefined-field = "Warning";
        undefined-global = "Warning";
        unknown-cast-variable = "Warning";
        unknown-diag-code = "Warning";
        unknown-operator = "Warning";
        unreachable-code = "Hint";
        unused-function = "Hint";
        unused-label = "Hint";
        unused-local = "Hint";
        unused-vararg = "Hint";
      }
      ''
        Maps diagnostic groups to severity levels.
        - `"Error"` - An error will be raised
        - `"Warning"` - A warning will be raised
        - `"Information"` - An information or note will be raised
        - `"Hint"` - The affected code will be "hinted" at
        - `"Error!"` - Like `"Error"` but overrides `diagnostics.groupSeverity`
        - `"Warning!"` -Like `"Warning"` but overrides `diagnostics.groupSeverity`
        - `"Information!"` - Like `"Information"` but overrides `diagnostics.groupSeverity`
        - `"Hint!"` - Like `"Hint"` but overrides `diagnostics.groupSeverity`
      '';

    unusedLocalExclude = helpers.defaultNullOpts.mkListOf types.str [] ''
      Define variable names that will not be reported as an unused local by
      [`unused-local`](https://github.com/LuaLS/lua-language-server/wiki/Diagnostics#unused-local).
    '';

    workspaceDelay = helpers.defaultNullOpts.mkUnsignedInt 3000 ''
      Define the delay between diagnoses of the workspace in milliseconds.
      Every time a file is edited, created, deleted, etc. the workspace will be re-diagnosed in the
      background after this delay.
      Setting to a negative number will disable workspace diagnostics.
    '';

    workspaceEvent =
      helpers.defaultNullOpts.mkEnum
      [
        "OnChange"
        "OnSave"
        "None"
      ]
      "OnSave"
      ''
        Set when the workspace diagnostics should be analyzed.
        It can be performed after each change, after a save, or never automatically triggered.

        Valid events:
        - `"OnChange"`
        - `"OnSave"`
        - `"None"`
      '';

    workspaceRate = helpers.defaultNullOpts.mkUnsignedInt 100 ''
      Define the rate at which the workspace will be diagnosed as a percentage.
      `100` is 100% speed so the workspace will be diagnosed as fast as possible.
      The rate can be lowered to reduce CPU usage, but the diagnosis speed will also become slower.
      The currently opened file will always be diagnosed at `100`% speed, regardless of this setting.
    '';
  };

  doc = {
    packageName = helpers.defaultNullOpts.mkListOf types.str [] ''
      The pattern used for matching field names as a package-private field.
      Fields that match any of the patterns provided will be package-private.
    '';

    privateName = helpers.defaultNullOpts.mkListOf types.str [] ''
      The pattern used for matching field names as a private field.
      Fields that match any of the patterns provided will be private to that class.
    '';

    protectedName = helpers.defaultNullOpts.mkListOf types.str [] ''
      The pattern used for matching field names as a protected field.
      Fields that match any of the patterns provided will be private to that class and its child classes.
    '';
  };

  format = {
    defaultConfig = helpers.defaultNullOpts.mkAttrsOf types.str {} ''
      The default configuration for the formatter.
      If there is a `.editorconfig` in the workspace, it will take priority.
      Read more on the [formatter's GitHub page](https://github.com/CppCXY/EmmyLuaCodeStyle/tree/master/docs).
    '';

    enable = helpers.defaultNullOpts.mkBool true ''
      Whether the built-in formatted should be enabled or not.
    '';
  };

  hint = {
    arrayIndex =
      helpers.defaultNullOpts.mkEnum
      [
        "Enable"
        "Auto"
        "Disable"
      ]
      "Auto"
      ''
        - `"Enable"` - Show hint in all tables
        - `"Auto"` - Only show hint when there is more than 3 items or the table is mixed (indexes and keys)
        - `"Disable"` - Disable array index hints
      '';

    await = helpers.defaultNullOpts.mkBool true ''
      If a function has been defined as [`@async`](https://github.com/LuaLS/lua-language-server/wiki/Annotations#async),
      display an `await` hint when it is being called.
    '';

    enable = helpers.defaultNullOpts.mkBool false ''
      Whether inline hints should be enabled or not.
    '';

    paramName =
      helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "All"
        "Literal"
        "Disable"
      ]
      ''
        Whether parameter names should be hinted when typing out a function call.

        - `"All"` - All parameters are hinted
        - `"Literal"` - Only literal type parameters are hinted
        - `"Disable"` - No parameter hints are shown
      '';

    paramType = helpers.defaultNullOpts.mkBool true ''
      Show a hint for parameter types at a function definition.
      Requires the parameters to be defined with [`@param`](https://github.com/LuaLS/lua-language-server/wiki/Annotations#param).
    '';

    semicolon =
      helpers.defaultNullOpts.mkEnum
      [
        "All"
        "SameLine"
        "Disable"
      ]
      "SameLine"
      ''
        Whether to show a hint to add a semicolon to the end of a statement.

        - `"All"` - Show on every line
        - `"SameLine"` - Show between two statements on one line
        - `"Disable"` - Never hint a semicolon
      '';

    setType = helpers.defaultNullOpts.mkBool false ''
      Show a hint to display the type being applied at assignment operations.
    '';
  };

  hover = {
    enable = helpers.defaultNullOpts.mkBool true ''
      Whether to enable hover tooltips or not.
    '';

    enumsLimit = helpers.defaultNullOpts.mkUnsignedInt 5 ''
      When a value has multiple possible types, hovering it will display them.
      This setting limits how many will be displayed in the tooltip before they are truncated.
    '';

    expandAlias = helpers.defaultNullOpts.mkBool true ''
      When hovering a value with an [`@alias`](https://github.com/LuaLS/lua-language-server/wiki/Annotations#alias)
      for its type, should the alias be expanded into its values.
      When enabled, `---@alias myType boolean|number` appears as `boolean|number`, otherwise it will
      appear as `myType`.
    '';

    previewFields = helpers.defaultNullOpts.mkUnsignedInt 50 ''
      When a table is hovered, its fields will be displayed in the tooltip.
      This setting limits how many fields can be seen in the tooltip.
      Setting to `0` will disable this feature.
    '';

    viewNumber = helpers.defaultNullOpts.mkBool true ''
      Enable hovering a non-decimal value to see its numeric value.
    '';

    viewString = helpers.defaultNullOpts.mkBool true ''
      Enable hovering a string that contains an escape character to see its true string value.
      For example, hovering `"\x48"` will display `"H"`.
    '';

    viewStringMax = helpers.defaultNullOpts.mkUnsignedInt 1000 ''
      The maximum number of characters that can be previewed by hovering a string before it is
      truncated.
    '';
  };

  misc = {
    parameters = helpers.defaultNullOpts.mkListOf types.str [] ''
      [Command line parameters](https://github.com/LuaLS/lua-language-server/wiki/Getting-Started#run)
      to be passed along to the server `exe` when starting through Visual Studio Code.
    '';

    executablePath = helpers.defaultNullOpts.mkStr "" ''
      Manually specify the path for the Lua Language Server executable file.
    '';
  };

  runtime = {
    builtin =
      helpers.defaultNullOpts.mkAttrsOf
      (types.enum [
        "default"
        "enable"
        "disable"
      ])
      {
        basic = "default";
        bit = "default";
        bit32 = "default";
        builtin = "default";
        coroutine = "default";
        debug = "default";
        ffi = "default";
        io = "default";
        jit = "default";
        math = "default";
        os = "default";
        package = "default";
        string = "default";
        table = "default";
        "table.clear" = "default";
        "table.new" = "default";
        utf8 = "default";
      }
      ''
        Set whether each of the builtin Lua libraries is available in the current runtime environment.

        Valid `library` options:
        - `"basic"`
        - `"bit"`
        - `"bit32"`
        - `"builtin"`
        - `"coroutine"`
        - `"debug"`
        - `"ffi"`
        - `"io"`
        - `"jit"`
        - `"math"`
        - `"os"`
        - `"package"`
        - `"string"`
        - `"table"`
        - `"table.clear"`
        - `"table.new"`
        - `"utf8"`

        Valid `status` values:
        - `"default"` - The library will be enabled if it is a part of the current [`runtime.version`](https://github.com/LuaLS/lua-language-server/wiki/Settings#runtimeversion).
        - `"enable"` - Always enable this library
        - `"disable"` - Always disable this library
      '';

    fileEncoding =
      helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "utf8"
        "ansi"
        "utf16le"
        "utf16be"
      ]
      ''
        - `"utf8"`
        - `"ansi"` (only available on Windows)
        - `"utf16le"`
        - `"utf16be"`
      '';

    meta = helpers.defaultNullOpts.mkStr "$\{version} $\{language} $\{encoding}" ''
      Specify the template that should be used for naming the folders that contain the generated
      definitions for the various Lua versions, languages, and encodings.
    '';

    nonstandardSymbol =
      helpers.defaultNullOpts.mkListOf
      (types.enum [
        "//"
        "/**/"
        "`"
        "+="
        "-="
        "*="
        "/="
        "%="
        "^="
        "//="
        "|="
        "&="
        "<<="
        ">>="
        "||"
        "&&"
        "!"
        "!="
        "continue"
      ])
      []
      ''
        Add support for non-standard symbols.
        Make sure to double check that your runtime environment actually supports the symbols you are
        permitting as standard Lua does not.
      '';

    path =
      helpers.defaultNullOpts.mkListOf types.str
      [
        "?.lua"
        "?/init.lua"
      ]
      ''
        Defines the paths to use when using `require`.
        For example, setting to `?/start.lua` will search for `<workspace>/myFile/start.lua` from the
        loaded files when doing `require"myFile"`.
        If [`runtime.pathStrict`](https://github.com/LuaLS/lua-language-server/wiki/Settings#runtimepathstrict)
        is `false`, `<workspace>/**/myFile/start.lua` will also be searched.
        To load files that are not in the current workspace, they will first need to be loaded using
        [`workspace.library`](https://github.com/LuaLS/lua-language-server/wiki/Settings#workspacelibrary).
      '';

    pathStrict = helpers.defaultNullOpts.mkBool false ''
      When enabled, [`runtime.path`](https://github.com/LuaLS/lua-language-server/wiki/Settings#runtimepath)
      will only search the first level of directories.
      See the description of `runtime.path` for more info.
    '';

    plugin = helpers.defaultNullOpts.mkStr "" ''
      The path to the [plugin](https://github.com/LuaLS/lua-language-server/wiki/Plugins) to use.
      Blank by default for security reasons.
    '';

    pluginArgs = helpers.defaultNullOpts.mkListOf types.str [] ''
      Additional arguments that will be passed to the active
      [plugin](https://github.com/LuaLS/lua-language-server/wiki/Plugins).
    '';

    special = helpers.defaultNullOpts.mkAttrsOf types.str {} ''
      Special variables can be set to be treated as other variables. For example, specifying `"include" : "require"` will result in `include` being treated like `require`.
    '';

    unicodeName = helpers.defaultNullOpts.mkBool false ''
      Whether unicode characters should be allowed in variable names or not.
    '';

    version = helpers.defaultNullOpts.mkStr "Lua 5.4" ''
      The Lua runtime version to use in this environment.
    '';
  };

  semantic = {
    annotation = helpers.defaultNullOpts.mkBool true ''
      Whether semantic colouring should be enabled for type annotations.
    '';

    enable = helpers.defaultNullOpts.mkBool true ''
      Whether semantic colouring should be enabled.
      You may need to set `editor.semanticHighlighting.enabled` to true in order for this setting to
      take effect.
    '';

    keyword = helpers.defaultNullOpts.mkBool false ''
      Whether the server should provide semantic colouring of keywords, literals, and operators.
      You should only need to enable this setting if your editor is unable to highlight Lua's syntax.
    '';

    variable = helpers.defaultNullOpts.mkBool true ''
      Whether the server should provide semantic colouring of variables, fields, and parameters.
    '';
  };

  signatureHelp = {
    enable = helpers.defaultNullOpts.mkBool true ''
      The signatureHelp group contains settings for helping understand signatures.
    '';
  };

  spell = {
    dict = helpers.defaultNullOpts.mkListOf types.str [] ''
      A custom dictionary of words that you know are spelt correctly but are being reported as incorrect.
      Adding words to this dictionary will make them exempt from spell checking.
    '';
  };

  telemetry = {
    enable = helpers.defaultNullOpts.mkBool null ''
      The language server comes with opt-in telemetry to help improve the language server.
      It would be greatly appreciated if you enable this setting.
      Read the [privacy policy](https://github.com/LuaLS/lua-language-server/wiki/Home#privacy)
      before enabling.
    '';
  };

  type = {
    castNumberToInteger = helpers.defaultNullOpts.mkBool false ''
      Whether casting a `number` to an `integer` is allowed.
    '';

    weakNilCheck = helpers.defaultNullOpts.mkBool false ''
       Whether it is permitted to assign a union type that contains `nil` to a variable that does not
       permit it.
       When `false`, the following will throw an error because `number|nil` cannot be assigned to
       `number`.

      ```lua
        ---@alias unionType number|nil

        ---@type number
        local num

        ---@cast num unionType
      ```
    '';

    weakUnionCheck = helpers.defaultNullOpts.mkBool false ''
      Whether it is permitted to assign a union type which only has one matching type to a variable.
      When `false`, the following will throw an error because `string|boolean` cannot be assigned to
      `string`.

      ```lua
        ---@alias unionType string|boolean

        ---@type string
        local str = false
      ```
    '';
  };

  window = {
    progressBar = helpers.defaultNullOpts.mkBool true ''
      Show a progress bar in the bottom status bar that shows how the workspace loading is progressing.
    '';

    statusBar = helpers.defaultNullOpts.mkBool true ''
      Show a `Lua 😺` entry in the bottom status bar that can be clicked to manually perform a
      workspace diagnosis.
    '';
  };

  workspace = {
    checkThirdParty = helpers.defaultNullOpts.mkBool true ''
      Whether [third party libraries](https://github.com/LuaLS/lua-language-server/wiki/Libraries)
      can be automatically detected and applied.
      Third party libraries can set up the environment to be as close as possible to your target
      runtime environment.
      See [`meta/3rd`](https://github.com/LuaLS/lua-language-server/tree/master/meta/3rd)
      to view what third party libraries are currently supported.
    '';

    ignoreDir = helpers.defaultNullOpts.mkListOf types.str [".vscode"] ''
      An array of paths that will be ignored and not included in the workspace diagnosis.
      Uses `.gitignore` grammar. Can be a file or directory.
    '';

    ignoreSubmodules = helpers.defaultNullOpts.mkBool true ''
      Whether [git submodules](https://github.blog/2016-02-01-working-with-submodules/)
      should be ignored and not included in the workspace diagnosis.
    '';

    library = helpers.defaultNullOpts.mkListOf types.str [] ''
      An array of abosolute or workspace-relative paths that will be added to the workspace
      diagnosis - meaning you will get completion and context from these library files.
      Can be a file or directory.
      Files included here will have some features disabled such as renaming fields to prevent
      accidentally renaming your library files.
      Read more on the [Libraries page](https://github.com/LuaLS/lua-language-server/wiki/Libraries).
    '';

    maxPreload = helpers.defaultNullOpts.mkUnsignedInt 5000 ''
      The maximum amount of files that can be diagnosed.
      More files will require more RAM.
    '';

    preloadFileSize = helpers.defaultNullOpts.mkUnsignedInt 500 ''
      Files larger than this value (in KB) will be skipped when loading for workspace diagnosis.
    '';

    supportScheme =
      helpers.defaultNullOpts.mkListOf types.str
      [
        "file"
        "untitled"
        "git"
      ]
      ''
        Lua file schemes to enable the language server for.
      '';

    useGitIgnore = helpers.defaultNullOpts.mkBool true ''
      Whether files that are in `.gitignore` should be ignored by the language server when
      performing workspace diagnosis.
    '';

    userThirdParty = helpers.defaultNullOpts.mkListOf types.str [] ''
      An array of paths to
      [custom third party libraries](https://github.com/LuaLS/lua-language-server/wiki/Libraries#custom).
      This path should point to a directory where **all** of your custom libraries are, not just to
      one of the libraries.
      If the below is your file structure, this setting should be `"myLuaLibraries"` - of course
      this should be an absolute path though.

      ```txt
      📦 myLuaLibraries/
          ├── 📂 myCustomLibrary/
          │   ├── 📂 library/
          │   └── 📜 config.lua
          └── 📂 anotherCustomLibrary/
              ├── 📂 library/
              └── 📜 config.lua
      ```
    '';
  };
}
