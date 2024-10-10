-- This script is heavily inspired by https://github.com/neovim/nvim-lspconfig/blob/master/scripts/docgen.lua
require("lspconfig")
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

local function require_all_configs()
	for _, v in ipairs(vim.fn.glob(vim.env.lspconfig .. "/lua/lspconfig/configs/*.lua", 1, 1)) do
		local module_name = v:gsub(".*/", ""):gsub("%.lua$", "")
		configs[module_name] = require("lspconfig.configs." .. module_name)
	end
end

local function map_list(t, func)
	local res = {}
	for i, v in ipairs(t) do
		local x = func(v, i)
		if x ~= nil then
			table.insert(res, x)
		end
	end
	return res
end

local function sorted_map_table(t, func)
	local keys = vim.tbl_keys(t)
	table.sort(keys)
	return map_list(keys, function(k)
		return func(k, t[k])
	end)
end

require_all_configs()

info = sorted_map_table(configs, function(server_name, server_info)
	local description = nil
	if server_info.document_config.docs ~= nil then
		description = server_info.document_config.docs.description
	end
	local cmd = server_info.document_config.default_config.cmd
	if type(cmd) == "function" then
		cmd = "see source file"
	end
	return {
		name = server_name,
		cmd = cmd,
		desc = description,
	}
end)

local writer = io.open("lsp.json", "w")
writer:write(vim.json.encode(info))
writer:close()
