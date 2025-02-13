local len = pandoc.text.len
local sub = pandoc.text.sub

-- True if str starts with prefix
local function hasPrefix(prefix, str)
	local pfxLen = len(prefix)
	local strLen = len(str)
	if pfxLen == strLen then
		return prefix == str
	end
	if pfxLen < strLen then
		return prefix == sub(str, 1, pfxLen)
	end
	return false
end

function Link(link)
	local target = link.target
	-- Check for relative links
	-- TODO: handle ../
	if hasPrefix("./", target) then
		link.target = githubUrl .. sub(target, 3)
		return link
	end
	if not hasPrefix("https://", target) then
		link.target = githubUrl .. target
		return link
	end

	-- Check for absolute links, pointing to the docs website
	if docsUrl == target then
		link.target = "."
		return link
	end
	if hasPrefix(docsUrl, target) then
		local i = len(docsUrl) + 1
		link.target = sub(target, i)
		return link
	end
end
