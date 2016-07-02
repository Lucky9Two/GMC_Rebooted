
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Tree"
ENT.Author = "Matt"
ENT.Spawnable = true
ENT.AdminOnly = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end 
else
	function ENT:Initialize()
		if not TreeModels then TreeModels = {} end

		--TreeModels[ 1 ] = "models/props_foliage/tree_deciduous_03a.mdl"
		TreeModels[ 1 ] = "models/props_foliage/tree_pine04.mdl"
		TreeModels[ 2 ] = "models/props_foliage/tree_pine05.mdl"
		TreeModels[ 3 ] = "models/props_foliage/tree_pine06.mdl"
		TreeModels[ 4 ] = "models/props_foliage/tree_pine_large.mdl"

		self.Entity:SetModel( TreeModels[ math.random( 1, #TreeModels ) ] )

		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
		end

		self.Entity:GetPhysicsObject():EnableMotion( false )

		self.Chops = 0
		self.MaxChops = math.random( 20, 30 )
	end

	function ENT:Think()
		if self.Chops == self.MaxChops then
			local ent = ents.Create( "gmc_tree_cut" )
			ent:Spawn()
			ent:SetPos( self.Entity:GetPos() )
			ent:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
			self.Entity:Remove()
		end
	end
end