function Backpack_UseHook( ply, code )
	if not Backpack_Blocked_Items then
		Backpack_InitializeTables()
	end

	if code == IN_USE then
		-- local tr = ply:GetEyeTrace()
		-- ply:PrintMessage( HUD_PRINTTALK, "Clicked use." )
		-- if tr.HitNonWorld then
			-- ply:PrintMessage( HUD_PRINTTALK, "Clicked on a "..tostring( tr.Entity:GetClass() ) )
		-- end
		-- if tr.HitNonWorld and tr.Entity:IsPlayer() and tr.HitPos:Distance( ply:GetPos() ) < 100 then
			-- ply:PrintMessage( HUD_PRINTTALK, "Entity is player." )
			-- if ply.Trade_AcceptTime and ply.Trade_AcceptTime < CurTime() and ply.Trade_Trader and ply.Trade_Trader == tr.Entity then
				-- ply:PrintMessage( HUD_PRINTTALK, "Trading." )
				-- umsg.Start( "PlayerTrade", ply )
					-- umsg.Long( tr.Entity:EntIndex() )
				-- umsg.End()
			-- else
				-- ply:PrintMessage( HUD_PRINTTALK, "Trade request sent." )
				-- HintMessage( tr.Entity, ply:Nick().." ( "..ply:GetNWString( "name" ).." ) wants to trade!" )
				-- tr.Entity:PrintMessage( HUD_PRINTTALK, "Press use on them to accept trade." )
				-- tr.Entity.Trade_AcceptTime = CurTime()+60
				-- tr.Entity.Trade_Trader = ply
			-- end
		-- end
		local tr = ply:GetEyeTrace( 100, Backpack_Blocked_Items )
		if ply:GetActiveWeapon() and ply:GetActiveWeapon() == ply:GetWeapon( "gmc_backpack" ) then
			if tr.HitNonWorld then
				if not tr.Entity.DisableBackpackable and not tr.Entity.ShiftUse or ( tr.Entity.ShiftUse and ply:KeyDown( IN_SPEED ) ) then
					Backpack_Pickup( ply, tr.Entity )
				end
			else
				for k, v in pairs( ents.FindInSphere( tr.HitPos, 30 ) ) do -- Attempt to pickup all entities in range
					if not v.DisableBackpackable and not v.ShiftUse or ( v.ShiftUse and ply:KeyDown( IN_SPEED ) ) then
						Backpack_Pickup( ply, v )
					end
				end
			end
		end
	end
end
hook.Add( "KeyPress", "Backpack_UseHook", Backpack_UseHook )

function Backpack_InitializeTables()
	Backpack_Blocked_Items = {}
		table.insert( Backpack_Blocked_Items, "gmc_anvil" )
		table.insert( Backpack_Blocked_Items, "gmc_arrow" )
		table.insert( Backpack_Blocked_Items, "gmc_bolt" )
		table.insert( Backpack_Blocked_Items, "gmc_building" )
		table.insert( Backpack_Blocked_Items, "gmc_building_gate" )
		table.insert( Backpack_Blocked_Items, "gmc_chest" )
		table.insert( Backpack_Blocked_Items, "gmc_fire" )
		table.insert( Backpack_Blocked_Items, "gmc_furnace" )
		table.insert( Backpack_Blocked_Items, "gmc_mine" )
		table.insert( Backpack_Blocked_Items, "gmc_plant" )
		table.insert( Backpack_Blocked_Items, "gmc_plant_bush" )
		table.insert( Backpack_Blocked_Items, "gmc_plant_underground" )
		table.insert( Backpack_Blocked_Items, "gmc_spawner" )
		table.insert( Backpack_Blocked_Items, "gmc_stove" )
		table.insert( Backpack_Blocked_Items, "gmc_tree" )
		table.insert( Backpack_Blocked_Items, "gmc_tree_cut" )
		table.insert( Backpack_Blocked_Items, "gmc_workbench" )
	Backpack_Allowed_Items = {}
		--table.insert( Backpack_Allowed_Items, "prop_physics" )
		table.insert( Backpack_Allowed_Items, "gmc_" )
