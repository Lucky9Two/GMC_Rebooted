
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_demolish"
	local	_INFONAME		= "Demolition"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Purpose			= "For demolishing buildings"
	SWEP.Instructions 		= "Left click to demolish."
	SWEP.Slot 				= 3
	SWEP.SlotPos 			= 4
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

SWEP.HoldType				= "melee2"
SWEP.ViewModel				= Model("models/weapons/v_sledgehammer/v_sledgehammer.mdl")
SWEP.WorldModel  			= Model("models/weapons/w_sledgehammer.mdl")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= ""

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.NextStrike1 = 0
end

function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if ( CurTime() < self.NextStrike1 ) then return end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )

	if SERVER then
		if tr.HitNonWorld then
			if string.find( tr.Entity:GetClass(), "building" ) then
				if not tr.Entity.Owner or self.Owner == tr.Entity.Owner or not tr.Entity.Owner:IsValid() or HasPermission( self.Owner, "Removing", tr.Entity.Owner ) then
					tr.Entity:Remove()
				end
			end
		end
		self.NextStrike1 = ( CurTime() + 1 )
	end
end

function SWEP:SecondaryAttack()
end