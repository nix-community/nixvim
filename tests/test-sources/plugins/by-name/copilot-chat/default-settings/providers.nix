# https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/main/lua/CopilotChat/config/providers.lua
let
  copilot = {
    embeddings = "copilot_embeddings";

    get_headers.__raw = ''
      function(token)
        return {
          ['authorization'] = 'Bearer ' .. token,
          ['editor-version'] = EDITOR_VERSION,
          ['editor-plugin-version'] = 'CopilotChat.nvim/*',
          ['copilot-integration-id'] = 'vscode-chat',
          ['content-type'] = 'application/json',
        }
      end
    '';

    get_token.__raw = ''
      function()
        local response, err = utils.curl_get('https://api.github.com/copilot_internal/v2/token', {
          headers = {
            ['Authorization'] = 'Token ' .. get_github_token(),
            ['Accept'] = 'application/json',
          },
        })

        if err then
          error(err)
        end

        if response.status ~= 200 then
          error('Failed to authenticate: ' .. tostring(response.status))
        end

        local body = vim.json.decode(response.body)
        return body.token, body.expires_at
      end
    '';

    get_agents.__raw = ''
      function(headers)
        local response, err = utils.curl_get('https://api.githubcopilot.com/agents', {
          headers = headers,
        })

        if err then
          error(err)
        end

        if response.status ~= 200 then
          error('Failed to fetch agents: ' .. tostring(response.status))
        end

        local agents = vim.json.decode(response.body)['agents']
        local out = {}
        for _, agent in ipairs(agents) do
          table.insert(out, {
            id = agent.slug,
            name = agent.name,
            description = agent.description,
          })
        end

        return out
      end
    '';

    get_models.__raw = ''
      function(headers)
        local response, err = utils.curl_get('https://api.githubcopilot.com/models', {
          headers = headers,
        })

        if err then
          error(err)
        end

        if response.status ~= 200 then
          error('Failed to fetch models: ' .. tostring(response.status))
        end

        local models = {}
        for _, model in ipairs(vim.json.decode(response.body)['data']) do
          if model['capabilities']['type'] == 'chat' then
            table.insert(models, {
              id = model.id,
              name = model.name,
              version = model.version,
              tokenizer = model.capabilities.tokenizer,
              max_prompt_tokens = model.capabilities.limits.max_prompt_tokens,
              max_output_tokens = model.capabilities.limits.max_output_tokens,
              policy = not model['policy'] or model['policy']['state'] == 'enabled',
            })
          end
        end

        for _, model in ipairs(models) do
          if not model.policy then
            utils.curl_post('https://api.githubcopilot.com/models/' .. model.id .. '/policy', {
              headers = headers,
              body = vim.json.encode({ state = 'enabled' }),
            })
          end
        end

        return models
      end

      prepare_input = function(inputs, opts, model)
        local is_o1 = vim.startswith(opts.model, 'o1')

        inputs = vim.tbl_map(function(input)
          if is_o1 then
            if input.role == 'system' then
              input.role = 'user'
            end
          end

          return input
        end inputs)

        local out = {
          messages = inputs,
          model = opts.model,
          stream = not is_o1,
          n = 1,
        }

        if not is_o1 then
          out.temperature = opts.temperature
          out.top_p = 1
        end

        if model.max_output_tokens then
          out.max_tokens = model.max_output_tokens
        end

        return out
      end
    '';

    get_url.__raw = ''
      function(opts)
        if opts.agent then
          return 'https://api.githubcopilot.com/agents/' .. opts.agent .. '?chat'
        end

        return 'https://api.githubcopilot.com/chat/completions'
      end
    '';
  };

  github_models = {
    embeddings = "copilot_embeddings";

    get_headers.__raw = ''
      function(token)
        return {
          ['Authorization'] = 'Bearer ' .. token,
          ['Content-Type'] = 'application/json',
          ['x-ms-useragent'] = EDITOR_VERSION,
          ['x-ms-user-agent'] = EDITOR_VERSION,
        }
      end
    '';

    get_token.__raw = ''
      function()
        return get_github_token(), nil
      end
    '';

    get_models.__raw = ''
      function(headers)
        local response = utils.curl_post('https://api.catalog.azureml.ms/asset-gallery/v1.0/models', {
          headers = headers,
          body = [[
            {
              "filters": [
                { "field": "freePlayground", "values": ["true"], "operator": "eq"},
                { "field": "labels", "values": ["latest"], "operator": "eq"}
              ],
              "order": [
                { "field": "displayName", "direction": "asc" }
              ]
            }
          ]],
        })

        if not response or response.status ~= 200 then
          error('Failed to fetch models: ' .. tostring(response and response.status))
        end

        local models = {}
        for _, model in ipairs(vim.json.decode(response.body)['summaries']) do
          if vim.tbl_contains(model.inferenceTasks, 'chat-completion') then
            table.insert(models, {
              id = model.name,
              name = model.displayName,
              version = model.name .. '-' .. model.version,
              tokenizer = 'o200k_base',
              max_prompt_tokens = model.modelLimits.textLimits.inputContextWindow,
              max_output_tokens = model.modelLimits.textLimits.maxOutputTokens,
            })
          end
        end

        return models
      end
    '';

    inherit (copilot) prepare_input;

    get_url.__raw = ''
      function()
        return 'https://models.inference.ai.azure.com/chat/completions'
      end
    '';
  };

  copilot_embeddings = {
    inherit (copilot) get_headers get_token;

    prepare_input.__raw = ''
      function(inputs)
        return {
          dimensions = 512,
          input = inputs,
          model = 'text-embedding-3-small',
        }
      end
    '';

    get_url.__raw = ''
      function()
        return 'https://api.githubcopilot.com/embeddings'
      end
    '';
  };
in
{
  inherit
    copilot
    github_models
    copilot_embeddings
    ;
}
