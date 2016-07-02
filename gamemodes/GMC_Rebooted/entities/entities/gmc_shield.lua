
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Shield"
ENT.Author = "Matt"
ENT.Spawnable = true
ENT.AdminSpawnable = true

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/nayrbarr/Shield/shield.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 7 )
		end
		self.ShiftUse = true
	end

	function ENT:Use( activator, caller )
		if ( !activator:IsPlayer() ) then return false end

		if not activator.HasShield and not self.HasPlayer then
			activator.HasShield = true
			self.Entity:Remove()
		end
	end
end
