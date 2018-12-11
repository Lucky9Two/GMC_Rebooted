
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Craft"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminOnly = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 7 )
		end
	end

	function ENT:Use( activator, caller )
		if ( !activator:IsPlayer() ) then return false end

		if self.Weapon and not activator:HasWeapon( self.Weapon ) then
			if self.Weapon == "" then else
				activator:Give( self.Weapon )
				self.Entity:Remove()
			end
		end
	end 
end
