
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Underground plant"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminOnly = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.FruitName = string.gsub( self.Name, " Plant", "" ) -- Used to find the plant's model

		local model = "models/medieval/items/mound.mdl"
			if self.Name then
				for k, v in pairs( Plants_Server ) do
					if v.Name == self.FruitName and v.PlantModel then
						model = v.PlantModel
					end
				end
			end
		self.Entity:SetModel( model )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion( false )
		end

		timer.Create( tostring( self.Entity ).." Grow", 120, 1, function()
			self.LifeTime = CurTime()+240
			HintPlayer( self.Owner, "One of your potato crops is ready to harvest." )
		end )
	end

	function ENT:Think()
		if self.LifeTime and self.LifeTime < CurTime() then
			self.Entity:Remove()
			HintPlayer( self.Owner, "One of your potato crops is dead." )
		end
	end

end