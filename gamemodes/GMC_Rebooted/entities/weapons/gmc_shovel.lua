	
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_shovel"
	local	_INFONAME		= "Shovel"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Instructions 		= "Left click to plant"
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

SWEP.NextStrike				= 0
SWEP.NextStrike1			= 0

SWEP.HoldType				= "melee2"
SWEP.ViewModel				= Model("models/weapons/v_shovel.mdl")
SWEP.WorldModel				= Model("models/weapons/w_shovel.mdl")
  
-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.4 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 0	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire ( false ) or SMG fire ( true )
SWEP.Primary.Ammo         	= "none"	--Ammo Type

SWEP.Secondary.Delay		= 0.4 	--In seconds
SWEP.Secondary.Recoil		= 0		--Gun Kick
SWEP.Secondary.Damage		= 0	--Damage per Bullet
SWEP.Secondary.NumShots		= 1		--Number of shots per one fire
SWEP.Secondary.Cone			= 0 	--Bullet Spread
SWEP.Secondary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Secondary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Secondary.Automatic   	= true	--Pistol fire ( false ) or SMG fire ( true )
SWEP.Secondary.Ammo        	= "none"	--Ammo Type

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
	return true
end

function SWEP:PrimaryAttack( ply )
	if( CurTime() < self.NextStrike1 ) then return end
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_3 )

	if SERVER then
		timer.Simple( 0.5, function()
			self.Weapon:GetTarget()
			self.Weapon:GetCanPlant()
			if self.Target and self.CanPlant then
				if self.Target:GetClass() == "gmc_seed" then
					self.Target.Planted = true
					local exp
						for k, v in pairs( Plants_Server ) do
							if v.Name == string.gsub( self.Target.Name, " Seed", "" ) then
								exp = v.Exp
							end
						end
					if exp then
						SetSkill( self.Owner, "Farming", exp )
					end
				elseif self.Target:GetClass() == "gmc_plant_underground" then
					if not self.Target.LifeTime then return end

					local exp -- Add exp
						for k, v in pairs( Plants_Server ) do
							if v.Name == self.Target.FruitName then
								exp = v.Exp
							end
						end
					if exp then
						SetSkill( self.Owner, "Farming", exp )
					end

					-- Harvest
						local name = self.Target.FruitName
						local model
							for k, v in pairs( Plants_Server ) do
								if v.Name == name then
									model = v.Model
								end
							end
						if not model then return end
						Backpack_Give( self.Owner, name, model, "gmc_resource", math.random( 3, 5 ) )
						self.Target:Remove()
				end
				self.Owner:EmitSound( "medieval/shovel1.mp3" )
			end
		end )
	end
end

function SWEP:GetTarget()
	self.Target = nil

	local tr = self.Owner:GetEyeTrace()
	if tr.HitNonWorld and ( tr.Entity:GetClass() == "gmc_seed" or tr.Entity:GetClass() == "gmc_plant_underground" ) and Entity_OnGround( tr.Entity ) then
		self.Target = tr.Entity
		return
	end

	for k, v in pairs( ents.FindInSphere( tr.HitPos, 25 ) ) do
		if ( v:GetClass() == "gmc_seed" or v:GetClass() == "gmc_plant_underground" ) and Entity_OnGround( tr.Entity ) then
			self.Target = v
			return
		end
	end
end

function SWEP:GetCanPlant()
	self.CanPlant = false

	for _, ent in pairs( ents.GetAll() ) do
		if ent.Building == "Farm" and ent:GetNWInt( "building" ) >= 10 then
			for k, v in pairs( ents.FindInBox( ent:GetPos() - Vector( 250, 250, 300 ), ent:GetPos() + Vector( 250, 250, 300 ) ) ) do
				if v == self.Target then
					self.CanPlant = true
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
end