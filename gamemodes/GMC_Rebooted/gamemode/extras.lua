function Stove_AddRecipe_Lua_Server( name, types, pot, cook, docook, burn, doburn )
	if !StoveRecipes_Server then
		StoveRecipes_Server = {}
	end

	table.insert( StoveRecipes_Server, { Name = name, Types = types, DoPot = pot, CookTime = cook, DoCook = docook, BurnTime = burn, DoBurn = doburn } )
end

function Anvil_AddRecipe_Lua_Server( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a, mat )
	if not r then r = 255 end
	if not g then g = 255 end
	if not b then b = 255 end
	if not a then a = 255 end

	if !AnvilItems_Server then
		AnvilItems_Server = {}
	end

	if mat then
		table.insert( AnvilItems_Server, { Name = name, Model = model, Weapon = weapon, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s, Level = level, Price = price, R = r, G = g, B = b, A = a, Material = mat } )
	else
		table.insert( AnvilItems_Server, { Name = name, Model = model, Weapon = weapon, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s, Level = level, Price = price, R = r, G = g, B = b, A = a } )
	end 
end

function Furnace_AddRecipe_Lua_Server( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a )
	if !FurnaceItems_Server then
		FurnaceItems_Server = {}
	end

	table.insert( FurnaceItems_Server, { Name = name, Model = model, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s, Level = level, Price = price, R = r, G = g, B = b, A = a } )
end

function Furnace_AddIngredient_Lua_Server( name, model, ratio, price, level, r, g, b, a )
	if !FurnaceIngredients_Server then
		FurnaceIngredients_Server = {}
	end

	table.insert( FurnaceIngredients_Server, { Name = name, Model = model, Ratio = ratio, Price = price, Level = level, R = r, G = g, B = b, A = a } )
end

function Workbench_AddRecipe_Lua_Server( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a )
	if not r then r = 255 end
	if not g then g = 255 end
	if not b then b = 255 end
	if not a then a = 255 end

	if !WorkbenchItems_Server then
		WorkbenchItems_Server = {}
	end

	table.insert( WorkbenchItems_Server, { Name = name, Model = model, Weapon = weapon, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s, Level = level, Price = price, R = r, G = g, B = b, A = a } )
end

function Workbench_AddIngredient_Lua_Server( name, model, price )
	if !WorkbenchIngredients_Server then
		WorkbenchIngredients_Server = {}
	end

	table.insert( WorkbenchIngredients_Server, { Name = name, Model = model, Price = price } )
end

function AddBuilding_Server( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s )
	if !GMC_Buildings then
		GMC_Buildings = {}
	end

	table.insert( GMC_Buildings, { Name = name, Model = model, Resource1 = resource1, Resource1s = resource1s, Resource2 = resource2, Resource2s = resource2s, Resource3 = resource3, Resource3s = resource3s, Resource4 = resource4, Resource4s = resource4s } )
end

function AddBuildingExtra_Server( building, name, ent, model, x, y, z, ap, ay, ar )
	if !GMC_BuildingExtras then
		GMC_BuildingExtras = {}
	end

	table.insert( GMC_BuildingExtras, { Building = building, Name = name, ENT = ent, Model = model, X = x, Y = y, Z = z, AP = ap, AY = ay, AR = ar } )
end

function Plant_Add_Lua_Server( name, model, type, plantmodel, exp, food )
	if !Plants_Server then
		Plants_Server = {}
	end

	table.insert( Plants_Server, { Name = name, Model = model, Type = type, PlantModel = plantmodel, Exp = exp, Food = food } )
end

function AddSkill_Server( name, icon )
	if !Skills_Server then
		Skills_Server = {}
	end

	table.insert( Skills_Server, { Name = name, Icon = icon } )
end

function ChairVehicles()
	for _, ent in pairs( ents.GetAll() ) do
		for k, v in pairs( WorkbenchItems_Server ) do
			if ent:GetNWString( "name" ) and v.Name == ent:GetNWString( "name" ) then
				if v.Weapon == "chair" then
					local nent = ents.Create( "prop_vehicle_prisoner_pod" )
						nent:SetKeyValue( "VehicleScript", "scripts/vehicles/prisoner_pod.txt" )
						nent:SetKeyValue( "LimitView", "0" )
					nent:SetModel( ent:GetModel() )
					nent:SetPos( ent:GetPos() )
					nent:SetAngles( ent:GetAngles() )
					nent.Name = v.Name
					nent:Spawn()
					nent.HandleAnimation = function() return ACT_GMOD_SIT_ROLLERCOASTER end
					local phys = nent:GetPhysicsObject()
						if phys and phys:IsValid() then
							phys:SetMass( 7 ) -- Hands pickup( -able )
						end
					ent:Remove()
				-- elseif v.Weapon ~= "" then
					-- local nent = ents.Create( ""..v.Weapon )
					-- nent:SetModel( ent:GetModel() )
					-- nent:SetPos( ent:GetPos() )
					-- nent:SetAngles( ent:GetAngles() )
					-- nent:Spawn()
					-- ent:Remove()
				end
			end
		end
	end
end
hook.Add( "Think", "ChairVehicles", ChairVehicles )

function CreateBluePrint( ply, cmd, args )
	local ent = ents.Create( "gmc_building" )
	ent.Building = args[ 1 ]
	ent:Spawn()
	ent:Activate()
	local tr
		local pos = ply:GetShootPos()
		local ang = ply:GetAimVector()
		local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+( ang*1000 )
			tracedata.filter = ply
		tr = util.TraceLine( tracedata )
	ent:SetPos( tr.HitPos )
	ent.Owner = ply

	if not Entity_OnGround( ent ) then -- Ensure building is on the ground.
		ent:SetPos( Entity_FindGround( ent ) )
	end

	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( HUD_PRINTCONSOLE, ply:Nick().." [ "..ply:SteamID().." ] spawned; "..ent.Building.." Blueprint" )
	end
end
concommand.Add( "gmc_blueprint", CreateBluePrint )

function CreateTree( ply )
	if ply:IsAdmin() then
		local ent = ents.Create( "gmc_tree" )
		ent:Spawn()
		ent:Activate()
		ent:SetPos( ply:GetEyeTrace().HitPos )
	end
end
concommand.Add( "gmc_tree", CreateTree )

function CreateMine( ply )
	if ply:IsAdmin() then
		local ent = ents.Create( "gmc_mine" )
		ent:Spawn()
		ent:Activate()
		ent:SetPos( ply:GetEyeTrace().HitPos )
	end
end
concommand.Add( "gmc_mine", CreateMine )

function CreateEnt( ply, cmd, args )
	if ply:IsAdmin() and args[ 1 ] then
		local ent = ents.Create( ""..tostring( args[ 1 ] ) )
		ent:Spawn()
		ent:Activate()
		ent:SetPos( ply:GetEyeTrace().HitPos )
	end
end
concommand.Add( "gmc_create", CreateEnt )