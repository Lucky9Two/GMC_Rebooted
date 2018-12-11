
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_meleebase"
	local	_INFONAME		= "GMC Melee Base"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Purpose			= ""
	SWEP.Instructions 		= ""
	SWEP.Slot 				= 2
	SWEP.SlotPos 			= 2
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
	SWEP.HoldType			= "melee2"
	SWEP.Weight				= 0
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.Spawnable			= false
	SWEP.AdminOnly			= true
end

SWEP.ViewModel				= Model("models/weapons/v_sword.mdl")
SWEP.WorldModel				= Model("models/weapons/w_sword.mdl")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= ""

function SWEP:Initialize()
	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
	self.NextSwing = 0
end

function SWEP:Deploy()
	if ( SERVER ) then
		if self.Owner.HasShield and ( not self.Weapon.Shield or not self.Weapon.Shield:IsValid() ) then
			self.Weapon.Shield = ents.Create( "prop_physics" ) -- Credits to - Donkie - I believe
				self.Weapon.Shield:SetModel( "models/nayrbarr/Shield/shield.mdl" )
				self.Weapon.Shield:Spawn()
				self.Weapon.Shield:Activate()
				self.Weapon.Shield:SetPos( self.Owner:GetPos() + Vector( 0, 0, 45 ) + ( self.Owner:GetForward()*16 ) + ( self.Owner:GetRight() * -9 ) )
				self.Weapon.Shield:SetAngles( Angle( 0, self.Owner:EyeAngles().y+10, self.Owner:EyeAngles().r ) )
				self.Weapon.Shield:SetParent( self.Owner )
				self.Weapon.Shield:Fire( "SetParentAttachmentMaintainOffset", "chest", 0.01 )
				self.Weapon.Shield:SetCollisionGroup( COLLISION_GROUP_WORLD )
				self.Weapon.Shield.HasPlayer = self.Owner
				self.Owner.HasShield = true
		end
		self.Owner:EmitSound( "sword/draw.wav" )
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	end
	return true
end

function SWEP:Holster( wep )
	if ( SERVER ) then
		self.Owner:EmitSound( "sword/sheath.wav" )
		if self.Weapon.Shield and self.Weapon.Shield:IsValid() then
			self.Weapon.Shield:Remove()
			self.Owner.HasShield = true
		end
	end
	return true
end

function SWEP:Attack( damage, range, decal )
	if ( SERVER ) then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )

		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+( ang*1000 )
		tracedata.filter = {self.Owner, self.Weapon.Shield}
		local trace = util.TraceLine( tracedata )
		if trace.HitPos:Distance( self.Owner:GetShootPos() ) <= range then
			if trace.HitNonWorld then
				self.Owner:EmitSound( "sword/hit"..math.random( 1, 2 )..".wav" )

				trace.Entity:TakeDamage( damage, self.Owner )

				if decal then
					util.Decal( decal, trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal )
				end
			else
				self.Owner:EmitSound( "sword/miss1.wav" )
			end
		else
			self.Owner:EmitSound( "sword/miss1.wav" )
		end
	end
end

function ShieldTakeDamage( victim, attacker )
	local shield = victim:GetActiveWeapon().Shield
	if victim.HasShield and shield then
		for k, v in pairs( ents.FindInSphere( shield:GetPos(), 20 ) ) do
			if v == attacker then
				return false
			end
		end
	end
end
hook.Add( "PlayerShouldTakeDamage", "ShieldTakeDamage", ShieldTakeDamage )

function SWEP:Drop()
	if not self.Weapon.NoBackpack then
		local name = tostring( self.Weapon:GetNWString( "name" ) )
		local model = tostring( self.Weapon.WorldModel )
		local class = "gmc_weapon"
		Backpack_Give( self.Owner, name, model, class )
		self.Owner:StripWeapon( tostring( self.Weapon.ClassName ) )
	else
		HintPlayer( self.Owner, "You cannot put this "..self.Weapon:GetNWString( "name" ).." into your backpack." )
	end

	local tr
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+( ang*80 )
		tracedata.filter = self.Owner
		tr = util.TraceLine( tracedata )
	if self.Owner.HasShield then
		local ent = ents.Create( "gmc_shield" )
		ent:Spawn()
		ent:Activate()
		ent:SetPos( tr.HitPos + Vector( 0, 0, 5 ) )
		ent:SetAngles( self.Owner:GetAngles() )

		self.Owner.HasShield = false
	end

	self.Owner:StripWeapon( self.Weapon:GetClass() )

	if self.Weapon.Shield and self.Weapon.Shield:IsValid() then
		self.Weapon.Shield:Remove()
	end
end

function SWEP:OnRemove()
	if SERVER then
		if self.Weapon.Shield and self.Weapon.Shield:IsValid() then
			self.Weapon.Shield:Remove()
			self.Owner.HasShield = true
		end
	end
end