end

function Backpack_Pickup( ply, ent )
	if not Backpack_Blocked_Items then
		Backpack_InitializeTables()
	end

	local allowed
		for i = 1, #Backpack_Blocked_Items do
			if ent:GetClass() == Backpack_Blocked_Items[ i ] or ent:GetModel() == Backpack_Blocked_Items[ i ] or ent.BackpackDisallowed then return end
		end
		for i = 1, #Backpack_Allowed_Items do
			if string.find( ent:GetClass(), Backpack_Allowed_Items[ i ] ) then
				allowed = true
			end
		end
	if not allowed then return end

	if ent:IsPlayer() or ent:IsNPC() or ent:IsWeapon() then return end

	local name = ent:GetNWString( "name" )
		if not name or name == "" then
			name = "Item"
		end
	local model = ent:GetModel()
	local class = ent:GetClass()
	ent:Remove()

	return Backpack_Give( ply, name, model, class )
end

function Backpack_Give( ply, name, model, class, amount, nomessage )
	if not amount then
		amount = 1
	end
	amount = tonumber( amount )

	if not nomessage then
		if amount > 1 then
			HintPlayer( ply, "Picked up "..amount.." "..name.."s." )
		else
			HintPlayer( ply, "Picked up a "..name.."." )
		end
	end

	class = string.gsub( class, "gmc", "@" ) -- Convert... Can't remember why... Something doesn't like the "gmc_" bit apparently :P
	if not ply.Stored_Items then
		ply.Stored_Items = {}
	end

	for k, v in pairs( ply.Stored_Items ) do
		if v.Name == name and v.Model == model and v.Class == class then
			v.Amount = v.Amount + amount
			net.Start( "SendInventoryData" )
				net.WriteTable( ply.Stored_Items )
			net.Send( ply )
			--datastream.StreamToClients( ply, "SendInventoryData", ply.Stored_Items )
			Inventory_Save( ply )
			return true
		end
	end

	table.insert( ply.Stored_Items, { Name = name, Model = model, Class = class, Amount = amount } )
	net.Start( "SendInventoryData" )
		net.WriteTable( ply.Stored_Items )
	net.Send( ply )
	--datastream.StreamToClients( ply, "SendInventoryData", ply.Stored_Items )
	Inventory_Save( ply )
	return true
end

function Backpack_DropCommand( ply, cmd, args )
	local number = tonumber( args[ 1 ] )
	local amount = tonumber( args[ 2 ] )
		if not amount then amount = 1 end
	for k, v in pairs( ply.Stored_Items ) do
		if tonumber( k ) == number then
			Backpack_SpawnItem( ply, v.Name, v.Class, v.Model, amount )
			Backpack_Take( ply, number, amount )
		end
	end
end
concommand.Add( "Backpack_Dropitem", Backpack_DropCommand )

function Backpack_GiveCommand( ply, cmd, args )
	local index = tonumber( args[ 1 ] )
	local number = tonumber( args[ 2 ] )
	local amount = tonumber( args[ 3 ] )
		if not amount then amount = 1 end
	local trader
		for k,v in pairs( player.GetAll() ) do
			if v:EntIndex() == index then
				trader = v
			end
		end
	if not index or not number or not amount or not trader then return end

	for k, v in pairs( ply.Stored_Items ) do
		if tonumber( k ) == number then
			-- Check if person has resources to give!
			Backpack_Give( trader, v.Name, v.Model, v.Class, amount, true )
			Backpack_Take( ply, number, amount )
			HintPlayer( ply, "Gave "..trader:Nick().." ( "..trader:GetNWString( "name" ).." ) "..amount.." "..v.Name.."( s )." )
			HintPlayer( trader, "Recieved "..amount.." "..v.Name.."( s ) from "..trader:Nick().." ( "..trader:GetNWString( "name" ).." )" )
		end
	end
