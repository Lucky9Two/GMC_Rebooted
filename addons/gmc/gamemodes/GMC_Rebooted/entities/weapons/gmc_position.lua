	
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_position"
	local	_INFONAME		= "Positioning"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Purpose			= "For positioning buildings"
	SWEP.Instructions 		= "Left click to pickup/drop.\nRight click with a building to toggle a better view.\nSprint to make the building higher.\nWalk to make the building lower.\nJump to zoom out (While in 'better' view).\nDuck to zoom in (While in 'better' view)."
	SWEP.Slot 				= 1
	SWEP.SlotPos 			= 1
	SWEP.ViewModelFOV		= 70
	SWEP.DrawCrosshair 		= true
	SWEP.DrawAmmo			= false
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/hud/" .. _SELFENTNAME )

	language.Add( _SELFENTNAME, _INFONAME )	
	killicon.Add( _SELFENTNAME, "vgui/entities/".. _SELFENTNAME , Color( 255, 255, 255 ) )
else
	SWEP.Weight				= 0
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.Spawnable			= true
	SWEP.AdminOnly			= false
end

SWEP.HoldType				= "normal"
SWEP.ViewModel				= Model("")
SWEP.WorldModel				= Model("")

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= ""

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.NextStrike1 = 0
	self.NextStrike2 = 0
	self.NextReload = 0
	self.HoverPos = 0
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel( false )
		self.Owner:DrawWorldModel( false )
	end
end

function SWEP:Reload()
	if self.NextReload < CurTime() then else return end
	if self.Owner.Building then
		if self.Owner.Building.Rotation then
			self.Owner.Building.Rotation = self.Owner.Building.Rotation + 45
		end
		self.NextReload = CurTime() + 1
	end
end

function Building_Drop( ply, tr )
	ply.Building:SetPos( tr.HitPos )
	ply.Building:SetAngles( Angle( 0, ply:GetAimVector():Angle().y + ply.Building.Rotation, 0 ) )

	if ply.Building:GetPhysicsObject():IsValid() then
		ply.Building:GetPhysicsObject():EnableMotion( false )
	end

	ply.Building = nil
end

function Building_Drop_Think()
	for k, v in pairs( player.GetAll() ) do
		if v.Building and v:GetActiveWeapon() ~= v:GetWeapon( "gmc_position" ) then
			local tr
				local pos = v:GetShootPos()
				local ang = v:GetAimVector()
				local tracedata = {}
					tracedata.start = pos
					tracedata.endpos = pos+( ang*1000 )
					if v.Building then
						tracedata.filter = {v.Building, v}
					else
						tracedata.filter = v
					end
				tr = util.TraceLine( tracedata )
			if tr.HitWorld then
				Building_Drop( v, tr )
				v:SetNWEntity( "Building", v )
			end
		end
	end
end
hook.Add( "Think", "Building_Drop_Think", Building_Drop_Think )

function SWEP:PrimaryAttack( ply )
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+( ang*1000 )
		if self.Owner.Building then
			tracedata.filter = {self.Owner.Building, self.Owner}
		else
			tracedata.filter = self.Owner
		end
	local tr = util.TraceLine( tracedata )
	if( CurTime() < self.NextStrike1 ) then return end

	if SERVER then
		if tr.HitNonWorld then
			if not self.Owner.Building or not self.Owner.Building:IsValid() then
				if string.find( tr.Entity:GetClass(), "building" ) and tr.Entity.Owner and ( tr.Entity.Owner == self.Owner or HasPermission( self.Owner, "Positioning", tr.Entity.Owner ) ) then
					if not tr.Entity:GetNWInt( "building" ) or tr.Entity:GetNWInt( "building" ) == 0 or tr.Entity:GetNWInt( "building" ) == 1 then
						self.Owner.Building = tr.Entity
						if self.Owner.Building.Rotation then else
							self.Owner.Building.Rotation = 0
						end
					end
				end
			end
		elseif self.Owner.Building and tr.HitWorld then
			Building_Drop( self.Owner, tr )
		end
		self.NextStrike1 = ( CurTime() + 1 )
	end
