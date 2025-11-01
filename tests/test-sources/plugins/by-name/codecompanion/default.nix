{
  empty = {
    plugins.codecompanion.enable = true;
  };

  defaults = {
    plugins.codecompanion = {
      enable = true;

      settings = {
        adapters.http = {
          anthropic = "anthropic";
          azure_openai = "azure_openai";
          copilot = "copilot";
          gemini = "gemini";
          ollama = "ollama";
          openai = "openai";
          xai = "xai";
          non_llms = {
            jina = "jina";
          };
          opts = {
            allow_insecure = false;
            proxy.__raw = "nil";
          };
        };
        strategies = {
          chat = {
            adapter = "copilot";
            roles = {
              llm = "CodeCompanion";
              user = "Me";
            };
            variables = {
              buffer = {
                callback = "strategies.chat.variables.buffer";
                description = "Share the current buffer with the LLM";
                opts = {
                  contains_code = true;
                  has_params = true;
                };
              };
              lsp = {
                callback = "strategies.chat.variables.lsp";
                description = "Share LSP information and code for the current buffer";
                opts = {
                  contains_code = true;
                  hide_reference = true;
                };
              };
              viewport = {
                callback = "strategies.chat.variables.viewport";
                description = "Share the code that you see in Neovim with the LLM";
                opts = {
                  contains_code = true;
                  hide_reference = true;
                };
              };
            };
            slash_commands = {
              buffer = {
                callback = "strategies.chat.slash_commands.buffer";
                description = "Insert open buffers";
                opts = {
                  contains_code = true;
                  provider = "default";
                };
              };
              fetch = {
                callback = "strategies.chat.slash_commands.fetch";
                description = "Insert URL contents";
                opts = {
                  adapter = "jina";
                };
              };
              file = {
                callback = "strategies.chat.slash_commands.file";
                description = "Insert a file";
                opts = {
                  contains_code = true;
                  max_lines = 1000;
                  provider = "default";
                };
              };
              help = {
                callback = "strategies.chat.slash_commands.help";
                description = "Insert content from help tags";
                opts = {
                  contains_code = false;
                  provider = "telescope";
                };
              };
              now = {
                callback = "strategies.chat.slash_commands.now";
                description = "Insert the current date and time";
                opts = {
                  contains_code = false;
                };
              };
              symbols = {
                callback = "strategies.chat.slash_commands.symbols";
                description = "Insert symbols for a selected file";
                opts = {
                  contains_code = true;
                  provider = "default";
                };
              };
              terminal = {
                callback = "strategies.chat.slash_commands.terminal";
                description = "Insert terminal output";
                opts = {
                  contains_code = false;
                };
              };
            };
            keymaps = {
              options = {
                modes = {
                  n = "?";
                };
                callback = "keymaps.options";
                description = "Options";
                hide = true;
              };
              completion = {
                modes = {
                  i = "<C-_>";
                };
                index = 1;
                callback = "keymaps.completion";
                condition.__raw = ''
                  function()
                    local has_cmp, _ = pcall(require, "cmp")
                    return not has_cmp
                  end
                '';
                description = "Completion Menu";
              };
              send = {
                modes = {
                  n = [
                    "<CR>"
                    "<C-s>"
                  ];
                  i = "<C-s>";
                };
                index = 1;
                callback = "keymaps.send";
                description = "Send";
              };
              regenerate = {
                modes = {
                  n = "gr";
                };
                index = 2;
                callback = "keymaps.regenerate";
                description = "Regenerate the last response";
              };
              close = {
                modes = {
                  n = "<C-c>";
                  i = "<C-c>";
                };
                index = 3;
                callback = "keymaps.close";
                description = "Close Chat";
              };
              stop = {
                modes = {
                  n = "q";
                };
                index = 4;
                callback = "keymaps.stop";
                description = "Stop Request";
              };
              clear = {
                modes = {
                  n = "gx";
                };
                index = 5;
                callback = "keymaps.clear";
                description = "Clear Chat";
              };
              codeblock = {
                modes = {
                  n = "gc";
                };
                index = 6;
                callback = "keymaps.codeblock";
                description = "Insert Codeblock";
              };
              yank_code = {
                modes = {
                  n = "gy";
                };
                index = 7;
                callback = "keymaps.yank_code";
                description = "Yank Code";
              };
              next_chat = {
                modes = {
                  n = "}";
                };
                index = 8;
                callback = "keymaps.next_chat";
                description = "Next Chat";
              };
              previous_chat = {
                modes = {
                  n = "{";
                };
                index = 9;
                callback = "keymaps.previous_chat";
                description = "Previous Chat";
              };
              next_header = {
                modes = {
                  n = "]]";
                };
                index = 10;
                callback = "keymaps.next_header";
                description = "Next Header";
              };
              previous_header = {
                modes = {
                  n = "[[";
                };
                index = 11;
                callback = "keymaps.previous_header";
                description = "Previous Header";
              };
              change_adapter = {
                modes = {
                  n = "ga";
                };
                index = 12;
                callback = "keymaps.change_adapter";
                description = "Change adapter";
              };
              fold_code = {
                modes = {
                  n = "gf";
                };
                index = 13;
                callback = "keymaps.fold_code";
                description = "Fold code";
              };
              debug = {
                modes = {
                  n = "gd";
                };
                index = 14;
                callback = "keymaps.debug";
                description = "View debug info";
              };
              system_prompt = {
                modes = {
                  n = "gs";
                };
                index = 15;
                callback = "keymaps.toggle_system_prompt";
                description = "Toggle the system prompt";
              };
            };
            opts = {
              register = "+";
              yank_jump_delay_ms = 400;
            };
          };
          inline = {
            adapter = "copilot";
            keymaps = {
              accept_change = {
                modes = {
                  n = "ga";
                };
                index = 1;
                callback = "keymaps.accept_change";
                description = "Accept change";
              };
              reject_change = {
                modes = {
                  n = "gr";
                };
                index = 2;
                callback = "keymaps.reject_change";
                description = "Reject change";
              };
            };
            prompts = {
              inline_to_chat.__raw = ''
                function(context)
                  return fmt(
                    [[I want you to act as an expert and senior developer in the %s language. I will ask you questions, perhaps giving you code examples, and I want you to advise me with explanations and code where necessary.]],
                    context.filetype
                  )
                end
              '';
            };
          };
          agent = {
            full_stack_dev = {
              description = "Full Stack Developer - Can run code, edit code and modify files";
              system_prompt = "**DO NOT** make any assumptions about the dependencies that a user has installed. If you need to install any dependencies to fulfil the user's request, do so via the Command Runner tool. If the user doesn't specify a path, use their current working directory.";
              tools = [
                "cmd_runner"
                "editor"
                "files"
              ];
            };
            tools = {
              cmd_runner = {
                callback = "strategies.chat.tools.cmd_runner";
                description = "Run shell commands initiated by the LLM";
                opts = {
                  user_approval = true;
                };
              };
              editor = {
                callback = "strategies.chat.tools.editor";
                description = "Update a buffer with the LLM's response";
              };
              files = {
                callback = "strategies.chat.tools.files";
                description = "Update the file system with the LLM's response";
                opts = {
                  user_approval = true;
                };
              };
              rag = {
                callback = "strategies.chat.tools.rag";
                description = "Supplement the LLM with real-time info from the internet";
                opts = {
                  hide_output = true;
                };
              };
              opts = {
                auto_submit_errors = false;
                auto_submit_success = false;
                system_prompt.__raw = ''
                  [[## Tools

                    You now have access to tools:
                    - These enable you to assist the user with specific tasks
                    - The user will outline which specific tools you have access to
                    - You trigger a tool by following a specific XML schema which is defined for each tool

                    You must:
                    - Only use the tool when prompted by the user, despite having access to it
                    - Follow the specific tool's schema
                    - Respond with the schema in XML format
                    - Ensure the schema is in a markdown code block that is designated as XML
                    - Ensure any output you're intending to execute will be able to parsed as valid XML

                    Points to note:
                    - The user detects that you've triggered a tool by using Tree-sitter to parse your markdown response
                    - If you call multiple tools within the same response:
                      - Each unique tool MUST be called in its own, individual, XML codeblock
                      - Tools of the same type SHOULD be called in the same XML codeblock
                    - If your response doesn't follow the tool's schema, the tool will not execute
                    - Tools should not alter your core tasks and how you respond to a user
                  ]]
                '';
              };
            };
          };
          cmd = {
            adapter = "copilot";
            opts = {
              system_prompt.__raw = ''
                [[
                  You are currently plugged in to the Neovim text editor on a user's machine. Your core task is to generate an command-line inputs that the user can run within Neovim. Below are some rules to adhere to:

                  - Return plain text only
                  - Do not wrap your response in a markdown block or backticks
                  - Do not use any line breaks or newlines in you response
                  - Do not provide any explanations
                  - Generate an command that is valid and can be run in Neovim
                  - Ensure the command is relevant to the user's request
                ]]
              '';
            };
          };
        };
        prompt_library = {
          "Custom Prompt" = {
            strategy = "inline";
            description = "Prompt the LLM from Neovim";
            opts = {
              index = 3;
              is_default = true;
              is_slash_cmd = false;
              user_prompt = true;
            };
            prompts = [
              {
                role.__raw = "system";
                content.__raw = ''
                  function(context)
                    return fmt(
                      [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
                      context.filetype
                    )
                  end
                '';
                opts = {
                  visible = false;
                  tag = "system_tag";
                };
              }
            ];
          };
          "Code workflow" = {
            strategy = "workflow";
            description = "Use a workflow to guide an LLM in writing code";
            opts = {
              index = 4;
              is_default = true;
              short_name = "workflow";
            };
            prompts = [
              [
                {
                  role = "system";
                  content.__raw = ''
                    function(context)
                      return fmt(
                        "You carefully provide accurate, factual, thoughtful, nuanced answers, and are brilliant at reasoning. If you think there might not be a correct answer, you say so. Always spend a few sentences explaining background context, assumptions, and step-by-step thinking BEFORE you try to answer a question. Don't be verbose in your answers, but do provide details and examples where it might help the explanation. You are an expert software engineer for the %s language",
                        context.filetype
                      )
                    end
                  '';
                  opts = {
                    visible = false;
                  };
                }
                {
                  role = "user";
                  content = "I want you to ";
                  opts = {
                    auto_submit = false;
                  };
                }
              ]
              [
                {
                  role = "user";
                  content = "Great. Now let's consider your code. I'd like you to check it carefully for correctness, style, and efficiency, and give constructive criticism for how to improve it.";
                  opts = {
                    auto_submit = false;
                  };
                }
              ]
              [
                {
                  role = "user";
                  content = "Thanks. Now let's revise the code based on the feedback, without additional explanations.";
                  opts = {
                    auto_submit = false;
                  };
                }
              ]
            ];
          };
          Explain = {
            strategy = "chat";
            description = "Explain how code in a buffer works";
            opts = {
              index = 5;
              is_default = true;
              is_slash_cmd = false;
              modes = [ "v" ];
              short_name = "explain";
              auto_submit = true;
              user_prompt = false;
              stop_context_insertion = true;
            };
            prompts = [
              {
                role = "system";
                content.__raw = ''
                  [[
                    When asked to explain code, follow these steps:

                    1. Identify the programming language.
                    2. Describe the purpose of the code and reference core concepts from the programming language.
                    3. Explain each function or significant block of code, including parameters and return values.
                    4. Highlight any specific functions or methods used and their roles.
                    5. Provide context on how the code fits into a larger application if applicable.
                  ]]
                '';
                opts = {
                  visible = false;
                };
              }
              {
                role = "user";
                content.__raw = ''
                  function(context)
                    local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                    return fmt(
                      [[Please explain this code from buffer %d:

                      ```%s
                      %s
                      ```
                      ]],
                      context.bufnr,
                      context.filetype,
                      code
                    )
                  end
                '';
                opts = {
                  contains_code = true;
                };
              }
            ];
          };
          "Unit Tests" = {
            strategy = "chat";
            description = "Generate unit tests for the selected code";
            opts = {
              index = 6;
              is_default = true;
              is_slash_cmd = false;
              modes = [ "v" ];
              short_name = "tests";
              auto_submit = true;
              user_prompt = false;
              stop_context_insertion = true;
            };
            prompts = [
              {
                role = "system";
                content.__raw = ''
                  [[
                    When generating unit tests, follow these steps:

                    1. Identify the programming language.
                    2. Identify the purpose of the function or module to be tested.
                    3. List the edge cases and typical use cases that should be covered in the tests and share the plan with the user.
                    4. Generate unit tests using an appropriate testing framework for the identified programming language.
                    5. Ensure the tests cover:
                          - Normal cases
                          - Edge cases
                          - Error handling (if applicable)
                    6. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.
                  ]]
                '';
                opts = {
                  visible = false;
                };
              }
              {
                role = "user";
                content.__raw = ''
                  function(context)
                    local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                    return fmt(
                      [[Please generate unit tests for this code from buffer %d:

                      ```%s
                      %s
                      ```
                      ]],
                      context.bufnr,
                      context.filetype,
                      code
                    )
                  end
                '';
                opts = {
                  contains_code = true;
                };
              }
            ];
          };
          "Fix code" = {
            strategy = "chat";
            description = "Fix the selected code";
            opts = {
              index = 7;
              is_default = true;
              is_slash_cmd = false;
              modes = [ "v" ];
              short_name = "fix";
              auto_submit = true;
              user_prompt = false;
              stop_context_insertion = true;
            };
            prompts = [
              {
                role = "system";
                content.__raw = ''
                  [[When asked to fix code, follow these steps:

                  1. **Identify the Issues**: Carefully read the provided code and identify any potential issues or improvements.
                  2. **Plan the Fix**: Describe the plan for fixing the code in pseudocode, detailing each step.
                  3. **Implement the Fix**: Write the corrected code in a single code block.
                  4. **Explain the Fix**: Briefly explain what changes were made and why.

                  Ensure the fixed code:

                  - Includes necessary imports.
                  - Handles potential errors.
                  - Follows best practices for readability and maintainability.
                  - Is formatted correctly.

                  Use Markdown formatting and include the programming language name at the start of the code block.]]
                '';
                opts = {
                  visible = false;
                };
              }
              {
                role = "user";
                content.__raw = ''
                  function(context)
                    local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                    return fmt(
                      [[Please fix this code from buffer %d:
                    ```%s
                    %s
                    ```
                      ]],
                      context.bufnr,
                      context.filetype,
                      code
                    )
                  end
                '';
                opts = {
                  contains_code = true;
                };
              }
            ];
          };
          "Buffer selection" = {
            strategy = "inline";
            description = "Send the current buffer to the LLM as part of an inline prompt";
            opts = {
              index = 8;
              modes = [ "v" ];
              is_default = true;
              is_slash_cmd = false;
              short_name = "buffer";
              auto_submit = true;
              user_prompt = true;
              stop_context_insertion = true;
            };
            prompts = [
              {
                role = "system";
                content.__raw = ''
                  function(context)
                    return "I want you to act as a senior "
                      .. context.filetype
                      .. " developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing."
                  end
                '';
                opts = {
                  visible = false;
                  tag = "system_tag";
                };
              }
              {
                role = "user";
                content.__raw = ''
                  function(context)
                    local buf_utils = require("codecompanion.utils.buffers")

                    return "```" .. context.filetype .. "\n" .. buf_utils.get_content(context.bufnr) .. "\n```\n\n"
                  end
                '';
                opts = {
                  contains_code = true;
                  visible = false;
                };
              }
              {
                role = "user";
                condition.__raw = ''
                  function(context)
                    return context.is_visual
                  end
                '';
                content.__raw = ''
                  function(context)
                    local selection = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                    return fmt(
                      [[And this is some code that relates to my question:

                      ```%s
                      %s
                      ```
                      ]],
                      context.filetype,
                      selection
                    )
                  end
                '';
                opts = {
                  contains_code = true;
                  visible = true;
                  tag = "visual";
                };
              }
            ];
          };
          "Explain LSP Diagnostics" = {
            strategy = "chat";
            description = "Explain the LSP diagnostics for the selected code";
            opts = {
              index = 9;
              is_default = true;
              is_slash_cmd = false;
              modes = [ "v" ];
              short_name = "lsp";
              auto_submit = true;
              user_prompt = false;
              stop_context_insertion = true;
            };
            prompts = [
              {
                role = "system";
                content.__raw = "[[You are an expert coder and helpful assistant who can help debug code diagnostics, such as warning and error messages. When appropriate, give solutions with code snippets as fenced codeblocks with a language identifier to enable syntax highlighting.]]";
                opts = {
                  visible = false;
                };
              }
              {
                role = "user";
                content.__raw = ''
                  function(context)
                    local diagnostics = require("codecompanion.helpers.actions").get_diagnostics(
                      context.start_line,
                      context.end_line,
                      context.bufnr
                    )

                    local concatenated_diagnostics = ""
                    for i, diagnostic in ipairs(diagnostics) do
                      concatenated_diagnostics = concatenated_diagnostics
                        .. i
                        .. ". Issue "
                        .. i
                        .. "\n  - Location: Line "
                        .. diagnostic.line_number
                        .. "\n  - Buffer: "
                        .. context.bufnr
                        .. "\n  - Severity: "
                        .. diagnostic.severity
                        .. "\n  - Message: "
                        .. diagnostic.message
                        .. "\n"
                    end

                    return fmt(
                      [[The programming language is %s. This is a list of the diagnostic messages:

                      %s
                      ]],
                      context.filetype,
                      concatenated_diagnostics
                    )
                  end
                '';
              }
              {
                role = "user";
                content.__raw = ''
                  function(context)
                    local code = require("codecompanion.helpers.actions").get_code(
                      context.start_line,
                      context.end_line,
                      { show_line_numbers = true }
                    )
                    return fmt(
                      [[
                      This is the code, for context:

                      ```%s
                      %s
                      ```
                      ]],
                      context.filetype,
                      code
                    )
                  end
                '';
                opts = {
                  contains_code = true;
                };
              }
            ];
          };
          "Generate a Commit Message" = {
            strategy = "chat";
            description = "Generate a commit message";
            opts = {
              index = 10;
              is_default = true;
              is_slash_cmd = true;
              short_name = "commit";
              auto_submit = true;
            };
            prompts = [
              {
                role = "user";
                content.__raw = ''
                  function()
                    return fmt(
                      [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

                      ```diff
                      %s
                      ```
                      ]],
                      vim.fn.system("git diff --no-ext-diff --staged")
                    )
                  end
                '';
                opts = {
                  contains_code = true;
                };
              }
            ];
          };
        };
        display = {
          action_palette = {
            width = 95;
            height = 10;
            prompt = "Prompt ";
            provider = "default";
            opts = {
              show_default_actions = true;
              show_default_prompt_library = true;
            };
          };
          chat = {
            window = {
              layout = "vertical";
              border = "single";
              height = 0.8;
              width = 0.45;
              relative = "editor";
              opts = {
                breakindent = true;
                cursorcolumn = false;
                cursorline = false;
                foldcolumn = "0";
                linebreak = true;
                list = false;
                signcolumn = "no";
                spell = false;
                wrap = true;
              };
            };
            intro_message = "Welcome to CodeCompanion ✨! Press ? for options";
            show_header_separator = true;
            separator = "─";
            show_references = true;
            show_settings = false;
            show_token_count = true;
            start_in_insert_mode = false;
            token_count.__raw = ''
              function(tokens, adapter) -- The function to display the token count
                return " (" .. tokens .. " tokens)"
               end
            '';
          };
          diff = {
            enabled = true;
            close_chat_at = 240;
            layout = "vertical";
            opts = [
              "internal"
              "filler"
              "closeoff"
              "algorithm:patience"
              "followwrap"
              "linematch:120"
            ];
            provider = "default";
          };
          inline = {
            layout = "vertical";
          };
        };
        opts = {
          log_level = "ERROR";
          language = "English";
          send_code = true;
          system_prompt.__raw = ''
            function(opts)
              local language = opts.language or "English"
              return string.format(
                [[You are an AI programming assistant named "CodeCompanion".
            You are currently plugged in to the Neovim text editor on a user's machine.

            Your core tasks include:
            - Answering general programming questions.
            - Explaining how the code in a Neovim buffer works.
            - Reviewing the selected code in a Neovim buffer.
            - Generating unit tests for the selected code.
            - Proposing fixes for problems in the selected code.
            - Scaffolding code for a new workspace.
            - Finding relevant code to the user's query.
            - Proposing fixes for test failures.
            - Answering questions about Neovim.
            - Running tools.

            You must:
            - Follow the user's requirements carefully and to the letter.
            - Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
            - Minimize other prose.
            - Use Markdown formatting in your answers.
            - Include the programming language name at the start of the Markdown code blocks.
            - Avoid line numbers in code blocks.
            - Avoid wrapping the whole response in triple backticks.
            - Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
            - Use actual line breaks instead of '\n' in your response to begin new lines.
            - Use '\n' only when you want a literal backslash followed by a character 'n'.
            - All non-code responses must use %s.

            When given a task:
            1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
            2. Output the code in a single code block, being careful to only return relevant code.
            3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
            4. You can only give one reply for each conversation turn.]],
                language
              )
            end
          '';
        };
      };
    };
  };

  example = {
    plugins.codecompanion = {
      enable = true;

      settings = {
        adapters.http = {
          ollama.__raw = ''
            function()
              return require('codecompanion.adapters').extend('ollama', {
                  env = {
                      url = "http://127.0.0.1:11434",
                  },
                  schema = {
                      model = {
                          default = 'qwen2.5-coder:latest',
                          -- default = "llama3.1:8b-instruct-q8_0",
                      },
                      num_ctx = {
                          default = 32768,
                      },
                  },
              })
            end
          '';
        };
        strategies = {
          chat.adapter = "ollama";
          inline.adapter = "ollama";
          agent.adapter = "ollama";
        };
        opts = {
          log_level = "TRACE";
          send_code = true;
          use_default_actions = true;
          use_default_prompts = true;
        };
      };
    };
  };
}
