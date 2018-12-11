
--surface.CreateFont( "Bleeding Cowboys", ScreenScale( 20 ), 400, true, false, "Medieval" )
surface.CreateFont(	"Medieval", {	size = ScreenScale(8),	weight = 400,	antialias = true,	shadow = true, outline = false,	font = "Charlemagne Std"})

WeatherType = "sunny"

include( "cl_backpack.lua" )
include( "cl_extras.lua" )
include( "cl_hints.lua" )
include( "cl_vgui.lua" )
include( "shared.lua" )

local _P = LocalPlayer()
DeriveGamemode( "base" )

function GM:HUDPaint()
	local tr = LocalPlayer():GetEyeTrace()
	if tr.HitNonWorld then
		if tr.Entity:IsPlayer() then
			local info = tr.Entity:Nick()
				if tr.Entity:GetNWString( "name" ) then
					info = info.." ( "..tr.Entity:GetNWString( "name" ).." )\n"
				end
				info = info..tr.Entity:Health()
			local colour = Color( 255, 255, 255, 200 )
				if LocalPlayer().TeamColour then
					colour = team.GetColor( tr.Entity:Team() )
				end
			draw.DrawText( info, "Medieval", ( ScrW()/2 ) + 1, ( ScrH()/2 ) + 1, Color( 0, 0, 0, 200 ), 1 )
			draw.DrawText( info, "Medieval", ( ScrW()/2 ), ( ScrH()/2 ), colour, 1 )
		end

		if tr.Entity:GetPos():Distance( LocalPlayer():GetPos() ) < 1000 then
			if tr.Entity:GetClass() == "gmc_building_gate" then
				if not LocalPlayer().DontDrawOwner and LocalPlayer():KeyDown( IN_SPEED ) then
					local info = "Gate"
						if tr.Entity:GetNWString( "name" ) and tr.Entity:GetNWString( "name" ) ~= "" then
							info = tr.Entity:GetNWString( "name" ).."'s Gate"
						end
					draw.DrawText( info, "Medieval", ( ScrW()/2 ) + 1, ( ScrH()/2 ) + 1, Color( 0, 0, 0, 200 ), 1 )
					draw.DrawText( info, "Medieval", ( ScrW()/2 ), ( ScrH()/2 ), Color( 255, 255, 255, 200 ), 1 )
				end
			elseif tr.Entity:GetClass() == "gmc_building" then
				local info
					if not LocalPlayer().DontDrawOwner and LocalPlayer():KeyDown( IN_SPEED ) then
						info = "Building"
							local occur = 0
							for k, v in pairs( CBuildings ) do -- Get specific building name
								if tr.Entity:GetModel() == v.Model then
									info = v.Name
									occur = occur + 1
								end
							end
							if occur > 1 then -- Incase two building types have the same model, in which case it may have returned the wrong name
								info = "Building"
							end
						if tr.Entity:GetNWString( "name" ) and tr.Entity:GetNWString( "name" ) ~= "" then
							info = tr.Entity:GetNWString( "name" ).."'s "..info
						end
					end

					if not LocalPlayer().DontDrawResources and tr.Entity:GetNWInt( "building" ) < 10 then
						local Building = LocalPlayer():GetNWEntity( "Building", LocalPlayer() )
						if Building == LocalPlayer() then
							for k, v in pairs( CBuildings ) do
								if v.Model == tr.Entity:GetModel() then
									if info then
										info = info.."\n"
									else
										info = ""
									end
									info = info.."Building Completion: "..tr.Entity:GetNWInt( "building" ).."/10".."\n".."Required resources:"
										if v.Resource1 ~= "" and tr.Entity:GetNWInt( "res1" ) < v.Resource1s then
											info = info.."\n"..v.Resource1..": "..tr.Entity:GetNWInt( "res1" ).."/"..v.Resource1s.." ( "..Backpack_GetCount( v.Resource1 ).." )"
										end
										if v.Resource2 ~= "" and tr.Entity:GetNWInt( "res2" ) < v.Resource2s then
											info = info.."\n"..v.Resource2..": "..tr.Entity:GetNWInt( "res2" ).."/"..v.Resource2s.." ( "..Backpack_GetCount( v.Resource2 ).." )"
										end
										if v.Resource3 ~= "" and tr.Entity:GetNWInt( "res3" ) < v.Resource3s then
											info = info.."\n"..v.Resource3..": "..tr.Entity:GetNWInt( "res3" ).."/"..v.Resource3s.." ( "..Backpack_GetCount( v.Resource3 ).." )"
										end
										if v.Resource4 ~= "" and tr.Entity:GetNWInt( "res4" ) < v.Resource4s then
											info = info.."\n"..v.Resource4..": "..tr.Entity:GetNWInt( "res4" ).."/"..v.Resource4s.." ( "..Backpack_GetCount( v.Resource4 ).." )"
										end
								end
							end
						end
					end

				if info then
					draw.DrawText( info, "Medieval", ( ScrW()/2 ) + 1, ( ScrH()/2 ) + 1, Color( 0, 0, 0, 200 ), 1 )
					draw.DrawText( info, "Medieval", ( ScrW()/2 ), ( ScrH()/2 ), Color( 255, 255, 255, 200 ), 1 )
				end
			elseif LocalPlayer():KeyDown( IN_SPEED ) and tr.Entity and tr.Entity:GetPos():Distance( LocalPlayer():GetPos() ) < 150 and tr.Entity:GetNWString( "name" ) then
				local info = tr.Entity:GetNWString( "name" )
				draw.DrawText( info, "Medieval", ( ScrW()/2 ) + 1, ( ScrH()/2 ) + 1, Color( 0, 0, 0, 200 ), 1 )
				draw.DrawText( info, "Medieval", ( ScrW()/2 ), ( ScrH()/2 ), Color( 255, 255, 255, 200 ), 1 )
			end
		end
	end

	GAMEMODE:PaintNotes()
