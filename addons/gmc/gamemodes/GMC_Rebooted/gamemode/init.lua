TalkRange = 1000

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_backpack.lua" )
AddCSLuaFile( "cl_extras.lua" )
AddCSLuaFile( "cl_hints.lua" )
AddCSLuaFile( "cl_vgui.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_extras.lua" )

DeriveGamemode( "base" )

include( "backpack.lua" )
include( "database.lua" )
include( "extras.lua" )
include( "shared.lua" )

function GM:Think()
	for k, ply in pairs( player.GetAll() ) do
		if ply.GMC_LastHealth > ply:Health() then
			ply.GMC_LastHealth = ply:Health()
			OnPlayerTakeDamage( ply )
		end
	end

	for k, v in pairs( ents.FindByModel( "models/error.mdl" ) ) do
		print( "Taking the liberty of removing a "..v:GetClass().." which is displaying as an error." )
		v:Remove()
	end

	if PlayerCount() == 0 then -- Attempt at a cleanup script thingy when no players are in server ( Hard to test :P )
		local BlockedList = {}
			table.insert( BlockedList, "gmc_spawner" )
			table.insert( BlockedList, "gmc_tree" )
			table.insert( BlockedList, "gmc_tree_cut" )
			table.insert( BlockedList, "gmc_mine" )
		for k, v in pairs( ents.GetAll() ) do
			local blocked
				for _, i in pairs( BlockedList ) do
					if v:GetClass() == i then
						blocked = true
					end
				end
			if string.find( v:GetClass(), "gmc_" ) and not blocked then
				v:Remove()
			end
		end
	end
end

function PlayerCount()
	local count = 0
		for k, v in pairs( player.GetAll() ) do
			count = count + 1
		end
	return count
end

function OnPlayerTakeDamage( ply )
end

/*
function AddFolder( dir ) -- Taken from the lua wiki - http://wiki.garrysmod.com/?title=Resource.AddFile
	local list = file.FindDir( "../"..dir.."/*" )
	for _, fdir in pairs( list ) do
		if fdir != ".svn" then
			AddFolder( dir.."/"..fdir )
		end
	end

	for k,v in pairs( file.Find( "../"..dir.."/*" ) ) do
		resource.AddFile( dir.."/"..v )
	end
end
*/
	
function GM:Initialize()
	/*
	AddFolder( "gamemodes/GMC2/content" )
		-- -- Materials
		-- AddFolder( "materials/mixerman3d" )
		-- AddFolder( "materials/models/aoc_weapon" )
		-- AddFolder( "materials/models/aoc_weapons" )
		-- AddFolder( "materials/models/medieval" )
		-- AddFolder( "materials/models/midage" )
		-- -- Weapons
			-- AddFolder( "materials/models/weapons/pickaxe" )
			-- AddFolder( "materials/models/weapons/v_sword" )
			-- AddFolder( "materials/models/weapons/shovel" )
			-- -- Files
				-- resource.AddFile( "materials/models/weapons/axe.vtf" )
				-- resource.AddFile( "materials/models/weapons/sledge.vtf" )
				-- resource.AddFile( "materials/models/weapons/axe.vmt" )
				-- resource.AddFile( "materials/models/weapons/sledge.vmt" )
		-- AddFolder( "materials/nayrbarr" )
		-- -- Rain
			-- resource.AddFile( "materials/particle/rprain.vtf" )
			-- resource.AddFile( "materials/particle/rprain.vmt" )
		-- -- Jono's
			-- -- Stone
				-- resource.AddFile( "materials/stone/stonewall010a.vtf" )
				-- resource.AddFile( "materials/stone/stonewall010a.vmt" )
			-- -- Wood
				-- resource.AddFile( "materials/wood/milbeams002.vtf" )
				-- resource.AddFile( "materials/wood/milroof005.vtf" )
				-- resource.AddFile( "materials/wood/wood_halftimber004.vtf" )
				-- resource.AddFile( "materials/wood/woodwall004b.vtf" )
				-- resource.AddFile( "materials/wood/milbeams002.vmt" )
				-- resource.AddFile( "materials/wood/milroof005.vmt" )
				-- resource.AddFile( "materials/wood/wood_halftimber004.vmt" )
				-- resource.AddFile( "materials/wood/woodwall004b.vmt" )

	-- -- Models
		-- AddFolder( "models/aoc_weapon" )
		-- AddFolder( "models/gmstranded" )
		-- AddFolder( "models/medieval" )
		-- AddFolder( "models/midage" )
		-- AddFolder( "models/mixerman3d" )
		-- AddFolder( "models/nayrbarr" )
		-- -- Weapons
			-- AddFolder( "models/weapons/v_axe" )
			-- AddFolder( "models/weapons/v_sledgehammer" )
			-- AddFolder( "models/weapons/v_crossbow" )
			-- -- Files
				-- resource.AddFile( "models/weapons/v_gladius.mdl" )
				-- resource.AddFile( "models/weapons/w_gladius.mdl" )
				-- resource.AddFile( "models/weapons/v_stone_pickaxe.mdl" )
				-- resource.AddFile( "models/weapons/w_stone_pickaxe.mdl" )
				-- resource.AddFile( "models/weapons/v_sword.mdl" )
				-- resource.AddFile( "models/weapons/w_sword.mdl" )
				-- resource.AddFile( "models/weapons/v_shovel.mdl" )
				-- resource.AddFile( "models/weapons/w_shovel.mdl" )
				-- resource.AddFile( "models/weapons/w_axe.mdl" )
				-- resource.AddFile( "models/weapons/w_sledgehammer.mdl" )
				-- resource.AddFile( "models/weapons/crossbow.mdl" )

	-- -- Fonts
		-- resource.AddFile( "resource/fonts/Bleeding_Cowboys.ttf" )

	-- -- Sounds
		-- AddFolder( "sound/sword" )
		-- resource.AddFile( "sound/levelup.wav" )
	*/
