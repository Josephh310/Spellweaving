local InterfaceUtilities = {}

function InterfaceUtilities.MultiplyUdim2(_udim: UDim2, multiplier: number)
	return UDim2.new(
		_udim.X.Scale * multiplier,
		_udim.X.Offset * multiplier,
		_udim.Y.Scale * multiplier,
		_udim.Y.Offset * multiplier
	)
end

function InterfaceUtilities.FormatWithCommas(num: number)
	local formatted = tostring(num)
	while true do
		local updated, count = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
		formatted = updated
		if count == 0 then
			break
		end
	end
	return formatted
end

function InterfaceUtilities.GetElementColorProperty(Element: GuiBase)
	if Element:IsA("ImageLabel") or Element:IsA("ImageButton") then 
		return "ImageColor3" 
	end
	return "BackgroundColor3"
end

function InterfaceUtilities.MultiplyColor3(_color3: Color3, multiplier: number)
	return Color3.new(
		_color3.R * multiplier,
		_color3.G * multiplier,
		_color3.B * multiplier
	)
end

return InterfaceUtilities