end
concommand.Add( "Backpack_Giveitem", Backpack_GiveCommand )

function Backpack_SpawnItem( ply, name, class, model, amount )
	if not amount then amount = 1 end -- Default amount.
	local ent
	local atable = {}
		table.Add( atable, AnvilItems_Server )
		table.Add( atable, FurnaceItems_Server )
		table.Add( atable, FurnaceIngredients_Server )
		table.Add( atable, WorkbenchItems_Server )
		table.Add( atable, WorkbenchIngredients_Server )
		table.Add( atable, FishingFish_Server )
		table.Add( atable, Plants_Server )
	for i = 1, amount do
		ent = ents.Create( ""..string.gsub( class, "@", "gmc" ) )
		for k, v in pairs( atable ) do
			local fakename = name
				fakename = string.gsub( fakename, "Fried ", "" )
				fakename = string.gsub( fakename, "Burnt ", "" )
				fakename = string.gsub( fakename, "Cooked ", "" )
			print( v.Name.." "..fakename )
			if v.Name and v.Name == fakename then
				ent:SetModel( v.Model )

				if v.R then
					ent:SetColor( v.R, v.G, v.B, v.A )
				end
				if v.Material then
					ent:SetMaterial( v.Material )
				end
				if v.Weapon then
					ent.Weapon = v.Weapon
				end
				if v.Food then
					ent.Food = true
					for _, i in pairs( StoveRecipes_Server ) do
						if i.Name == v.Name then
							print( name )
							if string.find( name, "Fried" ) or string.find( name, "Cooked" ) then
								i.DoCook( ent )
							elseif string.find( name, "Burnt" ) then
								print( "Burning." )
								i.DoBurn( ent )
							end
						end
					end
				end
			end
		end
		-- For props, or other entities which aren't in 'atable'
			if model then
				ent:SetModel( model )
			end
		ent:SetNWString( "name", name )
		ent.Name = name
		ent.Owner = ply
		ent.Allowed = true
		local tr
			local pos = ply:GetShootPos()
			local ang = ply:GetAimVector()
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+( ang*80 )
			tracedata.filter = ply
			tr = util.TraceLine( tracedata )
		ent:SetPos( tr.HitPos + Vector( 0, 0, 50 ) )
		ent:Spawn()
	end
	return ent
end

function Backpack_DestroyCommand( ply, cmd, args )
	local number = tonumber( args[ 1 ] )
	local amount = tonumber( args[ 2 ] )
	for k, v in pairs( ply.Stored_Items ) do
		if tonumber( k ) == number then
			if amount then
				Backpack_Take( ply, k, amount )
			else
				Backpack_Take( ply, k, v.Amount )
			end
		end
	end
end
concommand.Add( "Backpack_Destroyitem", Backpack_DestroyCommand )

function Backpack_TakeCommand( ply, cmd, args ) -- Used in the building hammer
	Backpack_Take( ply, args[ 1 ], args[ 2 ] )
end
concommand.Add( "Backpack_Takeitem", Backpack_TakeCommand )

function Backpack_Take( ply, number, amount )
	if not ply.Stored_Items then return end
	if not amount then amount = 1 end
		amount = tonumber( amount )
		number = tonumber( number )

	for k, v in pairs( ply.Stored_Items ) do
		if k == number then
			v.Amount = v.Amount - amount
		end
		if v.Amount <= 0 then
			table.remove( ply.Stored_Items, k )
		end
	end

	net.Start( "SendInventoryData" )
		net.WriteTable( ply.Stored_Items )
	net.Send( ply )
	--datastream.StreamToClients( ply, "SendInventoryData", ply.Stored_Items )
	Inventory_Save( ply )
	return removed
end

function Backpack_HasItem( ply, item ) -- Used in anvil, etc
	if not ply.Stored_Items or not item then return end

	for k, v in pairs( ply.Stored_Items ) do
		if string.lower( tostring( v.Name ) ) == string.lower( tostring( item ) ) then
			return k, v.Amount
		end
	end
	return false
end