end

function GM:PlayerSpawn( ply )
	self.BaseClass:PlayerSpawn( ply )
	ply.GMC_LastHealth = 100
	if not ply.Account then
		return false
	end
end 

function GM:PlayerLoadout( ply )
	GMC_GiveWeapons( ply )
end 

function GMC_GiveWeapons( ply )
	ply:StripWeapons()

	ply:Give( "gmc_hands" )
	ply:Give( "gmc_backpack" )

	if ply:Team() == 3 then -- Mason
		ply:Give( "gmc_build" )
		ply:Give( "gmc_position" )
		ply:Give( "gmc_demolish" )
	elseif ply:Team() == 4 then -- Miner
		ply:Give( "gmc_pickaxe" )
	elseif ply:Team() == 5 then -- Lumberjack
		ply:Give( "gmc_axe" )
	elseif ply:Team() == 10 then -- Farmer
		ply:Give( "gmc_shovel" )

		if Plants_Server then
			for k, v in pairs( Plants_Server ) do
				local name = v.Name.." Seed"
				if v.Type ~= "Weed" then
					Backpack_Give( ply, name, "models/medieval/items/seed.mdl", "gmc_seed" )
				end
			end
		end
	elseif ply:Team() == 11 then -- Cook
		Backpack_Give( ply, "Egg", "models/props_phx/misc/egg.mdl", "gmc_resource" )
		Backpack_Give( ply, "Bacon", "models/noobuss/bacon.mdl", "gmc_resource" )
		if not Backpack_HasItem( ply, "Frying Pan" ) then
			Backpack_Give( ply, "Frying Pan", "models/props_c17/metalPot002a.mdl", "gmc_fryingpan" )
		end
	end
end

function GM:ShowHelp( ply ) -- F1
	if ply.Account then
		umsg.Start( "MainMenu", ply )
		umsg.End()
	else
		umsg.Start( "LoginScreen", ply )
		umsg.End()
	end
end

function GM:ShowTeam( ply ) -- F2
	if ply.Account then
		if ply:Team() == 3 then
			umsg.Start( "BuildingMenu", ply )
			umsg.End()
		end
	else
		umsg.Start( "LoginScreen", ply )
		umsg.End()
	end
end

function GM:ShowSpare2( ply ) -- F4
	if ply.Account then
		umsg.Start( "BackpackMenu", ply )
		umsg.End()
	else
		umsg.Start( "LoginScreen", ply )
		umsg.End()
	end
end

function GM:KeyPress( ply, code )
	self.BaseClass:KeyPress( ply, code )

	if not ply.Account then
		umsg.Start( "LoginScreen", ply )
		umsg.End()
	end
end

function HintPlayer( ply, hint, texture )
	hint = TextConvert( hint )
	ply:PrintMessage( HUD_PRINTCONSOLE, hint )
	umsg.Start( "SendHint", ply )
		umsg.String( hint )
		if texture then
			umsg.Long( texture )
		else
			umsg.Long( 0 )
		end
	umsg.End()
