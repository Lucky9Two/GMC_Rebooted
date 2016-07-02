
include( "sh_extras.lua" )

--for k, v in pairs( file.Find( "../modules/*", "LUA" ) ) do	include( "modules/"..v )	end

GM.Name 	= "GMod Civilizations: Rebooted"
GM.Author 	= "Matt, V92"
GM.Email 	= "N/A"
GM.Website 	= "N/A"

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

if SERVER then

	util.AddNetworkString( "tutorial" )
	util.AddNetworkString( "SendInventoryData" )
	util.AddNetworkString( "SendPermissionData" )
	util.AddNetworkString( "SendWeather" )
	util.AddNetworkString( "DateAndClockUmsg" )

	local function testNetCommand( ply, cmd, args ) 
		if args[1] and args[2] then 
			net.Start( "tutorial" )
				net.WriteString( args[1] )
				net.WriteString( args[2] )
			net.Send( ply )
		end
	end
	concommand.Add( "testNetCommand", testNetCommand )
else
	local function receiveMessage()
		local str1 = net.ReadString()
		local str2 = net.ReadString()
		print( str1, str2 )
	end
	net.Receive( "tutorial", receiveMessage )
end
team.SetUp( 1, "Unassigned", Color( 255, 255, 102, 255 ) )
team.SetUp( 2, "Craftsman", Color( 184, 134, 11, 255 ) )
team.SetUp( 3, "Mason", Color( 238, 221, 130, 255 ) )
team.SetUp( 4, "Miner", Color( 205, 201, 201, 255 ) )
team.SetUp( 5, "Lumberjack", Color( 107, 142, 35, 255 ) )
team.SetUp( 6, "Soldier", Color( 81, 81, 81, 255 ) )
team.SetUp( 7, "Monk", Color( 63, 63, 72, 255 ) )
team.SetUp( 8, "Smith", Color( 181, 181, 181, 255 ) )
team.SetUp( 9, "Merchant", Color( 255, 255, 102, 255 ) )
team.SetUp( 10, "Farmer", Color( 191, 88, 255, 255 ) )
team.SetUp( 11, "Cook", Color( 255, 167, 255, 255 ) )

function IsNumber( num )
	if tonumber( num ) == num then
		return true
	end
	return false
end

function IsString( text )
	if tostring( text ) == text then
		return true
	end
	return false
end

function GetSkill_Shared( ply, skill )
	if SERVER then
		return GetSkill( ply, skill )
	end
end

function SetSkill_Shared( ply, skill, exp )
	if SERVER then
		return SetSkill( ply, skill, exp )
	end
end