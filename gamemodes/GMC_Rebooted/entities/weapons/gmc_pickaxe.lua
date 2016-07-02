	
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_pickaxe"
	local	_INFONAME		= "Pickaxe"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Purpose			= ""
	SWEP.Instructions 		= "Primary to Mine"
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
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.Spawnable			= true
	SWEP.AdminOnly			= false
end

SWEP.HoldType				= "melee"
SWEP.ViewModel				= Model("models/weapons/v_stone_pickaxe.mdl")
SWEP.WorldModel				= Model("models/weapons/w_stone_pickaxe.mdl")

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
	if self.NextStrike and self.NextStrike > CurTime() then return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )

	if SERVER then
		local trace = self.Owner:GetEyeTrace()
		if trace.HitPos:Distance( self.Owner:GetShootPos() ) <= 100 then
			if trace.HitNonWorld then
				local trent = trace.Entity
				if trent.Mine and trent.Mine.Level then
					if tonumber( GetSkill( self.Owner, "Mining" ) ) >= tonumber( trent.Mine.Level ) then
						self.Owner:EmitSound( "physics/wood/wood_box_impact_bullet"..math.random( 1, 4 )..".wav" )
						local ran = math.random( 1, 10 )
						if ran <= trent.Mine.Ratio then
							Backpack_Give( self.Owner, trent.Mine.Name, trent.Mine.Model, "gmc_ore" )
							SetSkill( self.Owner, "Mining", math.random( 1, 10 ) )

							-- if self.Owner.Bot and self.Owner.Bot_Gather then
								-- for k, v in pairs( self.Owner.Bot_Gather ) do
									-- if v.Class == trent.Mine.Name then
										-- v.Amount = v.Amount - 1
									-- end
								-- end
							-- end
						end
					else
						HintPlayer( self.Owner, "You require a mining level of "..trent.Mine.Level.." to mine this." )
					end
				end
			end
		end
	end
	local next = CurTime() + 0.4
	local lvl = tonumber( GetSkill_Shared( self.Owner, "Mining" ) )
		if lvl <= 42 then -- 42/20 = 2.1 ( 2.5-0.4 )
			next = CurTime() + ( 2.5 - ( lvl/20 ) )
		end
	self.NextStrike = next
end

function SWEP:SecondaryAttack()
end 