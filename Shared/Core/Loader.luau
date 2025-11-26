local Loader = {}

function Loader.LoadDirectory(Directory: Instance, CurrentModules:{}?)
	if CurrentModules == nil then CurrentModules = {} end
	for _, NewDirectory in Directory:GetChildren() do
		if NewDirectory:IsA("ModuleScript") then
			local Source = require(NewDirectory)
			if typeof(Source) == "table" and Source.Enabled == false then
				warn(`{NewDirectory.Name} is disabled.`)
				continue
			end
			CurrentModules[NewDirectory.Name] = require(NewDirectory)
		else
			Loader.LoadDirectory(NewDirectory, CurrentModules)
		end
	end
	return CurrentModules
end

function Loader.BatchCall(Modules: {}, FunctionName: string, NewThread: boolean)
	for NameOrIndex, Module in Modules do
		if typeof(Module)=="Instance" and Module:IsA("ModuleScript") then
			Module = require(Module)
		end
		if not Module[FunctionName] then 
			continue; 
		end
		if NewThread == true then
			task.spawn(function()
				Module[FunctionName](Module, NameOrIndex)
			end)
		else
			Module[FunctionName](Module, NameOrIndex)
		end
	end
end

return Loader