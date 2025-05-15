local text = pandoc.text

function Header(el)
	if el.level == 1 then
		return el:walk({
			Str = function(el)
				return pandoc.Str(text.upper(el.text))
			end,
		})
	end
end

function Link(el)
	return el.content
end
