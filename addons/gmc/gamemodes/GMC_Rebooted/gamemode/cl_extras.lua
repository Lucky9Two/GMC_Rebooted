function GMC_Extras_Client()
	AddClass( "Craftsman", "craftsman", 2, 0 )
	AddClass( "Mason", "mason", 3, 0 )
	AddClass( "Miner", "miner", 4, 0 )
	AddClass( "Lumberjack", "lumberjack", 5, 0 )
	AddClass( "Soldier", "soldier", 6, 0 )
	AddClass( "Monk", "alchemy", 7, 0 )
	AddClass( "Blacksmith", "blacksmith", 8, 0 )
	AddClass( "Merchant", "merchant", 9, 0 )
	AddClass( "Farmer", "farmer", 10, 0 )
	AddClass( "Cook", "cook", 11, 0 )
end
hook.Add( "InitPostEntity", "GMC_Extras_Client", GMC_Extras_Client )

function Stove_AddRecipe_Lua_Client( name, types, pot, cook, docook, burn, doburn )
	if !StoveRecipes_Client then
		StoveRecipes_Client = {}
	end

	table.insert( StoveRecipes_Client, { Name = name, Types = types, DoPot = pot, CookTime = cook, DoCook = docook, BurnTime = burn, DoBurn = doburn } )
end

function Anvil_AddRecipe_Lua_Client( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price )
	if !AnvilItems_Client then
		AnvilItems_Client = {}
	end

	table.insert( AnvilItems_Client, { Name = name, Model = model, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s, Level = level, Price = price } )
end

function Furnace_AddRecipe_Lua_Client( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price )
	if !FurnaceItems_Client then
		FurnaceItems_Client = {}
	end

	table.insert( FurnaceItems_Client, { Name = name, Model = model, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s, Level = level, Price = price } )
end

function Furnace_AddIngredient_Lua_Client( name, model, price, level )
	if !FurnaceIngredients_Client then
		FurnaceIngredients_Client = {}
	end

	table.insert( FurnaceIngredients_Client, { Name = name, Model = model, Price = price, Level = level } )
end

function Workbench_AddRecipe_Lua_Client( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price )
	if !WorkbenchItems_Client then
		WorkbenchItems_Client = {}
	end

	table.insert( WorkbenchItems_Client, { Name = name, Model = model, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s, Level = level, Price = price } )
end

function Workbench_AddIngredient_Lua_Client( name, model, price )
	if !WorkbenchIngredients_Client then
		WorkbenchIngredients_Client = {}
	end

	table.insert( WorkbenchIngredients_Client, { Name = name, Model = model, Price = price } )
end

function AddBuilding_Client( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s )
	if !CBuildings then
		CBuildings = {}
	end

	table.insert( CBuildings, { Name = name, Model = model, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s } )
end

function AddBuildingExtra_Client( building, name, ent, model, x, y, z, ap, ay, ar )
	if !CBuildingExtras then
		CBuildingExtras = {}
	end

	table.insert( CBuildingExtras, { Building = building, Name = name, ENT = ent, Model = model, X = x, Y = y, Z = z, AP = ap, AY = ay, AR = ar } )
end

function Plant_Add_Lua_Client( name, model, type, plantmodel, exp, food )
	if !Plants_Client then
		Plants_Client = {}
	end

	table.insert( Plants_Client, { Name = name, Model = model, Type = type, PlantModel = plantmodel, Exp = exp, Food = food } )
end

function AddSkill_Client( name, icon )
	if !Skills_Client then
		Skills_Client = {}
	end

	table.insert( Skills_Client, { Name = name, Icon = icon } )
end

function AddClass( name, model, number, notice )
	if !Classes then
		Classes = {}
	end

	table.insert( Classes, { Name = name, Model = model, Number = number, Notice = notice } )
end