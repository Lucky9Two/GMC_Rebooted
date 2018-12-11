	
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_hammer"
	local	_INFONAME		= "Hammer"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Purpose			= "For building buildings"
	SWEP.Instructions 		= "Left click to build\nTakes resources from your backpack."
	SWEP.Slot 				= 1
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
	SWEP.Weight				= 0
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.Spawnable			= true
	SWEP.AdminOnly			= false
end

SWEP.HoldType				= "melee"
SWEP.ViewModel				=  Model("models/weapons/v_sledgehammer/v_sledgehammer.mdl")
SWEP.WorldModel  			=  Model("models/weapons/w_sledgehammer.mdl")

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
			if string.find( tr.Entity:GetClass(), "building" ) and tr.Entity.Owner and ( tr.Entity.Owner == self.Owner or HasPermission( self.Owner, "Building", tr.Entity.Owner ) ) then
				self.Resource1s = 0
				self.Resource2s = 0
				self.Resource3s = 0
				self.Resource4s = 0
				if not tr.Entity:GetNWInt( "building" ) or tr.Entity:GetNWInt( "building" ) < 10 then
					if not tr.Entity.Resource1 then
						for k, v in pairs( GMC_Buildings ) do
							if v.Name == tr.Entity.Building then
								tr.Entity.Resource1 = v.Resource1
									tr.Entity.TResource1s = v.Resource1s
								tr.Entity.Resource2 = v.Resource2
									tr.Entity.TResource2s = v.Resource2s
								tr.Entity.Resource3 = v.Resource3
									tr.Entity.TResource3s = v.Resource3s
								tr.Entity.Resource4 = v.Resource4
									tr.Entity.TResource4s = v.Resource4s
							end
						end
					end

					local item, res1 = Backpack_HasItem( self.Owner, tr.Entity.Resource1 )
					if tr.Entity.Resource1 and res1 and tr.Entity.Resource1s < tr.Entity.TResource1s then
						local add = res1
						local max = tr.Entity.TResource1s - tr.Entity.Resource1s
							if add > max then
								add = max
							end
						tr.Entity.Resource1s = tr.Entity.Resource1s + add

						Backpack_Take( self.Owner, item, add )
						SetSkill( self.Owner, "Masonry", add )
					end

					local item, res2 = Backpack_HasItem( self.Owner, tr.Entity.Resource2 )
					if tr.Entity.Resource2 and res2 and tr.Entity.Resource2s < tr.Entity.TResource2s then
						local add = res2
						local max = tr.Entity.TResource2s - tr.Entity.Resource2s
							if add > max then
								add = max
							end
						tr.Entity.Resource2s = tr.Entity.Resource2s + add

						Backpack_Take( self.Owner, item, add )
						SetSkill( self.Owner, "Masonry", add )
					end

					local item, res3 = Backpack_HasItem( self.Owner, tr.Entity.Resource3 )
					if tr.Entity.Resource3 and res3 and tr.Entity.Resource3s < tr.Entity.TResource3s then
						local add = res3
						local max = tr.Entity.TResource3s - tr.Entity.Resource3s
							if add > max then
								add = max
							end
						tr.Entity.Resource3s = tr.Entity.Resource3s + add

						Backpack_Take( self.Owner, item, add )
						SetSkill( self.Owner, "Masonry", add )
					end

					local item, res4 = Backpack_HasItem( self.Owner, tr.Entity.Resource4 )
					if tr.Entity.Resource4 and res4 and tr.Entity.Resource4s < tr.Entity.TResource4s then
						local add = res4
						local max = tr.Entity.TResource4s - tr.Entity.Resource4s
							if add > max then
								add = max
							end
						tr.Entity.Resource4s = tr.Entity.Resource4s + add

						Backpack_Take( self.Owner, item, add )
						SetSkill( self.Owner, "Masonry", add )
					end
				end
			end
		end
		self.NextStrike1 = ( CurTime() + 1 )
	end
end

function SWEP:SecondaryAttack()
end