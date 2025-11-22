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

return InterfaceUtilities