end

function SWEP:Think()
	if self.Owner.Building then
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+( ang*1000 )
		tracedata.filter = {self.Owner.Building, self.Owner}
		local tr = util.TraceLine( tracedata )

		if self.Owner.Building and self.Owner.Building:IsValid() then
			self.Owner.Building:SetPos( Vector( tr.HitPos.x, tr.HitPos.y, tr.HitPos.z + self.HoverPos ) )
			self.Owner.Building:SetAngles( Angle( 0, self.Owner:GetAimVector():Angle().y + self.Owner.Building.Rotation, 0 ) )
		end
	end

	if self.Owner:KeyDown( IN_FORWARD ) then
	elseif self.Owner:KeyDown( IN_BACK ) then
	elseif self.Owner:KeyDown( IN_SPEED ) then
		if self.HoverPos < 500 then
			self.HoverPos = self.HoverPos + 1
		end
	elseif self.Owner:KeyDown( IN_WALK ) then
		if self.HoverPos > 1 then
			self.HoverPos = self.HoverPos - 1
		end
	end

	self:NextThink( CurTime() + 0.5 )
end

function SWEP:SecondaryAttack()
	if self.NextStrike2 > CurTime() then return end

	local Building = self.Owner:GetNWEntity( "Building", self.Owner )
	if Building and Building:IsValid() and Building ~= self.Owner then
		self.Owner:SetNWEntity( "Building", self.Owner )
	elseif self.Owner.Building then
		self.Owner:SetNWEntity( "Building", self.Owner.Building )
		self.Owner:SetMoveType( MOVETYPE_WALK )
	else
		self.Owner:SetNWEntity( "Building", self.Owner )
	end

	self.NextStrike2 = ( CurTime() + 1 )
end

if CLIENT then
	function ViewCameraBuilding( ply, origin, angles, fov ) -- Credits to Sakarias for this code
		local Building = ply:GetNWEntity( "Building", ply )
		if Building and Building:IsValid() and Building ~= ply then
			if not ply.CamDist then
				ply.CamDist = 500
			end
			Building.PickedUp = ply
			local view = {}
				view.origin = Building:GetPos() + ply:GetAimVector():GetNormal() * -ply.CamDist
				view.angles = angles
			return view
		end
	end
	hook.Add( "CalcView", "ViewCameraBuilding", ViewCameraBuilding )

	function ViewCameraBuilding_Think()
		local Building = LocalPlayer():GetNWEntity( "Building", LocalPlayer() )
		if Building and Building:IsValid() and Building ~= LocalPlayer() then
			if LocalPlayer():KeyDown( IN_JUMP ) then
				LocalPlayer().CamDist = LocalPlayer().CamDist + 5
			elseif LocalPlayer():KeyDown( IN_DUCK ) then
				LocalPlayer().CamDist = LocalPlayer().CamDist - 5
			end
		end

		if LocalPlayer():GetNWEntity( "Building", LocalPlayer() ) ~= LocalPlayer() then
			for k, v in pairs( ents.FindByClass( "gmc_building" ) ) do
				if v.Scafolding and v.Scafolding:IsValid() then
					local r, g, b, a = v:GetColor()
					v:SetColor( r, g, b, 0 )
					v.Scafolding:SetColor( r, g, b, 255 )
				end
			end
		else
			for k, v in pairs( ents.FindByClass( "gmc_building" ) ) do
				local r, g, b, a = v:GetColor()
				v:SetColor( r, g, b, 255 )
				if v.Scafolding and v.Scafolding:IsValid() then
					v.Scafolding:SetColor( r, g, b, 100 )
				end
			end
		end
	end
	hook.Add( "Think", "ViewCameraBuilding_Think", ViewCameraBuilding_Think )
end