end

-- Notices

function SendHint( msg )
	GAMEMODE:AddNotify( msg:ReadString(), msg:ReadLong(), 5 )
end
usermessage.Hook( "SendHint", SendHint )

NOTIFY_GENERIC			 = 0
NOTIFY_ERROR			 = 1
NOTIFY_UNDO				 = 2
NOTIFY_HINT				 = 3
NOTIFY_CLEANUP			 = 4

local NoticeMaterial = {}
NoticeMaterial[ NOTIFY_GENERIC ] 	 = surface.GetTextureID( "vgui/notices/generic" )
NoticeMaterial[ NOTIFY_ERROR ] 		 = surface.GetTextureID( "vgui/notices/error" )
NoticeMaterial[ NOTIFY_UNDO ] 		 = surface.GetTextureID( "vgui/notices/undo" )
NoticeMaterial[ NOTIFY_HINT ] 		 = surface.GetTextureID( "vgui/notices/hint" )
NoticeMaterial[ NOTIFY_CLEANUP ] 	 = surface.GetTextureID( "vgui/notices/cleanup" )

local HUDNote_c = 0
local HUDNote_i = 1
local HUDNotes = {}

function GM:AddNotify( str, type, length )
	local tab = {}
	tab.text 	 = str
	tab.recv 	 = SysTime()
	tab.len 	 = length
	tab.velx	 = -5
	tab.vely	 = 0
	tab.x		 = ScrW() + 200
	tab.y		 = ScrH()
	tab.a		 = 255
	tab.type	 = type

	table.insert( HUDNotes, tab )

	HUDNote_c = HUDNote_c + 1
	HUDNote_i = HUDNote_i + 1
end

