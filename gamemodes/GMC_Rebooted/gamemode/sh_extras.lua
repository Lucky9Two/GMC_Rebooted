function GMC_Extras() -- Add extra lines in here...( Any of the spaces, I just put them together for neat-ness )
	-- AddRecipe_Lua( Furnace/Anvil/Workbench/Etc, Name, Model, Level, Weapon, Colour() )
		-- AddRecipeIngredient_Lua( RecipeName, ResourceName, Amount )


	Workbench_AddRecipe_Lua( "Plank", "models/props_debris/wood_board06a.mdl", "", "Log", 1, "", 0, "", 0, "", 0, 0, 1 )
	Workbench_AddRecipe_Lua( "Chair", "models/nova/chair_wood01.mdl", "chair", "Plank", 5, "Iron Nail", 7, "", 0, "", 0, 0, 5 )
	Workbench_AddRecipe_Lua( "Bench", "models/props/de_inferno/bench_wood.mdl", "", "Plank", 5, "Iron Nail", 15, "", 0, "", 0, 5, 10 )
	Workbench_AddRecipe_Lua( "Longbow", "models/aoc_weapon/w_longbow.mdl", "gmc_longbow", "Plank", 3, "", 0, "", 0, "", 0, 10, 20 )
	Workbench_AddRecipe_Lua( "Crossbow", "models/weapons/w_crossbow.mdl", "gmc_crossbow", "Plank", 5, "Iron Nail", 10, "", 0, "", 0, 15, 30 )
	Workbench_AddRecipe_Lua( "Shield", "models/nayrbarr/Shield/shield.mdl", "gmc_shield", "Plank", 5, "Iron Ore", 5, "Iron Nail", 3, "", 0, 20, 40 )
	
	
	
	
	
	Workbench_AddIngredient_Lua( "Log", "models/gmstranded/props/lumber.mdl", 1 )
	Workbench_AddIngredient_Lua( "Plank", "models/props_debris/wood_board06a.mdl", 1 )
	Workbench_AddIngredient_Lua( "Bronze Nail", "models/medieval/items/nail.mdl", 5 )
	Workbench_AddIngredient_Lua( "Iron Nail", "models/medieval/items/nail.mdl", 6 )
	Workbench_AddIngredient_Lua( "Steel Nail", "models/medieval/items/nail.mdl", 7 )
	
	
	
	
	
	Furnace_AddRecipe_Lua( "Bronze Bar", "models/nayrbarr/iron/iron.mdl", "Copper Ore", 1, "Tin Ore", 1, "", 0, "", 0, 0, 1, 238, 173, 14, 255 )
	Furnace_AddRecipe_Lua( "Iron Bar", "models/nayrbarr/iron/iron.mdl", "Iron Ore", 2, "", 0, "", 0, "", 0, 5, 10, 181, 181, 181, 255 )
	Furnace_AddRecipe_Lua( "Silver Bar", "models/nayrbarr/iron/iron.mdl", "Silver Ore", 2, "", 0, "", 0, "", 0, 10, 20, 255, 255, 255, 255 )
	Furnace_AddRecipe_Lua( "Steel Bar", "models/nayrbarr/iron/iron.mdl", "Iron Ore", 1, "Coal Ore", 2, "", 0, "", 0, 15, 30, 225, 225, 225, 255 )
	Furnace_AddRecipe_Lua( "Gold Bar", "models/nayrbarr/iron/iron.mdl", "Gold Ore", 2, "", 0, "", 0, "", 0, 20, 40, 255, 234, 50, 255 )
	Furnace_AddRecipe_Lua( "Mithril Bar", "models/nayrbarr/iron/iron.mdl", "Mithril Ore", 1, "Coal Ore", 4, "", 0, "", 0, 25, 50, 10, 67, 109, 255 )
	
	
	
	
	
	Furnace_AddIngredient_Lua( "Tin Ore", "models/midage/items/ore/ore.mdl", 9.5, 1, 0, 200, 200, 200, 255 ) -- 18:58 - PuRpLeHaZe: level 35 mining to mine mithril.
	Furnace_AddIngredient_Lua( "Copper Ore", "models/midage/items/ore/ore.mdl", 9.5, 1, 0, 238, 173, 14, 255 )
	Furnace_AddIngredient_Lua( "Iron Ore", "models/midage/items/ore/ore.mdl", 7, 2, 10, 73, 18, 0, 255 )
	Furnace_AddIngredient_Lua( "Silver Ore", "models/midage/items/ore/ore.mdl", 4, 3, 15, 255, 255, 255, 255 )
	Furnace_AddIngredient_Lua( "Coal Ore", "models/midage/items/ore/ore.mdl", 6, 3, 25, 81, 81, 81, 255 )
	Furnace_AddIngredient_Lua( "Gold Ore", "models/midage/items/ore/ore.mdl", 2, 4, 30, 255, 234, 50, 255 )
	Furnace_AddIngredient_Lua( "Mithril Ore", "models/midage/items/ore/ore.mdl", 4, 4, 35, 31, 96, 153, 255 )
	
	
	
	
	
	Anvil_AddRecipe_Lua( "Bronze Longsword", "models/weapons/w_sword.mdl", "gmc_longsword_bronze", "Bronze Bar", 2, "", 0, "", 0, "", 0, 0, 100, 238, 173, 14, 255 )
	Anvil_AddRecipe_Lua( "Iron Longsword", "models/weapons/w_sword.mdl", "gmc_longsword_iron", "Iron Bar", 2, "", 0, "", 0, "", 0, 5, 150, 181, 181, 181, 255 )
	Anvil_AddRecipe_Lua( "Silver Longsword", "models/weapons/w_sword.mdl", "gmc_longsword_silver", "Silver Bar", 2, "", 0, "", 0, "", 0, 10, 200, 255, 255, 255, 255 )
	Anvil_AddRecipe_Lua( "Steel Longsword", "models/weapons/w_sword.mdl", "gmc_longsword_steel", "Steel Bar", 2, "", 0, "", 0, "", 0, 15, 250, 225, 225, 225, 255 )
	Anvil_AddRecipe_Lua( "Gold Longsword", "models/weapons/w_sword.mdl", "gmc_longsword_gold", "Gold Bar", 2, "", 0, "", 0, "", 0, 20, 300, 255, 234, 50, 255 )
	Anvil_AddRecipe_Lua( "Mithril Longsword", "models/weapons/w_sword.mdl", "gmc_longsword_mithril", "Mithril Bar", 2, "", 0, "", 0, "", 0, 30, 350, 10, 67, 109, 255 )

	Anvil_AddRecipe_Lua( "Bronze Nail", "models/medieval/items/nail.mdl", "", "Bronze Bar", 1, "", 0, "", 0, "", 0, 0, 5, 238, 173, 14, 255, "phoenix_storms/gear" )
	Anvil_AddRecipe_Lua( "Iron Nail", "models/medieval/items/nail.mdl", "", "Iron Bar", 1, "", 0, "", 0, "", 0, 5, 6, 91, 91, 91, 255, "phoenix_storms/gear" )
	Anvil_AddRecipe_Lua( "Steel Nail", "models/medieval/items/nail.mdl", "", "Steel Bar", 1, "", 0, "", 0, "", 0, 15, 7, 181, 181, 181, 255, "phoenix_storms/gear" )
	
	
	
	
	
	-- Anvil Ingredients are furnace recipes ( the bars )
	
	
	
	
	
	Stove_AddRecipe_Lua( "Orange",
						{ "Fry" },
						false,
						1,
						function( ent )
							ent.Name = string.gsub( ent.Name, "Fried", "Frazzled" )
								ent:SetNWString( "name", ent.Name )
							ent:SetColor( 21, 21, 21, 255 )
						end,
						1,
						function( ent )
							ent.Name = string.gsub( ent.Name, "Burnt ", "" )
								ent:SetNWString( "name", ent.Name )
						end
						 )
	Stove_AddRecipe_Lua( "Egg",
						{ "Fry" },
						function( ent )
							ent:SetModel( "models/noobuss/egg.mdl" )
							ent:SetColor( 255, 255, 255, 102 )
						end,
						5,
						function( ent )
							ent:SetColor( 255, 255, 255, 255 )
						end,
						3,
						function( ent )
							ent:SetColor( 45, 45, 45, 255 )
						end
						 )
	Stove_AddRecipe_Lua( "Bacon",
						{ "Fry" },
						false,
						6,
						function( ent )
							ent:SetColor( 145, 78, 78, 255 )
						end,
						2,
						function( ent )
							ent:SetColor( 45, 45, 45, 255 )
						end
						 )
	
	
	
	
	
	AddBuilding( "Town Centre", "models/medieval/town_centre/centre.mdl", "Plank", 5, "Tin Ore", 5, "Steel Nail", 4, "", 0 )
	AddBuilding( "House 1", "models/medieval/house/small/onefloor.mdl", "Plank", 1, "Tin Ore", 2, "Bronze Nail", 1, "", 0 )
	AddBuilding( "House 2", "models/medieval/house/small/twofloors.mdl", "Plank", 2, "Tin Ore", 4, "Bronze Nail", 2, "", 0 )
	AddBuilding( "House 3", "models/medieval/house/medium/onefloor.mdl", "Plank", 2, "Tin Ore", 4, "Iron Nail", 2, "", 0 )
	AddBuilding( "House 4", "models/medieval/house/medium/twofloors.mdl", "Plank", 4, "Tin Ore", 6, "Iron Nail", 4, "", 0 )
	AddBuilding( "Church", "models/medieval/church/church.mdl", "Plank", 5, "Tin Ore", 5, "Steel Nail", 4, "", 0 )

	AddBuilding( "Smithy's Workshop", "models/medieval/buildings/blacksmith.mdl", "Log", 2, "Tin Ore", 4, "Iron Ore", 2, "", 0 )
	AddBuilding( "Craftsman's Workshop", "models/medieval/buildings/craftsman.mdl", "Log", 3, "Tin Ore", 6, "Iron Nail", 3, "", 0 )
	AddBuilding( "Farm", "models/medieval/buildings/farm.mdl", "Log", 3, "Tin Ore", 5, "Plank", 6, "Iron Nail", 3 )
	-- AddBuilding( "Market Stall", "models/medieval/buildings/market.mdl", "Log", 2, "Plank", 4, "Iron Nail", 3, "", 0 )

	AddBuilding( "Tower", "models/medieval/tower/tower.mdl", "Plank", 5, "Tin Ore", 5, "Iron Nail", 4, "", 0 )
	AddBuilding( "Medium Stairs", "models/medieval/wall/medium/stair.mdl", "Plank", 6, "Log", 13, "Tin Ore", 6, "", 0 )
	AddBuilding( "Medium Corner", "models/medieval/wall/medium/corner.mdl", "Plank", 3, "Log", 12, "Tin Ore", 6, "", 0 )
	AddBuilding( "Medium Wall", "models/medieval/wall/medium/wall.mdl", "Plank", 3, "Log", 11, "Tin Ore", 5, "", 0 )
	AddBuilding( "Small Corner", "models/medieval/wall/small/corner.mdl", "Plank", 1, "Log", 6, "", 0, "", 0 )
	AddBuilding( "Small Wall", "models/medieval/wall/small/wall.mdl", "Plank", 1, "Log", 5, "", 0, "", 0 )
	
	
	
	
	
	AddBuildingExtra( "Smithy's Workshop", "Furnace", "gmc_furnace", "models/medieval/items/furnace.mdl", -65, 200, 2, 0, 45, 0 )
	AddBuildingExtra( "Smithy's Workshop", "Anvil", "gmc_anvil", "models/nayrbarr/anvil/anvil.mdl", 73, 273, 3, 0, -7, 0 )

	AddBuildingExtra( "Craftsman's Workshop", "Workbench", "gmc_workbench", "models/props_c17/furnituretable003a.mdl", 95, -159, 150, 0, -45, 0 )
	AddBuildingExtra( "Craftsman's Workshop", "Workbench", "gmc_workbench", "models/props_c17/furnituretable003a.mdl", 0, -176, 151, 0, 89, 0 )
	AddBuildingExtra( "Craftsman's Workshop", "Workbench", "gmc_workbench", "models/props_c17/furnituretable003a.mdl", -92, -167, 150, 0, -121, 0 )

	AddBuildingExtra( "Farm", "Stove", "gmc_stove", "models/medieval/items/cooker.mdl", 196, -210, 8, 0, -90, 0 )
	AddBuildingExtra( "House 3", "Stove", "gmc_stove", "models/medieval/items/cooker.mdl", 88, -95, 4, 0, -90, 0 )
	AddBuildingExtra( "House 4", "Stove", "gmc_stove", "models/medieval/items/cooker.mdl", -103, -80, 3, 0, 180, 0 )
	AddBuildingExtra( "Craftsman's Workshop", "Stove", "gmc_stove", "models/medieval/items/cooker.mdl", -26, 144, 5, 0, 0, 0 )
	AddBuildingExtra( "Smithy's Workshop", "Stove", "gmc_stove", "models/medieval/items/cooker.mdl", 1, -63, 4, 0, -90, 0 )

	--AddBuildingExtra( "Farm", "Seed Chest", "gmc_chest", "models/medieval/items/chest.mdl", 72, -20, 8, 0, 0, 0 )
	
	
	
	
	
	Plant_Add_Lua( "Egg", "models/props_phx/misc/egg.mdl", "Bush", false, 5, true ) -- Temporary.
	Plant_Add_Lua( "Bacon", "models/noobuss/bacon.mdl", "Bush", false, 5, true ) -- Temporary.
	Plant_Add_Lua( "Orange", "models/props/cs_italy/orange.mdl", "Bush", false, 5, true )
	Plant_Add_Lua( "Potato", "models/props_phx/misc/potato.mdl", "Underground", "models/props/de_inferno/bushgreensmall.mdl", 5, true )
	Plant_Add_Lua( "Mushroom", "models/mushroom/karpassieni01.mdl", "Overground", false, 5, true )
	Plant_Add_Lua( "Weed", "models/props/de_inferno/fountain_bowl_p8.mdl", "Weed", false, 0, false )
	Plant_Add_Lua( "Nightshade", "models/props/de_inferno/fountain_bowl_p8.mdl", "Weed", false, 0, false )
	
	
	
	
	
	AddSkill( "Lumbering", "lumberjack" )
	AddSkill( "Mining", "miner" )
	AddSkill( "Smithing", "blacksmith" )
	AddSkill( "Masonry", "mason" )
	AddSkill( "Carpentry", "craftsman" )
	AddSkill( "Farming", "farmer" )
	
	
	
	
	
	-- Need more hints!
	AddHint( "General", true, "If you get stuck type 'gmc_stuck' in console." )
	AddHint( "Resources", true, "Increasing your mining and lumbering levels will allow you to gather resources faster." )
	AddHint( "Resources", true, "Nails are created by a Blacksmith, at a Smithy's Workshop." )
	AddHint( "Resources", true, "Planks are created by a Craftsman, at a Craftsman's Workshop" )
	AddHint( "Backpack", true, "To pickup some items you must have equip your backpack, hold shift, and then click use." )
	AddHint( "Backpack", true, "To pickup all items within range, equip the backpack and click use on the ground next to items." )
	AddHint( "Building", true, "To work on a building, equip your 'Building Hammer' and left click on the building you wish to build." )
	AddHint( "Building", true, "The best order to create buildings in is; Smithy's Workshop, Craftsman's Workshop, others." )
	AddHint( "Cooking", true, "To turn your Stove's fires on, click 'use' on it." )
	AddHint( "Farming", true, "To farm, drop a seed on the ground, then use primary fire with the 'Shovel' to plant it." )
	AddHint( "Farming", true, "Oranges can be hard to pickup, try standing on them, looking at them, then taking the backpack out and clicking use on them." )