end

function TextConvert( hint )
	local replacements = {
							-- { Word = "a", Replace = "some", Two = "a" }, 
							-- { Word = "a", Replace = "some", Two = "e" }, 
							-- { Word = "a", Replace = "some", Two = "i" }, 
							-- { Word = "a", Replace = "some", Two = "o" }, 
							-- { Word = "a", Replace = "some", Two = "u" },
							{ Word = "a", Replace = "an", Next = "a" }, 
							{ Word = "a", Replace = "an", Next = "e" }, 
							{ Word = "a", Replace = "an", Next = "i" }, 
							{ Word = "a", Replace = "an", Next = "o" }, 
							{ Word = "a", Replace = "an", Next = "u" }
						}
	local words = string.Explode( " ", hint )
		for k, v in pairs( words ) do
			for _, i in pairs( replacements ) do
				if v == i.Word then
					if i.Next and words[k+1] and i.Next == string.Left( string.lower( words[k+1] ), string.len( i.Next ) ) then -- Only count the letters of the length of 'Next', e.g. 'ab' only count first 2 letters.
						words[ k ] = i.Replace
					elseif i.Two and words[k+2] and i.Two == string.Left( string.lower( words[k+2] ), string.len( i.Two ) ) then
						words[ k ] = i.Replace
					elseif not i.Next and not i.Two then
						words[ k ] = i.Replace
					end
				end
			end
		end
	hint = string.Implode( " ", words )
	return hint
end

function Remove( ply )
	if ply:IsPlayer() and not ply:IsAdmin() then return end

	local tr = ply:GetEyeTrace()
	if not tr.Entity:IsPlayer() and tr.HitNonWorld then
		tr.Entity:Remove()
	end
end
concommand.Add( "gmc_remove", Remove )

-- Creation

function Class( ply, cmd, args )
	SetJob( ply, args[ 2 ] )
	HintPlayer( ply, "You are now a "..args[ 1 ], args[ 3 ] )
end
concommand.Add( "gmc_class", Class )

function GM:PlayerSay( ply, text )
	self.BaseClass:PlayerSay( ply, text )

	-- if ply:GetNWString( "name" ) == "" then
		-- return text
	-- elseif ply:GetNWString( "name" ) then
		-- return "( "..ply:GetNWString( "name" ).." ) "..text
	-- end

	if string.Left( text, 2 ) == "//" then -- Out of Character
		for k, v in pairs( player.GetAll() ) do
			text = string.Right( text, string.len( text ) - 2 ) -- Take off the //
			text = "(OOC) "..text
			umsg.Start( "SendChatMessage", v )
				umsg.Long( ply:Team() )
				umsg.String( ply:Nick() ) -- Steam Name
				local name = ply:GetNWString( "name" ) -- Roleplay Name
					if string.len( name ) >= 1 then
						umsg.String( name )
					else
						umsg.String( "" )
					end
				umsg.String( text ) -- Message
			umsg.End()
		end
	else
		for k, v in pairs( player.GetAll() ) do
			if v:GetPos():Distance( ply:GetPos() ) <= TalkRange then -- If player is in range
				umsg.Start( "SendChatMessage", v )
					umsg.Long( ply:Team() )
					umsg.String( ply:Nick() ) -- Steam Name
					local name = ply:GetNWString( "name" ) -- Roleplay Name
						if string.len( name ) >= 1 then
							umsg.String( name )
						else
							umsg.String( "" )
						end
					umsg.String( text ) -- Message
				umsg.End()
			end
		end
	end

	return ""
end

function GM:PlayerConnect( name, ip, sid, sid64 )
	print( "[GMCR] " .. name:Nick() .. " has connected.\n\tTheir SteamID is " .. name:SteamID() .. "\n\tTheir 64-bit SteamID is " .. name:SteamID64() )
end

function GM:PlayerAuthed( name, ip, sid, sid64 )
	print( "[GMCR] " .. name:Nick() .. " has been authenticated.\n\tTheir SteamID is " .. name:SteamID() .. "\n\tTheir 64-bit SteamID is " .. name:SteamID64() )
end

function GM:PlayerDisconnected( ply )
	self.BaseClass:PlayerDisconnected( name )
	print( "[GMCR] " .. name:Nick() .. " has disconnected.\n\tTheir SteamID is " .. name:SteamID() .. "\n\tTheir 64-bit SteamID is " .. name:SteamID64() )
