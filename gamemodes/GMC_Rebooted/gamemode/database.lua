ExpMultiplier = 25

function DBInitialize() -- Do this when doing "GetSkill"? ( So that Skills_Server exsists ), seperate function called in GetSkill?
	if ( !sql.TableExists( "player_info" ) ) then
		sql.Query( "CREATE TABLE player_info ( account varchar( 255 ), password varchar( 255 ) )" )
	end

	if ( !sql.TableExists( "player_name" ) ) then
		sql.Query( "CREATE TABLE player_name ( account varchar( 255 ), name varchar( 255 ) )" )
	end

	if ( !sql.TableExists( "player_job" ) ) then
		sql.Query( "CREATE TABLE player_job ( account varchar( 255 ), job varchar( 255 ) )" )
	end

	if ( !sql.TableExists( "player_gold" ) ) then
		sql.Query( "CREATE TABLE player_gold ( account varchar( 255 ), gold varchar( 255 ) )" )
	end

	if Skills_Server then
		for k, v in pairs( Skills_Server ) do
			if not sql.TableExists( "player_"..v.Name ) then
				sql.Query( "CREATE TABLE player_"..v.Name.." ( account varchar( 255 ), exp varchar( 255 ), lvl varchar( 255 ) )" )
			end
		end
	end
end

function Login( ply, cmd, args )
	DBInitialize() -- Initialize database, just in case ( don't do in main init. as Skills_Server wont exist then. )

	local name = args[ 1 ]
	if ply.Account then
		if ply.Account == name then -- Already logged in to this account
			return
		else
			Logout( ply )
		end
	end

	for k, v in pairs( player.GetAll() ) do
		if v.Account then
			if string.lower( v.Account ) == string.lower( name ) then
				ply:PrintMessage( HUD_PRINTTALK, name.." is already in use." )
				return
			end
		end
	end

	local result = sql.Query( "SELECT password FROM player_info WHERE account = '"..name.."'" )
	if result then
		result = sql.QueryValue( "SELECT password FROM player_info WHERE account = '"..name.."'" )
		if result == args[ 2 ] then
			ply:PrintMessage( HUD_PRINTTALK, "Logging into "..name.."." )
			ply.Account = name

			Inventory_Load( ply )
			GetName( ply )
			GetJob( ply )
			GetGold( ply )

			if Skills_Server then -- GetSkill
				for k, v in pairs( Skills_Server ) do
					GetSkill( ply, v.Name )
					SetSkill( ply, v.Name, 0 ) -- Incase the exp multiplyer has changed... ( Temp. )
				end
			end
		else
			if ply:IsAdmin() then
				ply:PrintMessage( HUD_PRINTTALK, "Wrong Password for "..name..". ( Password is "..result.." not "..args[ 2 ].." )" )
			else
				ply:PrintMessage( HUD_PRINTTALK, "Wrong Password for "..name.."." )
			end
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "Account name "..name.." does not exsist." )
	end
end
concommand.Add( "gmc_login", Login )

function CreateAccount( ply, cmd, args )
	local name = args[ 1 ]
	local pass = args[ 2 ]
	if not name or not pass then
		ply:PrintMessage( HUD_PRINTTALK, "Please enter an account name and password into their respective text boxes.." )
		return
	end

	local result = sql.Query( "SELECT account FROM player_info WHERE account = '"..name.."'" )
	if result then
		ply:PrintMessage( HUD_PRINTTALK, "This account name is already taken." )
	else
		sql.Query( "INSERT INTO player_info ( `account`, `password` )VALUES ( '"..name.."', '"..pass.."' )" )
	end

	ply:ConCommand( "gmc_login "..name.." "..pass )
	GMC_WelcomeMessage( ply )
end
concommand.Add( "gmc_createaccount", CreateAccount )

function GMC_WelcomeMessage( ply )
	ply:PrintMessage( HUD_PRINTTALK, "Use F1 to open the main menu." )
	ply:PrintMessage( HUD_PRINTTALK, "Use F4 to open your backpack." )
	ply:PrintMessage( HUD_PRINTTALK, "Press use on objects, with your backpack weapon selected, to place them into your backpack." )
	if ply:IsAdmin() then
		ply:PrintMessage( HUD_PRINTTALK, "Use 'spawnpoint_create_mine' and 'spawnpoint_create_forest' to add resource spawners around the map," )
		ply:PrintMessage( HUD_PRINTTALK, "these save and will be loaded on map startup." )
		ply:PrintMessage( HUD_PRINTTALK, "To remove these stand near the green x representation and use 'spawnpoint_database_remove'." )
		ply:PrintMessage( HUD_PRINTTALK, "To toggle the green xs, type 'spawn_greenxs' into console." )
	end