local function DrawNotice( self, k, v, i )
	local H = ScrH() / 1024
	local x = v.x - 75 * H
	local y = v.y - 300 * H

	if ( !v.w ) then
		surface.SetFont( "Medieval" )
		v.w, v.h = surface.GetTextSize( v.text )
	end

	local w = v.w
	local h = v.h

	w = w + 16
	h = h + 16

	draw.RoundedBox( 4, x - w - h + 8, y - 8, w + h, h, Color( 30, 30, 30, v.a * 0.4 ) )

	surface.SetDrawColor( 255, 255, 255, v.a )
	surface.SetTexture( NoticeMaterial[ v.type ] )
	surface.DrawTexturedRect( x - w - h + 16, y - 4, h - 8, h - 8 ) 

	draw.SimpleText( v.text, "Medieval", x+1, y+1, Color( 0, 0, 0, v.a*0.8 ), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Medieval", x-1, y-1, Color( 0, 0, 0, v.a*0.5 ), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Medieval", x+1, y-1, Color( 0, 0, 0, v.a*0.6 ), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Medieval", x-1, y+1, Color( 0, 0, 0, v.a*0.6 ), TEXT_ALIGN_RIGHT )
	draw.SimpleText( v.text, "Medieval", x, y, Color( 255, 255, 255, v.a ), TEXT_ALIGN_RIGHT )

	local ideal_y = ScrH() - ( HUDNote_c - i ) * ( h + 4 )
	local ideal_x = ScrW()

	local timeleft = v.len - ( SysTime() - v.recv )
	if ( timeleft < 0.8 ) then
		ideal_x = ScrW() - 50
	end

	if ( timeleft < 0.5 ) then
		ideal_x = ScrW() + w * 2
	end

	local spd = RealFrameTime() * 15
	v.y = v.y + v.vely * spd
	v.x = v.x + v.velx * spd

	local dist = ideal_y - v.y
	v.vely = v.vely + dist * spd * 1
	if ( math.abs( dist ) < 2 && math.abs( v.vely ) < 0.1 ) then v.vely = 0 end

	local dist = ideal_x - v.x
	v.velx = v.velx + dist * spd * 1
	if ( math.abs( dist ) < 2 && math.abs( v.velx ) < 0.1 ) then v.velx = 0 end

	v.velx = v.velx * ( 0.95 - RealFrameTime() * 8 )
	v.vely = v.vely * ( 0.95 - RealFrameTime() * 8 )
end

function GM:PaintNotes()
	if ( !HUDNotes ) then return end

	local i = 0
	for k, v in pairs( HUDNotes ) do
		if ( v ~= 0 ) then
			i = i + 1
			DrawNotice( self, k, v, i )
		end
	end

	for k, v in pairs( HUDNotes ) do
		if ( v ~= 0 && v.recv + v.len < SysTime() ) then
			HUDNotes[ k ] = 0
			HUDNote_c = HUDNote_c - 1

			if ( HUDNote_c == 0 ) then HUDNotes = {} end
		end
	end
end

local minute = 0
local hour = 1
local day = 1
local week = 1
local month = 1
local year = math.random( 1000, 1100 ) -- 'High' Middle Ages were between the 11th century ( 1000 ) and the 13th century ( 1200 )

hook.Add( "HUDPaint", "HUDTime", function()

	local Wid, Hei = surface.GetTextSize( " " )
	draw.WordBox( 8, Wid, Hei, " ", "Medieval", Color( 0, 0, 0, 0 ), Color( 255, 255, 255, 0 ) )

	local info = hour -- Time																									Time
		if tonumber( minute ) < 10 then
			info = info.." : 0"..minute
		else
			info = info.." : "..minute
		end
		local Wid, Hei = surface.GetTextSize( info )
		draw.WordBox( 8, ( ScrW()/2 )-( Wid/2 ), Hei*2, info, "Medieval", Color( 0, 0, 0, 255 ), Color( 255, 255, 255, 255 ) )
	local info = day.." "..month.." "..year	-- Date																				Date
		local Wid, Hei = surface.GetTextSize( info )
		draw.WordBox( 8, ( ScrW()/2 )-( Wid/2 ), Hei, info, "Medieval", Color( 0, 0, 0, 255 ), Color( 255, 255, 255, 255 ) )
end )

function RecvDateAndTimeUmsg( data )
	year = data:ReadString()
	month = data:ReadString()
	day = data:ReadString()
	hour = data:ReadString()
	minute = data:ReadString()
end
usermessage.Hook( "DateAndClockUmsg", RecvDateAndTimeUmsg )

--Clientside WeatherMod Stuff
--Modified By Fisheater
--Thank you to Rick Dark for creating the original weathermod system!

/*

function RecieveWeather( handler, id, encoded, decoded )
	WeatherType = decoded
end
datastream.Hook( "SendWeather", RecieveWeather )

WEATHER = {
	[ "sunny" ] = {
		Brightness = 0,
		Contrast = 0.8,
		Colour = 1,
		Precipitation = 0,
		SoundLevel = 3.9,
		Pitch = 100
	},
	[ "dark" ] = {
		Brightness = 0,
		Contrast = 0.3,
		Colour = 1,
		Precipitation = 0,
		SoundLevel = 2.9,
		Pitch = 100
	},
	[ "sunnyrain" ] = {
		Brightness = 0,
		Contrast = 0.5,
		Colour = 1.2,
		Precipitation = 10,
		SoundLevel = 3.9,
		Pitch = 100,
		Sound = "ambient/weather/rumble_rain_nowind.wav"
	},
	[ "darkrain" ] = {
		Brightness = 0,
		Contrast = 0.3,
		Colour = 1,
		Precipitation = 15,
		SoundLevel = 3.9,
		Pitch = 100,
		Sound = "ambient/weather/rumble_rain_nowind.wav"
	}
}

local CurWeather = {
	Brightness = 0,
	Contrast = 1,
	Colour = 1,
	Precipitation = 0,
	SoundLevel = 3.9,
	Pitch = 100
}

function WeatherOverlay()
	if render.GetDXLevel() < 80 then return end -- DirectX level

	local WeatherName = WeatherType
	if not WeatherName then
		if not WEATHER[ WeatherName ] then
			WeatherName = "sunny"
		end
	elseif not WEATHER[ WeatherName ] then
		WeatherName = "sunny"
	end

	local traced = {}
	traced.start = LocalPlayer():GetPos()
	traced.endpos = LocalPlayer():GetPos() + Vector( 0, 0, 400 ) -- Straight upwards
	traced.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine( traced )

	local function InBuilding( _P )
		local _TRACE
		local _INSIDETRACE = {}
			_INSIDETRACE.START = _P:GetPos()
			_INSIDETRACE.END = _P:GetPos().z + 10000
			_INSIDETRACE.FILTER = _P
		_TRACE = util.TraceLine( _INSIDETRACE )
		
		if _TRACE.HitNonWorld and string.find( _TRACE.Entity:GetClass(), "gmc_" ) then -- _TRACE.Entity:GetClass() == "gmc_building" then
			return true
		end
		return false
	end
	local lightadd = 0
		if InBuilding( LocalPlayer() ) then
			--lightadd = lightadd + 0.05
		end
		for k, v in pairs( ents.FindInSphere( LocalPlayer():GetPos(), 250 ) ) do
			if v:GetClass() == "gmc_fire" then
				lightadd = lightadd + 0.1--5
			end
		end
	if tr.HitWorld or InBuilding( LocalPlayer() ) then -- Inside?
		CurWeather.Brightness = math.Approach( CurWeather.Brightness, math.Clamp( WEATHER[ WeatherName ].Brightness, 0, 2 ), 0.01 )
		CurWeather.Contrast = math.Approach( CurWeather.Contrast, math.Clamp( WEATHER[ WeatherName ].Contrast + lightadd, 0, 2 ), 0.01 )
		CurWeather.Colour = math.Approach( CurWeather.Colour, math.Clamp( WEATHER[ WeatherName ].Colour, 0, 2 ), 0.01 )
	else
		CurWeather.Brightness = math.Approach( CurWeather.Brightness, WEATHER[ WeatherName ].Brightness, 0.01 )
		CurWeather.Contrast = math.Approach( CurWeather.Contrast, WEATHER[ WeatherName ].Contrast + lightadd, 0.01 )
		CurWeather.Colour = math.Approach( CurWeather.Colour, WEATHER[ WeatherName ].Colour, 0.01 )
	end
	CurWeather.Precipitation = WEATHER[ WeatherName ].Precipitation

	local ScrColTab = {} -- Screen Colouring
	ScrColTab[ "$pp_colour_addr" ] 		 = 0
	ScrColTab[ "$pp_colour_addg" ] 		 = 0
	ScrColTab[ "$pp_colour_addb" ] 		 = 0
	ScrColTab[ "$pp_colour_brightness" ] = CurWeather.Brightness
	ScrColTab[ "$pp_colour_contrast" ] 	 = CurWeather.Contrast
	ScrColTab[ "$pp_colour_colour" ] 	 = CurWeather.Colour
	ScrColTab[ "$pp_colour_mulr" ] 		 = 0
	ScrColTab[ "$pp_colour_mulg" ] 		 = 0
	ScrColTab[ "$pp_colour_mulb" ] 		 = 0
	DrawColorModify( ScrColTab )

	if not PrevWeather or PrevWeather ~= WeatherName then -- Play sounds
		if WeatherSound then WeatherSound:Stop() end
		if WEATHER[ WeatherName ].Sound then
			WeatherSound = CreateSound( LocalPlayer(), WEATHER[ WeatherName ].Sound )
			WeatherSound:Play()
		else
			WeatherSound = nil
		end
		PrevWeather = WeatherName
	end

	LastLightning = LastLightning or 0
	if CurTime() > LastLightning and CurWeather.Precipitation > 10 then -- Thunder and Lightning! D:
		if math.random( 1, 20 ) == 10 then
			LastLightning = CurTime() + 30
			CurWeather.Contrast = 5
			timer.Simple( 0.2, function()
				CurWeather.Contrast = WEATHER[ WeatherName ].Contrast
			end )
			timer.Simple( 3, function()
				surface.PlaySound( Format( "ambient/atmosphere/thunder%i.wav", math.random( 1, 4 ) ) )
			end )
		end
	end

	if WeatherSound then -- Quieter indoors
		if tr.HitWorld or LocalPlayer():InVehicle() or InBuilding( LocalPlayer() ) then
			CurWeather.SoundLevel = math.Approach( CurWeather.SoundLevel, 2, 0.195 )
			CurWeather.Pitch = math.Approach( CurWeather.Pitch, 50, 2 )
			WeatherSound:SetSoundLevel( CurWeather.SoundLevel )
			WeatherSound:ChangePitch( CurWeather.Pitch )
		else
			CurWeather.SoundLevel = math.Approach( CurWeather.SoundLevel, 3.9, 0.195 )
			CurWeather.Pitch = math.Approach( CurWeather.Pitch, 100, 2 )
			WeatherSound:SetSoundLevel( CurWeather.SoundLevel )
			WeatherSound:ChangePitch( CurWeather.Pitch )
		end
	end
end
hook.Add( "RenderScreenspaceEffects", "WeatherOverlay", WeatherOverlay )

local LastEffect = 0
function WeatherThink() -- Rain effects
	local WeatherName = WeatherType
	if not WeatherName or not WEATHER[ WeatherName ] then WeatherName = "sunny" end

	local function HitPos( ply, pos )
		local pos = ply:GetPos() + pos
		local tr
			local ang = Angle( 0, 0, -90 )
			local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+( ang*1000000 )
			tr = util.TraceLine( tracedata )
		return tr.HitPos
	end

	if CurWeather.Precipitation > 0 then
		if CurTime() > LastEffect then
			LastEffect = CurTime() + 0.1
			-- local eff = EffectData()
				-- eff:SetMagnitude( CurWeather.Precipitation )
			-- util.Effect( "rain", eff )
			for i = 1, math.random( CurWeather.Precipitation, CurWeather.Precipitation*5 ) do
				local pos = HitPos( LocalPlayer(), Vector( math.random( -1500, 1500 ), math.random( -1500, 1500 ), 500 ) )
				local effectdata = EffectData()
				effectdata:SetStart( pos )
				effectdata:SetOrigin( pos )
				effectdata:SetScale( math.random( 1, 3 ) )
				util.Effect( "watersplash", effectdata )
			end
		end
	end
end
hook.Add( "Think", "WeatherThink", WeatherThink )
*/
-- Spawns
function GMC_Spawnpoints_X()
	for _, ent in pairs( ents.GetAll() ) do
		if ent:GetClass() == "gmc_spawner" then
			if LocalPlayer():IsAdmin() and GMC_Spawnpoint_Xs then
				local pos = ent:GetPos():ToScreen()
				draw.DrawText( "X", "TargetID", pos.x, pos.y, Color( 0, 0, 0, 255 ), 1 )
				draw.DrawText( "X", "TargetID", pos.x-1, pos.y-1, Color( 0, 80, 15, 200 ), 1 )
			end
		end
	end
end
hook.Add( "HUDPaint", "GMC_Spawnpoints_X", GMC_Spawnpoints_X )

function GMC_Spawnpoint_TableUpdate( msg )
	local x = msg:ReadLong()
	local y = msg:ReadLong()
	local z = msg:ReadLong()
	if not GMC_Spawnpoint_Table then
		GMC_Spawnpoint_Table = {}
	end
	GMC_Spawnpoint_Table[ #GMC_Spawnpoint_Table+1 ] = Vector( x, y, z )
	GMC_Spawnpoint_Xs = true
end
usermessage.Hook( "GMC_Spawnpoint_Table", GMC_Spawnpoint_TableUpdate )

function GMC_Spawnpoint_TableUpdate2( msg )
	local x = msg:ReadLong()
	local y = msg:ReadLong()
	local z = msg:ReadLong()
	if GMC_Spawnpoint_Table then
		for i = 1, #GMC_Spawnpoint_Table do
			if GMC_Spawnpoint_Table[ i ] == Vector( x, y, z ) then
				GMC_Spawnpoint_Table[ i ] = nil
			end
		end
	end
end
usermessage.Hook( "GMC_Spawnpoint_Table_Remove", GMC_Spawnpoint_TableUpdate2 )

function GreenXs( ply )
	if ply:IsAdmin() then else return end

	if GMC_Spawnpoint_Xs then
		GMC_Spawnpoint_Xs = false
		ply:PrintMessage( HUD_PRINTCONSOLE, "Xs Disabled." )
	else
		GMC_Spawnpoint_Xs = true
		ply:PrintMessage( HUD_PRINTCONSOLE, "Xs Enabled." )
	end
end
concommand.Add( "spawn_greenxs", GreenXs )

-- Chat
function GMC_SendChatMessage( msg )
	local plyteam = msg:ReadLong()
	local name = msg:ReadString()
	local rpname = msg:ReadString()
	local text = msg:ReadString()

	local colour = Color( 181, 181, 181, 255 )
	local default = Color( 255, 255, 255, 255 )
		if LocalPlayer().TeamColour then
			colour = team.GetColor( plyteam )
		end
	if string.len( rpname ) >= 1 then
		chat.AddText( colour, name, -- Steam Name
					default, " (",
					-- colour, rpname, -- Roleplay Name
					default, rpname, -- Roleplay Name
					default, "): "..text -- Message
					)
	else
		chat.AddText( colour, name, -- Steam Name
					default, ": "..text -- Message
					)
	end
end
usermessage.Hook( "SendChatMessage", GMC_SendChatMessage )