end

function GM:PlayerSetModel( ply )
	ply:SetModel("models/player/group01/male_07.mdl")
end

---- Credits

-- Mine Veins, Ore models
--Midage Team

-- Bow/Crossbow
--Models - AOC Team
--Scripts - Omen

-- Arrow
--Mixerman3d

-- Original Idea
--Telepethi

-- Level up
--System - Matt
--Effect - Maw
--Sound - Primordiality ( http://www.freesound.org/samplesViewSingle.php?id=78822 )

-- Date system
--Script - Matt, Chralex112 and Drakehawke - www.chralex.net

-- Weather mod
--Script - Rick Dark, Fisheater, Chralex112, Matt

-- Day and Night system

local days = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }
local months = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }

local month
local day
local week
local year
local hour
local minute

if file.Exists( "date_data.txt", "DATA" ) then
	local OldDays = ( file.Read( "date_data.txt", "DATA" ) )
		year = OldDays[1]
		month = OldDays[2]
		week = OldDays[3]
		day = OldDays[4]
		hour = OldDays[5]
		minute = OldDays[6]
else
	minute = 0
	hour = 0
	day = 1
	week = 1
	month = 1
	year = math.random( 1000, 1100 ) -- 'High' Middle Ages were between the 11th century ( 1000 ) and the 13th century ( 1200 )
end

function ChangeClockTime()
	minute = minute + 1

	if minute == 60 then
		minute = 0
		hour = hour + 1
	end

	if hour == 24 then
		hour = 0
		day = day + 1
	end

	if day == 8 then
		day = 1
		week = week + 1
	end

	if week == 5 then
		week = 1
		month = month + 1

		for k, v in pairs( player.GetAll() ) do
			v:PrintMessage( HUD_PRINTTALK, "It is now "..months[ month ] )
		end
	end

	if month == 13 then
		month = 1
		year = year + 1
		for k, v in pairs( player.GetAll() ) do
			v:PrintMessage( HUD_PRINTTALK, "Happy New Year! It is now the year of our Lord "..year )
		end
	end

	UpdateDateAndTime()
end
timer.Create( "ClockTimer", 1, 0, ChangeClockTime )

-- function UpdateDateAndTime()
	-- file.Write( "date_data.txt", glon.encode( { year, month, week, day, hour, minute } ) )

	-- local month = months[ month ] or ""
	-- local day = days[ day ] or ""
	-- local year = year or ""
	-- local hour = hour or ""
	-- local minute = minute or ""

	-- umsg.Start( "DateAndClockUmsg", player.GetAll() )
		-- umsg.String( year )
		-- umsg.String( month )
		-- umsg.String( day )
		-- umsg.String( hour )
		-- umsg.String( minute )
	-- umsg.End()

	-- DayAndNight()
-- end

function UpdateDateAndTime()
	local month2 = months[ month ] or ""
	local day2 = days[ day ] or ""
	local year2 = year or ""
	local hour2 = hour or ""
	local minute2 = minute or ""

	net.Start( "DateAndClockUmsg" )
		net.WriteString( year2 )
		net.WriteString( month2 )
		net.WriteString( hour2 )
		net.WriteString( minute2 )
	net.Broadcast()
	--[[
	umsg.Start( "DateAndClockUmsg", player.GetAll() )
		umsg.String( year2 )
		umsg.String( month2 )
		umsg.String( day2 )
		umsg.String( hour2 )
		umsg.String( minute2 )
	umsg.End()
	file.Write( "date_data.txt", glon.encode( { year, month, week, day, hour, minute } ) )
--]]

	DayAndNight()
end

function DayAndNight()
	if hour >= 5 and hour <= 17 then -- Day
		if weather == "night" then
			SetWeather( "sunny" )
			weather = "day"
		elseif weather == "nightrain" then
			SetWeather( "sunnyrain" )
			weather = "dayrain"
		elseif not weather then
			SetWeather( "sunny" )
			weather = "day"
		end
	end

	if hour >= 18 or hour <= 4 then -- Night
		if weather == "day" then
			SetWeather( "dark" )
			weather = "night"
		elseif weather == "dayrain" then
			SetWeather( "darkrain" )
			weather = "nightrain"
		elseif not weather then
			SetWeather( "dark" )
			weather = "night"
		end
	end
	Rain()
end