end

function Logout( ply )
	ply:PrintMessage( HUD_PRINTTALK, "Logging out of "..ply.Account.."." )
	ply:StripWeapons()

	ply.Account = nil
	ply.Job = nil

	ply:SetTeam( 1 )
	ply:SetNWString( "name", "" )
	ply:SetNWInt( "gold", 0 )

	if Skills_Server then -- Reset skills.
		for k, v in pairs( Skills_Server ) do
			ply:SetNWInt( v.Name.."exp", 0 )
			ply:SetNWInt( v.Name.."lvl", 0 )
		end
	end
end
concommand.Add( "gmc_logout", Logout )

function GetName( ply )
	if not ply.Account then return end

	local result = sql.Query( "SELECT account FROM player_name WHERE account = '"..ply.Account.."'" )
	if result then
		result = sql.QueryValue( "SELECT name FROM player_name WHERE account = '"..ply.Account.."'" )
		ply:SetNWString( "name", result )
	else
		ply:SetNWString( "name", "" )
	end
end

function SetName( ply, cmd, args )
	if ply.Account then else return end

	local name = string.Implode( " ", args )
	local result = sql.Query( "SELECT account FROM player_name WHERE account = '"..ply.Account.."'" )
	if result then
		sql.Query( "UPDATE player_name SET name = '"..name.."' WHERE account = '"..ply.Account.."'" )
		ply:SetNWString( "name", name )
	else
		sql.Query( "INSERT INTO player_name ( `account`, `name` )VALUES ( '"..ply.Account.."', '"..name.."' )" )
		ply:SetNWString( "name", name )
	end
end
concommand.Add( "gmc_name", SetName )

function GetJob( ply )
	if not ply.Account then return end

	local result = sql.Query( "SELECT account FROM player_job WHERE account = '"..ply.Account.."'" )
	if result then
		result = sql.QueryValue( "SELECT job FROM player_job WHERE account = '"..ply.Account.."'" )
		ply:SetTeam( result )
		ply.Job = result
		GMC_GiveWeapons( ply )
	end
end

function SetJob( ply, args )
	if ply.Account then else return end

	local result = sql.Query( "SELECT account FROM player_job WHERE account = '"..ply.Account.."'" )
	if result then
		sql.Query( "UPDATE player_job SET job = "..args.." WHERE account = '"..ply.Account.."'" )
		ply.Job = args
		ply:SetTeam( args )
		GMC_GiveWeapons( ply )
	else
		sql.Query( "INSERT INTO player_job ( `account`, `job` )VALUES ( '"..ply.Account.."', '"..args.."' )" )
		ply.Job = args
		ply:SetTeam( args )
		GMC_GiveWeapons( ply )
	end
end

function GetSkill( ply, skill )
	if not ply.Account or not skill then return end

	local result = sql.Query( "SELECT account FROM player_"..skill.." WHERE account = '"..ply.Account.."'" )
	if result then
		result = sql.QueryValue( "SELECT exp FROM player_"..skill.." WHERE account = '"..ply.Account.."'" )
		ply:SetNWInt( skill.."exp", result )

		result = sql.QueryValue( "SELECT lvl FROM player_"..skill.." WHERE account = '"..ply.Account.."'" )
		ply:SetNWInt( skill.."lvl", result )
	else
		ply:SetNWInt( skill.."lvl", 1 )
	end

	return ply:GetNWInt( skill.."lvl" )
end