end --								 Add extra lines in there ^
hook.Add( "InitPostEntity", "GMC_Extras", GMC_Extras )

-- "models/gm_forest/tree_commonlinden_1.mdl"
-- "models/gm_forest/tree_oak1.mdl"
-- "models/props_foliage/vrba1a.mdl"
-- "models/stromy/plum_1.mdl"
-- "models/cherokemodels/palmy/tree_big03.mdl"

------------------------------------------ Do not cross this line - Pretty please <3 ------------------------------------------



function Workbench_AddRecipe_Lua( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a )
	if not r then r = 255 end
	if not g then g = 255 end
	if not b then b = 255 end
	if not a then a = 255 end

	if CLIENT then
		Workbench_AddRecipe_Lua_Client( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price )
	end

	if SERVER then
		Workbench_AddRecipe_Lua_Server( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a )
	end
end

function Workbench_AddIngredient_Lua( name, model, price )
	if CLIENT then
		Workbench_AddIngredient_Lua_Client( name, model, price )
	end

	if SERVER then
		Workbench_AddIngredient_Lua_Server( name, model, price )
	end
end

function Furnace_AddRecipe_Lua( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a )
	if not r then r = 255 end
	if not g then g = 255 end
	if not b then b = 255 end
	if not a then a = 255 end

	if CLIENT then
		Furnace_AddRecipe_Lua_Client( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price )
	end

	if SERVER then
		Furnace_AddRecipe_Lua_Server( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a )
	end
