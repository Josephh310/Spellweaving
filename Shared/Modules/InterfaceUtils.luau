local InterfaceUtilities = {}

function InterfaceUtilities.MultiplyUdim2(_udim: UDim2, multiplier: number)
	return UDim2.new(
		_udim.X.Scale * multiplier,
		_udim.X.Offset * multiplier,
		_udim.Y.Scale * multiplier,
		_udim.Y.Offset * multiplier
	)
end

return InterfaceUtilities