function Rain()
	if math.random( 1, 120 ) == 3 then
		if weather == "day" then
			SetWeather( "sunnyrain" )
			weather = "dayrain"
		elseif weather == "night" then
			SetWeather( "darkrain" )
			weather = "nightrain"
		end
	elseif math.random( 1, 120 ) == 3 then
		if weather == "dayrain" then
			SetWeather( "sunny" )
			weather = "day"
		elseif weather == "nightrain" then
			SetWeather( "dark" )
			weather = "night"
		end
	end
end

--Serverside WeatherMod Stuff
--Modified By Fisheater
--Further modified by Chralex112 and Matt
--Thank you to Rick Dark for creating the original weathermod system!
/*
function SetWeather( weather )
	for k, v in pairs( player.GetAll() ) do
		datastream.StreamToClients( v, "SendWeather", weather )
	end

	print( weather )
end

function SetWeatherMod_WeatherCommand( ply, command, args )
	if not ply:IsAdmin() then return end
	if not args or not args[ 1 ] then return end

	for k, v in pairs( player.GetAll() ) do
		datastream.StreamToClients( v, "SendWeather", args[ 1 ] )
	end
	print( args[ 1 ] )
end
concommand.Add( "weather_select", SetWeatherMod_WeatherCommand )
*/
function GMC_AFK( ply )
	if not ply.Account then return end
	if ply.AFK then
		ply.AFK = false
		for k, v in pairs( player.GetAll() ) do
			if not v:IsBot() then
				v:PrintMessage( HUD_PRINTTALK, ply:Nick().." is no longer AFK." )
			end
		end
	else
		ply.AFK = true
		for k, v in pairs( player.GetAll() ) do
			if not v:IsBot() then
				v:PrintMessage( HUD_PRINTTALK, ply:Nick().." is now AFK." )
			end
		end
	end
end
concommand.Add( "gmc_afk", GMC_AFK )

function GMC_Stuck( ply )
	ply:SetPos( ply:GetPos() + Vector( 0, 0, 5 ) )
	ply.Stuck = true
end
concommand.Add( "gmc_stuck", GMC_Stuck )

function Unstick_Hook()
	for k, v in pairs( player.GetAll() ) do
		if v.AFK or v.Stuck then
			v.Stuck = UnStick( v )
		end
	end
end
hook.Add( "Think", "Unstick_Hook", Unstick_Hook )

function UnStick( ply )
	local spawned = false
	local radius = 28/2
	local min = ply:GetPos() - Vector( radius, radius, 148/2 )
	local max = ply:GetPos() + Vector( radius, radius, 148/2 )
	local add = 29
	local found = false
	for k, v in pairs( ents.FindInBox( min, max ) ) do
		if v ~= ply then
			if v:GetCollisionGroup() ~= COLLISION_GROUP_WORLD then
				if v:GetClass() ~= "physgun_beam" and v:GetClass() ~= "predicted_viewmodel" and not string.find( v:GetClass(), "func_" ) and not string.find( v:GetClass(), "env_" ) and not string.find( v:GetClass(), "info_" ) then
					if v:IsValid() and v:GetPhysicsObject():IsValid() and v:GetPhysicsObject():IsPenetrating( ply ) and v:GetClass() ~= "gmc_resource" and v:GetClass() ~= "gmc_ore" then
						found = true
					end
				end
			end
		end
	end

	if found then
		for u = 1, 4 do
			local spawn = ply:GetPos()
			add = u*29
			for i = 1, 6 do
				add = u*29
				if i == 1 then
					local add = ply:GetForward()*add
					min = min +add
					max = max +add
					spawn = spawn +add
				elseif i == 2 then
					local add = ply:GetForward()*-add
					min = min +add
					max = max +add
					spawn = spawn +add
				elseif i == 3 then
					local add = ply:GetRight()*add
					min = min +add
					max = max +add
					spawn = spawn +add
				elseif i == 4 then
					local add = ply:GetRight()*-add
					min = min +add
					max = max +add
					spawn = spawn +add
				elseif i == 5 then
					local add = ply:GetForward()*-add
					min = min +( ply:GetUp()*add )
					max = max +( ply:GetUp()*add )
					spawn = spawn +( ply:GetUp()*add )
					min = min +add
					max = max +add
					spawn = spawn +add
				else
					local add = ( ply:GetUp()*add )
					min = min +add
					max = max +add
					spawn = spawn +add
				end

				local found = false
				for k, v in pairs( ents.FindInBox( min, max ) ) do
					if v ~= ply then
						if v:GetCollisionGroup() ~= COLLISION_GROUP_WORLD then
							if v:GetClass() ~= "physgun_beam" and v:GetClass() ~= "predicted_viewmodel" and not string.find( v:GetClass(), "func_" ) and not string.find( v:GetClass(), "env_" ) and not string.find( v:GetClass(), "info_" ) then
								found = true
							end
						end
					end
				end

				if not found then
					ply:SetPos( spawn )
					return true
				end
			end
		end
	end