end

function Furnace_AddIngredient_Lua( name, model, ratio, price, level, r, g, b, a )
	if CLIENT then
		Furnace_AddIngredient_Lua_Client( name, model, price, level )
	end

	if SERVER then
		Furnace_AddIngredient_Lua_Server( name, model, ratio, price, level, r, g, b, a )
	end
end

function Anvil_AddRecipe_Lua( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a, mat )
	if not r then r = 255 end
	if not g then g = 255 end
	if not b then b = 255 end
	if not a then a = 255 end
	if not mat then mat = "" end

	if CLIENT then
		Anvil_AddRecipe_Lua_Client( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price )
	end

	if SERVER then
		Anvil_AddRecipe_Lua_Server( name, model, weapon, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s, level, price, r, g, b, a, mat )
	end
end

function Stove_AddRecipe_Lua( name, types, pot, cook, docook, burn, doburn )
	if CLIENT then
		Stove_AddRecipe_Lua_Client( name, types, pot, cook, docook, burn, doburn )
	end

	if SERVER then
		Stove_AddRecipe_Lua_Server( name, types, pot, cook, docook, burn, doburn )
	end
end

function AddBuilding( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s )
	if CLIENT then
		AddBuilding_Client( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s )
	end

	if SERVER then
		AddBuilding_Server( name, model, resource1, resource1s, resource2, resource2s, resource3, resource3s, resource4, resource4s )
	end
end

function AddBuildingExtra( building, name, ent, model, x, y, z, ap, ay, ar )
	if CLIENT then
		AddBuildingExtra_Client( building, name, ent, model, x, y, z, ap, ay, ar )
	end

	if SERVER then
		AddBuildingExtra_Server( building, name, ent, model, x, y, z, ap, ay, ar )
	end
end

function Plant_Add_Lua( name, model, type, plantmodel, exp, food )
	if CLIENT then
		Plant_Add_Lua_Client( name, model, type, plantmodel, exp, food )
	end

	if SERVER then
		Plant_Add_Lua_Server( name, model, type, plantmodel, exp, food )
	end
end

function AddSkill( name, icon )
	if CLIENT then
		AddSkill_Client( name, icon )
	end

	if SERVER then
		AddSkill_Server( name, icon )
	end
end

function AddHint( cat, bool, text ) -- bool( -ean ) is whether or not it should show up on notices
	if CLIENT then
		AddHint_Client( cat, bool, text )
	end
end