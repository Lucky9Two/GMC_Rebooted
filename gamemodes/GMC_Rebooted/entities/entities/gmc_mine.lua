
AddCSLuaFile()

ENT.Type		= "anim"
ENT.Base		= "base_ai"
ENT.PrintName	= "Mine"
ENT.Author		= "Matt"
ENT.Spawnable	= true
ENT.AdminOnly	= true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end 
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/midage/objects/vein/vein.mdl" )
		self.Entity:SetMaterial( "models/midage/objects/vein/tin" )

		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
		end

		self.Entity:GetPhysicsObject():EnableMotion( false )

		if not self.Mine then
			local item = math.random( 1, #FurnaceIngredients_Server )
			local item = FurnaceIngredients_Server[ item ]
			self.Mine = item
			self.Entity:SetColor( Color( item.R, item.G, item.B, item.A ) )
		end
		self.Name = self.Mine.Name
	end

	function ENT:Think()
		if self.Name ~= self.Mine.Name then
			self.Name = self.Mine.Name
		end
	end
end