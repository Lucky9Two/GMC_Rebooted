
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Cut tree"
ENT.Author = "Matt"
ENT.Spawnable = true
ENT.AdminSpawnable = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end 
else
	function ENT:Initialize()
		self.Entity:SetModel( "Models/Props_foliage/tree_stump01.mdl" )

		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
		end

		self.Entity:GetPhysicsObject():EnableMotion( false )

		self.Regrow = CurTime() + 300
	end

	function ENT:Think()
		if self.Regrow <= CurTime() then
			local ent = ents.Create( "gmc_tree" )
			ent:Spawn()
			ent:Activate()
			ent:SetPos( self.Entity:GetPos() )
			ent:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
			self.Entity:Remove()
		end
	end
end