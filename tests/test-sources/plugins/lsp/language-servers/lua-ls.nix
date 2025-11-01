{
  defaults = {
    plugins.lsp = {
      enable = true;

      servers.lua_ls = {
        enable = true;

        settings = {
          addonManager = {
            enable = true;
          };
          completion = {
            autoRequire = true;
            callSnippet = "Disable";
            displayContext = 0;
            enable = true;
            keywordSnippet = "Replace";
            postfix = "@";
            requireSeparator = ".";
            showParams = true;
            showWord = "Fallback";
            workspaceWord = true;
          };
          diagnostics = {
            disable.__empty = { };
            disableScheme = [ "git" ];
            enable = true;
            globals.__empty = { };
            groupFileStatus = {
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
            };
            groupSeverity = {
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
            };
            ignoredFiles = "Opened";
            libraryFiles = "Opened";
            neededFileStatus = {
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
            };
            severity = {
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
            };
            unusedLocalExclude.__empty = { };
            workspaceDelay = 3000;
            workspaceEvent = "OnSave";
            workspaceRate = 100;
          };
          doc = {
            packageName.__empty = { };
            privateName.__empty = { };
            protectedName.__empty = { };
          };
          format = {
            defaultConfig.__empty = { };
            enable = true;
          };
          hint = {
            arrayIndex = "Auto";
            await = true;
            enable = false;
            paramName = "All";
            paramType = true;
            semicolon = "SameLine";
            setType = false;
          };
          hover = {
            enable = true;
            enumsLimit = 5;
            expandAlias = true;
            previewFields = 50;
            viewNumber = true;
            viewString = true;
            viewStringMax = 1000;
          };
          misc = {
            parameters.__empty = { };
            executablePath = "";
          };
          runtime = {
            builtin = {
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
            };
            fileEncoding = "utf8";
            meta = "$\{version} $\{language} $\{encoding}";
            nonstandardSymbol.__empty = { };
            path = [
              "?.lua"
              "?/init.lua"
            ];
            pathStrict = false;
            plugin = "";
            pluginArgs.__empty = { };
            special.__empty = { };
            unicodeName = false;
            version = "Lua 5.4";
          };
          semantic = {
            annotation = true;
            enable = true;
            keyword = false;
            variable = true;
          };
          signatureHelp = {
            enable = true;
          };
          spell = {
            dict.__empty = { };
          };
          telemetry = {
            enable.__raw = "nil";
          };
          type = {
            castNumberToInteger = false;
            weakNilCheck = false;
            weakUnionCheck = false;
          };
          window = {
            progressBar = true;
            statusBar = true;
          };
          workspace = {
            checkThirdParty = true;
            ignoreDir = [ ".vscode" ];
            ignoreSubmodules = true;
            library.__empty = { };
            maxPreload = 5000;
            preloadFileSize = 500;
            supportScheme = [
              "file"
              "untitled"
              "git"
            ];
            useGitIgnore = true;
            userThirdParty.__empty = { };
          };
        };
      };
    };
  };
}
