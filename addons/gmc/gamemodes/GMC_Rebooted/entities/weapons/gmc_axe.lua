
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_axe"
	local	_INFONAME		= "Axe"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Instructions 		= "Primary to Cut"
	SWEP.Slot 				= 3
	SWEP.SlotPos 			= 3
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
	SWEP.Weight				= 3
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.Spawnable			= true
	SWEP.AdminOnly			= false
end

SWEP.HoldType				= "melee"
SWEP.NextStrike				= 0
SWEP.ViewModel      		= Model("models/weapons/v_axe/v_axe.mdl")
SWEP.WorldModel  			= Model("models/weapons/w_axe.mdl")

-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.4 		--In seconds
SWEP.Primary.Recoil			= 0			--Gun Kick
SWEP.Primary.Damage			= 0			--Damage per Bullet
SWEP.Primary.NumShots		= 1			--Number of shots per one fire
SWEP.Primary.Cone			= 0 		--Bullet Spread
SWEP.Primary.ClipSize		= 2			--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1		--Number of shots in next clip
SWEP.Primary.Automatic   	= true		--Pistol fire ( false ) or SMG fire ( true )
SWEP.Primary.Ammo         	= "none"	--Ammo Type

SWEP.Secondary.Delay		= 0.4 		--In seconds
SWEP.Secondary.Recoil		= 0			--Gun Kick
SWEP.Secondary.Damage		= 0			--Damage per Bullet
SWEP.Secondary.NumShots		= 1			--Number of shots per one fire
SWEP.Secondary.Cone			= 0 		--Bullet Spread
SWEP.Secondary.ClipSize		= 2			--Use "-1 if there are no clips"
SWEP.Secondary.DefaultClip	= -1		--Number of shots in next clip
SWEP.Secondary.Automatic   	= true		--Pistol fire ( false ) or SMG fire ( true )
SWEP.Secondary.Ammo         = "none"	--Ammo Type

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack( ply )
	if ( CurTime() < self.NextStrike ) then return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )

	if SERVER then
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance( self.Owner:GetShootPos() ) <= 100 then
			if trace.HitNonWorld then
				local ent = trace.Entity
				if ent:GetClass() == "gmc_tree" then
					self.Owner:EmitSound( "physics/wood/wood_box_impact_bullet"..math.random( 1, 4 )..".wav" ) 
					trace.Entity.Chops = trace.Entity.Chops + 1

					Backpack_Give( self.Owner, "Log", "models/gmstranded/props/lumber.mdl", "gmc_resource" )
					SetSkill( self.Owner, "Lumbering", math.random( 1, 10 ) )
				end
			end
		end
	end
	local next = CurTime() + 0.4
	local lvl = tonumber( GetSkill_Shared( self.Owner, "Lumbering" ) )
		if lvl <= 42 then -- 42/20 = 2.1 ( 2.5-0.4 )
			next = CurTime() + ( 2.5 - ( lvl/20 ) )
		end
	self.NextStrike = next
end

function SWEP:SecondaryAttack()
end 