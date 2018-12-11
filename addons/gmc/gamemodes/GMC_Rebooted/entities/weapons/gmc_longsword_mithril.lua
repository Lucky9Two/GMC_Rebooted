
AddCSLuaFile()

SWEP.Base 					= "gmc_meleebase"

if CLIENT then
	local	_SELFENTNAME	= "gmc_longsword_mithril"
	local	_INFONAME		= "Mithril Longsword"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Purpose			= "Stabbing"
	SWEP.Instructions 		= "Primary to stab!"
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
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.Spawnable			= true
	SWEP.AdminOnly			= false
end

SWEP.HoldType				= "melee2"
SWEP.ViewModel				= Model("models/weapons/v_sword.mdl")
SWEP.WorldModel				= Model("models/weapons/w_sword.mdl")

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	if not self.Damage then self.Damage = 35 end
	if self.NextSwing < CurTime() then
		self.Weapon:Attack( math.random( self.Damage-5, self.Damage+5 ), 95, false )

		self.Weapon.NextSwing = CurTime() + 0.4
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:Drop()
end
