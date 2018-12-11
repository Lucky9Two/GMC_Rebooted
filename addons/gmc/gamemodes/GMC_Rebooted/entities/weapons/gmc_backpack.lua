	
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_backpack"
	local	_INFONAME		= "Backpack"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Instructions 		= "Left Click/Use to pickup items"
	SWEP.Slot 				= 0
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

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ""

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
	if SERVER then
		--self.Owner:DrawViewModel( false )
		--self.Owner:DrawWorldModel( false )
	end
end

function SWEP:PrimaryAttack()
	if not self.NextFire or self.NextFire > CurTime() then return end
	self.NextFire = CurTime() + 0.5

	local tr = self.Owner:EyeTrace( 100, Backpack_Blocked_Items )
	if tr.HitNonWorld then
		Backpack_Pickup( self.Owner, tr.Entity )
	else
		for k, v in pairs( ents.FindInSphere( tr.HitPos, 30 ) ) do -- Attempt to pickup all entities in range
			Backpack_Pickup( self.Owner, v )
		end
	end
end

function SWEP:SecondaryAttack()
	if not self.NextFire or self.NextFire > CurTime() then return end
	self.NextFire = CurTime() + 0.5

	umsg.Start( "BackpackMenu", self.Owner )
	umsg.End()
end