function SetSkill( ply, skill, exp )
	if not ply.Account or not skill or not exp then return end

	local lvl = ply:GetNWInt( skill.."lvl" )
	exp = exp + ply:GetNWInt( skill.."exp" )
	if exp > ( ExpMultiplier * ply:GetNWInt( skill.."lvl" ) ) then
		exp = exp - ( ExpMultiplier * ply:GetNWInt( skill.."lvl" ) )
		lvl = ply:GetNWInt( skill.."lvl" ) + 1
		GMC_Congradulate( ply, skill, lvl )
	end

	local result = sql.Query( "SELECT account FROM player_"..skill.." WHERE account = '"..ply.Account.."'" )
	if result then
		sql.Query( "UPDATE player_"..skill.." SET exp = "..exp.." WHERE account = '"..ply.Account.."'" )
		if lvl then sql.Query( "UPDATE player_"..skill.." SET lvl = "..lvl.." WHERE account = '"..ply.Account.."'" ) end
	else
		sql.Query( "INSERT INTO player_"..skill.." ( `account`, `exp`, `lvl` )VALUES ( '"..ply.Account.."', '"..exp.."', '"..lvl.."' )" )
	end

	ply:SetNWInt( skill.."exp", exp )
	if lvl then ply:SetNWInt( skill.."lvl", lvl ) end
end

function GetGold( ply )
	if not ply.Account then return end

	local result = sql.Query( "SELECT account FROM player_gold WHERE account = '"..ply.Account.."'" )
	if result then
		result = sql.QueryValue( "SELECT gold FROM player_gold WHERE account = '"..ply.Account.."'" )
		ply:SetNWInt( "gold", result )
	else
		ply:SetNWInt( "gold", 500 )
	end

	return ply:GetNWInt( "gold" )
end

function SetGold( ply, gold )
	if ply.Account then else return end

	local result = sql.Query( "SELECT account FROM player_gold WHERE account = '"..ply.Account.."'" )
	if result then
		sql.Query( "UPDATE player_gold SET gold = "..gold.." WHERE account = '"..ply.Account.."'" )
	else
		sql.Query( "INSERT INTO player_gold ( `account`, `gold` )VALUES ( '"..ply.Account.."', '"..gold.."' )" )
	end

	ply:SetNWInt( "gold", gold )
end

function Inventory_Save( ply )
	if not ply.Stored_Items then return end
	if not ply.Account then return end

	local dir = "GMC_Inventory/"..ply.Account..".txt"
	local inv = util.TableToKeyValues( ply.Stored_Items )

	file.Write( dir, inv )
end

function Inventory_Load( ply )
	if not ply.Account then return end

	local dir = "GMC_Inventory/"..ply.Account..".txt"
	local inv  = file.Read( dir, "DATA" )
		if not inv then return end
	inv = util.KeyValuesToTable( inv )

	ply.Stored_Items = {}
	for k, v in pairs( inv ) do
		Backpack_Give( ply, v.name, v.model, v.class, v.amount, true )
	end

	net.Start( "SendInventoryData" )
		net.WriteTable( ply.Stored_Items )
	net.Send( ply )
	--datastream.StreamToClients( ply, "SendInventoryData", ply.Stored_Items )
end

function GMC_Congradulate( ply, skill, level )
	local effect = EffectData()
		effect:SetEntity( ply )
		util.Effect( "levelup", effect )
	ply:EmitSound( "levelup.wav" )
	HintPlayer( ply, "Congratulations! You are now "..skill.." Level "..level.."!" )
end

--Spawns

Tablesize = 10000

function CreateSpawn_Forest( ply )
	if ply:IsAdmin() then else return end

	local trace = ply:GetEyeTrace()
	local spawnpoint = ents.Create( "gmc_spawner" )
	spawnpoint:SetPos( trace.HitPos )
	spawnpoint.Forest = "forest"
	spawnpoint:Spawn()
	SaveSpawns( spawnpoint )

	ply:PrintMessage( HUD_PRINTCONSOLE, "Created a new forest spawnpoint." )
end
concommand.Add( "spawnpoint_create_forest", CreateSpawn_Forest )

function CreateSpawn_Mine( ply )
	if ply:IsAdmin() then else return end

	local trace = ply:GetEyeTrace()
	local spawnpoint = ents.Create( "gmc_spawner" )
	spawnpoint:SetPos( trace.HitPos )
	spawnpoint.Forest = "mine"
	spawnpoint:Spawn()
	SaveSpawns( spawnpoint )

	ply:PrintMessage( HUD_PRINTCONSOLE, "Created a new GMC_Spawnpoint." )
end
concommand.Add( "spawnpoint_create_mine", CreateSpawn_Mine )

