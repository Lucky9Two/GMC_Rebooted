
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Ore"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminSpawnable = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/midage/items/ore/ore.mdl" )
		self.Entity:SetMaterial( "models/midage/items/ore/tin_d" )
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
end