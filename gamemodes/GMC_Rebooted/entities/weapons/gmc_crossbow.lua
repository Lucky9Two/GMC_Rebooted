	
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_crossbow"
	local	_INFONAME		= "Crossbow"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Instructions 		= "Secondary to pick up or drop objects\nPrimary to throw the object you're holding\nReload to straighten the object you're holding"
	SWEP.Slot 				= 0
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

SWEP.HoldType				= "crossbow"
SWEP.ViewModel				= Model("models/weapons/crossbow.mdl")
SWEP.WorldModel				= Model("models/weapons/w_crossbow.mdl")

SWEP.Primary.Automatic		= false
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Ammo			= "xbowbolt"
SWEP.Primary.Delay			= 1.8
SWEP.Primary.Damage			= 200
SWEP.Primary.ReloadTime		= 2.1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 			= Vector( -5.2, -3, 3 )
SWEP.IronSightsAng 			= Vector( 2.8, -2.5, 3 )

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.Weapon:SetNetworkedBool( "Ironsights", false )
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	self:SetIronsights( false )
	self.Weapon:EmitSound( "Weapon_Crossbow.Reload" )
end

function SWEP:TakePrimaryAmmo( num )
	if ( self.Weapon:Clip1() <= 0 ) then
		if ( self:Ammo1() <= 0 ) then return end
		self:Reload()
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )

		return
	end

	self.Weapon:SetClip1( self.Weapon:Clip1() - num )
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if ( !self:CanPrimaryAttack() ) then return end
	self:TakePrimaryAmmo( 1 )
	self.Weapon:EmitSound( "Weapon_Crossbow.Single" )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Owner:ViewPunch( Angle( math.Rand( -1,1 ),math.Rand( -1,1 ),math.Rand( -9,-4 ) ) )

	if ( !CLIENT ) then
		local Ang = self.Owner:EyeAngles()
		Ang.pitch = Ang.pitch - 5
		self.Owner:SetEyeAngles( Ang )
	end

	if ( SERVER ) then
		self.Bolt = ents.Create( "gmc_bolt" )
		self.Bolt:SetPos( self.Owner:GetShootPos() + self.Owner:GetForward() * 34 )
		self.Bolt:SetAngles( self.Owner:EyeAngles() + Angle( 0, 0, 90 ) )
		self.Bolt:SetPhysicsAttacker( self.Owner )
		self.Bolt:SetOwner( self.Owner )
		self.Bolt:Spawn()
		self.Bolt:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() * 9800 )

		for k, v in pairs( ents.FindInSphere( self.Owner:GetPos(), 60 ) ) do
			if v:GetClass() == "env_fire" || v:GetClass() == "env_entity_igniter" || v:GetClass() == "env_firesource" || v:GetClass() == "env_fire_trail" || v:IsOnFire() then
				self.Fire = ents.Create( "env_fire_trail" )
				self.Fire:SetPos( self.Bolt:GetPos() )
				self.Fire:SetParent( self.Bolt )
				self.Fire:Spawn()
				self.Fire:Fire( "kill","",10 )

				self.FireDamage = ents.Create( "point_hurt" )
				self.FireDamage:SetPos( self.Bolt:GetPos() )
				self.FireDamage:SetParent( self.Bolt )
				self.FireDamage:SetKeyValue( "DamageRadius", 30 ) 
				self.FireDamage:SetKeyValue( "Damage", 7 ) 
				self.FireDamage:SetKeyValue( "DamageDelay", 0,2 ) 
				self.FireDamage:SetKeyValue( "DamageType ", 2097152 )
				self.FireDamage:Spawn()
				self.FireDamage:Fire( "kill","",10 )
			end
		end
	end
end

local IRONSIGHT_TIME = 0.25
function SWEP:GetViewModelPosition( pos, ang )
	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	if ( bIron != self.bLastIron ) then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()

		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0
	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end

	local Mul = 1.0
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
		Mul = math.Clamp( ( CurTime() - fIronTime ) / IRONSIGHT_TIME, 0, 1 )
		if ( !bIron ) then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos
	if ( self.IronSightsAng ) then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end

function SWEP:SetIronsights( b )
	self.Weapon:SetNetworkedBool( "Ironsights", b )
end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()
	if ( self.NextSecondaryAttack > CurTime() ) then return end

	if not self.Weapon.NoBackpack then
		local model = tostring( self.Weapon.WorldModel )
		Backpack_Give( self.Owner, "Crossbow", model, "gmc_craft" )
		self.Owner:StripWeapon( tostring( self.Weapon.ClassName ) )
	else
		HintPlayer( self.Owner, "You cannot put this weapon into your backpack." )
	end

	self.NextSecondaryAttack = CurTime() + 0.3
end

function SWEP:OnRestore()
	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
end