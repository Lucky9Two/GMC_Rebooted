
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Bush"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminOnly = true 

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

	function ENT:Draw()
		self.Entity:DrawModel()
	end
else

	function ENT:Initialize()
		local model = "models/props/de_inferno/LargeBush02.mdl"
			if self.Name then
				for k, v in pairs( Plants_Server ) do
					if v.Name == self.Name and v.PlantModel then
						model = v.PlantModel
					end
				end
			end
		self.Entity:SetModel( model )
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

		self.FruitSpawns = {}
			table.insert( self.FruitSpawns, Vector( -9, -17, 30 ) )
			table.insert( self.FruitSpawns, Vector( -3, 21, 24 ) )
			table.insert( self.FruitSpawns, Vector( 15, -6, 25 ) )
		timer.Create( tostring( self.Entity ).." Grow", 60, 1, function()
			if self.Entity and self.Entity:IsValid() then
				self.LifeTime = CurTime()+600
				self.NextFruit = CurTime()+120
			end
		end )
	end

	-- Watering/fertilizer?
	-- Priest fertilizing/keeping alive longer?

	function ENT:Think()
		if self.LifeTime then
			if self.NextFruit < CurTime() then
				self.Entity:GrowFruit()
				self.NextFruit = CurTime()+60
			end

			if self.LifeTime < CurTime() then -- Remove after lifetime
				self.Entity:Remove()
			end
		end
	end

	function ENT:GrowFruit()
		if not self.Items then
			self.Items = {}
		end

		for k, v in pairs( self.Items ) do
			if not v:IsValid() then
				table.remove( self.Items, k )
			end
		end

		if #self.Items ~= 3 then
			local PossibleSpawns = self.FruitSpawns
			for k, ent in pairs( self.Items ) do
				for _, v in pairs( PossibleSpawns ) do
					if ent:IsValid() and ent.BushSpawn and ent.BushSpawn == v then
						table.remove( PossibleSpawns, _ )
					end
				end
			end
			if not PossibleSpawns or not PossibleSpawns[ 1 ] then return end

			local model
			if Plants_Server then
				for k, v in pairs( Plants_Server ) do
					if v.Name == self.FruitName then
						model = v.Model
					end
				end
			end
			if not model then return end

			local angles = self.Entity:GetAngles()
			self.Entity:SetAngles( Angle( 0, 0, 0 ) )

			local item = ents.Create( "gmc_resource" )
			item:SetModel( model )
			item:SetPos( self.Entity:GetPos() + PossibleSpawns[ 1 ] )
				item.BushSpawn = PossibleSpawns[ 1 ]
			item:SetParent( self.Entity )
			item.Name = self.FruitName
				item:SetNWString( "name", self.FruitName )
			item:Spawn()
			local phys = item:GetPhysicsObject()
				if phys:IsValid() then
					phys:EnableMotion( false )
				end
			item:Activate()
			table.insert( self.Items, item )

			self.Entity:SetAngles( angles )
		end
	end
end