end

local PMeta = FindMetaTable( "Player" )
function PMeta:EyeTrace( distance, blocked )
	local pos = self:GetShootPos()
	local ang = self:GetAimVector()
	local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+( ang*distance )
		if blocked then
			local entfilter = {}
				for _, ent in pairs( ents.GetAll() ) do
					for k, v in pairs( blocked ) do
						if ent:GetClass() == v then
							table.insert( entfilter, ent )
						end
					end
				end
				table.insert( entfilter, self )
				table.insert( entfilter, "player" )
			tracedata.filter = entfilter
		else
			tracedata.filter = { self, "player" }
		end
	return util.TraceLine( tracedata )
end

function GMC_Permission( ply, cmd, args )
	local player1
	local player2
		for k, v in pairs( player.GetAll() ) do
			print( tonumber( v:EntIndex() ).." "..tonumber( args[ 1 ] ) )
			if args[ 1 ] and tonumber( v:EntIndex() ) == tonumber( args[ 1 ] ) then
				player1 = v
			end
			if args[ 2 ] and k == tonumber( args[ 2 ] ) then
				player2 = v
			end
		end
	local permission = args[ 3 ]
	if not player1 or not player2 or not permission then return end

	if not player1.Permissions then
		player1.Permissions = {}
	end

	local aremove, k = HasPermission( player2, permission, player1 )
	if aremove then -- Remove permission
		table.remove( player1.Permissions, k )
		net.Start( "SendPermissionData" )
			net.WriteString( player1.Permissions )
		net.Broadcast()
		--datastream.StreamToClients( player1, "SendPermissionData", player1.Permissions )

		HintPlayer( player1, player2:Nick().." ( "..player2:GetNWString( "name" ).." ) no longer has the permission: "..permission )
		HintPlayer( player2, player1:Nick().." ( "..player1:GetNWString( "name" ).." ) has taken away permission: "..permission )
	else -- Add permission
		table.insert( player1.Permissions, { Name = permission, Player = player2 } )
		net.Start( "SendPermissionData" )
			net.WriteString( player1.Permissions )
		net.Broadcast()
		--datastream.StreamToClients( player1, "SendPermissionData", player1.Permissions )

		HintPlayer( player1, player2:Nick().." ( "..player2:GetNWString( "name" ).." ) now has the permission: "..permission )
		HintPlayer( player2, player1:Nick().." ( "..player1:GetNWString( "name" ).." ) has given you permission: "..permission )
	end
end
concommand.Add( "GMC_Permission", GMC_Permission )

function HasPermission( ply, type, owner )
	if not ply or not type or not owner then return end
	if not owner.Permissions then return end -- No one has permission, stop here

	for k, v in pairs( owner.Permissions ) do
		if v.Player == ply and v.Name == type then
			return true, k
		end
	end
	return false
end

function Entity_OnGround( ent )
	if not ent then return end
	local tr
		local pos = ent:GetPos()
		local ang = Angle( 0, 0, -90 )
		local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+( ang*10 )
			tracedata.filter = ent
		tr = util.TraceLine( tracedata )
	if tr.HitWorld then
		return true, tr.HitPos
	end
	return false, tr.HitPos
end

function Entity_FindGround( ent )
	if not ent then return end
	local tr
		local pos = ent:GetPos()
		local ang = Angle( 0, 0, -90 )
		local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+( ang*1000000 )
			tracedata.filter = ent
		tr = util.TraceLine( tracedata )
	if tr.HitWorld then
		return tr.HitPos
	end
	return ent:GetPos() -- Just incase.
end

function Vector_FindGround( pos )
	if not pos then return end
	local tr
		local ang = Angle( 0, 0, -90 )
		local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos+( ang*1000000 )
		tr = util.TraceLine( tracedata )
	if tr.HitWorld then
		return tr.HitPos
	end
	return pos
end