function GetSpawns()
	if not InitGMC_Spawnpoints then
		result = sql.Query( "SELECT number FROM gmc_spawnpoints WHERE toggle = '1'" )
		if ( result ) then -- Any spawnpoints?
			result = sql.Query( "SELECT number FROM gmc_spawnpoints WHERE map = '"..game.GetMap().."'" )
			if ( result ) then -- GMC_Spawnpoints for this map
				for i = 1, Tablesize do
					result = sql.Query( "SELECT x FROM gmc_spawnpoints WHERE number = '"..i.."'" )
						local x = sql.QueryValue( "SELECT x FROM gmc_spawnpoints WHERE number = '"..i.."'" )
						local y = sql.QueryValue( "SELECT y FROM gmc_spawnpoints WHERE number = '"..i.."'" )
						local z = sql.QueryValue( "SELECT z FROM gmc_spawnpoints WHERE number = '"..i.."'" )
						local map = sql.QueryValue( "SELECT map FROM gmc_spawnpoints WHERE number = '"..i.."'" )
						local on = sql.QueryValue( "SELECT toggle FROM gmc_spawnpoints WHERE number = '"..i.."'" )
						local forest = sql.QueryValue( "SELECT forest FROM gmc_spawnpoints WHERE number = '"..i.."'" )
					if ( result ) and game.GetMap() == map then
						if tonumber( on ) == 1 then
							local spawnpoint = ents.Create( "gmc_spawner" )
							spawnpoint:SetPos( Vector( x, y, z ) )
							spawnpoint.Forest = forest
							spawnpoint:Spawn()
						end
					elseif not result then
						Tablesize = i
						InitGMC_Spawnpoints = true
						break
					end
				end
			end
		end
		InitGMC_Spawnpoints = true
	end
end
hook.Add( "Think", "GetSpawns", GetSpawns )

function SaveSpawns( spawn )
	result = sql.Query( "SELECT number FROM gmc_spawnpoints WHERE toggle = '1'" )

	if ( result ) then else
		query = "CREATE TABLE gmc_spawnpoints ( number varchar( 255 ), x varchar( 255 ), y varchar( 255 ), z varchar( 255 ), map varchar( 255 ), toggle varchar( 255 ), forest varchar( 255 ) )"
		result = sql.Query( query )
	end

	Tablesize = Tablesize + 1
	for i = 1, Tablesize do
		local result = sql.Query( "SELECT x FROM gmc_spawnpoints WHERE number = '"..i.."'" )
		if not result then
			sql.Query( "INSERT INTO gmc_spawnpoints ( `number`, `x`, `y`, `z`, `map`, `toggle`, `forest` )VALUES ( '"..i.."', '"..spawn:GetPos().x.."', '"..spawn:GetPos().y.."', '"..spawn:GetPos().z.."', '"..game.GetMap().."', '1', '"..tostring( spawn.Forest ).."' )" )
			break
		end
	end
end

function RemoveSpawn( ply )
	if ply:IsAdmin() then else return end

	for k, v in pairs( ents.FindInSphere( ply:GetPos(), 50 ) ) do
		if v:GetClass() == "gmc_spawner" then
			result = sql.Query( "SELECT x FROM gmc_spawnpoints WHERE x = '"..v:GetPos().x.."'" )
			if ( result ) then
				for i = 1, Tablesize do
					local x = sql.QueryValue( "SELECT x FROM gmc_spawnpoints WHERE number = '"..i.."'" )
					local y = sql.QueryValue( "SELECT y FROM gmc_spawnpoints WHERE number = '"..i.."'" )
					local z = sql.QueryValue( "SELECT z FROM gmc_spawnpoints WHERE number = '"..i.."'" )
					local map = sql.QueryValue( "SELECT map FROM gmc_spawnpoints WHERE number = '"..i.."'" )
					if ( x and y and z and v:GetPos().x and v:GetPos().y and v:GetPos().z and map ) and math.floor( x ) == math.floor( v:GetPos().x ) and math.floor( y ) == math.floor( v:GetPos().y ) and math.floor( z ) == math.floor( v:GetPos().z ) and game.GetMap() == map then
						sql.Query( "UPDATE gmc_spawnpoints SET toggle = 0 WHERE number = '"..i.."'" )
						v:Remove()
						ply:PrintMessage( HUD_PRINTCONSOLE, "Removed GMC_Spawnpoint "..i.." from Database." )
						umsg.Start( "GMC_Spawnpoint_Table_Remove", ply )
							umsg.Long( x )
							umsg.Long( y )
							umsg.Long( z )
						umsg.End()
					end
				end
			end
		end
	end
end
concommand.Add( "spawnpoint_remove", RemoveSpawn )