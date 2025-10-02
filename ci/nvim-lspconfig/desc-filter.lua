local pandoc = pandoc

function Header(elem)
	return pandoc.Strong(elem.content)
end
