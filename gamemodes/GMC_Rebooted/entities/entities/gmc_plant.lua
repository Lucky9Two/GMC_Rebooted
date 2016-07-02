
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Plant"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminSpawnable = true 

if CLIENT then
	function ENT:Initialize()
		self.Size = 0
		self.Entity:SetModelScale( Vector( self.Size, self.Size, self.Size ) )
		timer.Create( tostring( self.Entity ).." growth", 6, 10, function()
			if self.Entity and self.Entity:IsValid() and self.Size then
				self.Size = self.Size + 0.1
				self.Entity:SetModelScale( Vector( self.Size, self.Size, self.Size ) )
			end
		end )
	end
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion( false )
		end
		self.FruitName = string.gsub( self.Name, " Plant", "" )
		timer.Create( tostring( self.Entity ).." Grow", 60, 1, function()
			local item = ents.Create( "gmc_resource" )
			item:SetModel( self.Entity:GetModel() )
			item:SetPos( self.Entity:GetPos() )
			item:SetAngles( self.Entity:GetAngles() )
			item.Name = self.FruitName
				item:SetNWString( "name", self.FruitName )
			item:Spawn()
			local phys = item:GetPhysicsObject()
				if phys:IsValid() then
					phys:EnableMotion( false )
				end
			item:Activate()

			self.Entity:Remove()
		end )
	end
end
