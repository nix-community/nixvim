{ lib }:
{
  empty = {
    plugins.lsp-progress.enable = true;
  };

  defaults = {
    plugins.lsp-progress = {
      enable = true;
      settings = {
        spinner = [
          "⣾"
          "⣽"
          "⣻"
          "⢿"
          "⡿"
          "⣟"
          "⣯"
          "⣷"
        ];
        spin_update_time = 200;
        decay = 700;
        event = "LspProgressStatusUpdated";
        event_update_time_limit = 50;
        max_size = -1;
        regular_internal_update_time = 500;
        disable_events_opts = [
          {
            mode = "i";
            filetype = "TelescopePrompt";
          }
        ];
        series_format = lib.nixvim.mkRaw ''
          function(title, message, percentage, done)
            local builder = {}
            local has_title = false
            local has_message = false
            if type(title) == "string" and string.len(title) > 0 then
              table.insert(builder, title)
              has_title = true
            end
            if type(message) == "string" and string.len(message) > 0 then
              table.insert(builder, message)
              has_message = true
            end
            if percentage and (has_title or has_message) then
              table.insert(builder, string.format("(%.0f%%)", percentage))
            end
            if done and (has_title or has_message) then
              table.insert(builder, "- done")
            end
            return table.concat(builder, " ")
          end
        '';
        client_format = lib.nixvim.mkRaw ''
          function(client_name, spinner, series_messages)
            return #series_messages > 0 and ("[" .. client_name .. "] " .. spinner .. " " .. table.concat(series_messages, ", ")) or nil
          end
        '';
        format = lib.nixvim.mkRaw ''
          function(client_messages)
            local sign = " LSP"
            if #client_messages > 0 then
              return sign .. " " .. table.concat(client_messages, " ")
            end
            if #require("lsp-progress.api").lsp_clients() > 0 then
              return sign
            end
            return ""
          end
        '';
        debug = false;
        console_log = true;
        file_log = false;
        file_log_name = "lsp-progress.log";
      };
    };
  };

  example = {
    plugins.lsp-progress = {
      enable = true;
      settings = {
        decay = 1200;
        max_size = 80;
        format = lib.nixvim.mkRaw ''
          function(client_messages)
            return #client_messages > 0 and table.concat(client_messages, " ") or ""
          end
        '';
      };
    };
  };
}
