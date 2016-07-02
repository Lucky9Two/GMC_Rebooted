
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Seed"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminOnly = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/medieval/items/seed.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1 )
		end
	end

	function ENT:Think()
		if self.Planted then
			local planttype
			local model
				for k, v in pairs( Plants_Server ) do
					if v.Name == string.gsub( self.Name, " Seed", "" ) then
						planttype = v.Type
						if v.PlantModel then
							model = v.PlantModel
						else
							model = v.Model
						end
					end
				end
			local name = string.gsub( self.Name, "Seed", "Plant" )
			if planttype == "Bush" then
				local plant = ents.Create( "gmc_plant_bush" )
				plant:SetPos( self.Entity:GetPos() )
				plant.Name = name
				plant.Owner = self.Owner
				plant:Spawn()
				self.Entity:InitPlant( plant, name )
			elseif planttype == "Underground" then
				local plant = ents.Create( "gmc_plant_underground" )
				plant:SetPos( self.Entity:GetPos() )
				plant.Name = name
				plant.Owner = self.Owner
				plant:Spawn()
				self.Entity:InitPlant( plant, name )
			elseif planttype == "Overground" then
				for i = 1, math.random( 3, 5 ) do
					local plant = ents.Create( "gmc_plant" )
					plant:SetPos( self.Entity:GetPos() + Vector( math.random( -50, 50 ), math.random( -50, 50 ), math.random( -5, -1 ) ) )
					plant:SetAngles( Angle( math.random( -5, 5 ), math.random( -180, 180 ), math.random( -5, 5 ) ) )
					plant:SetModel( model )
					self.Entity:InitPlant( plant, name )
				end
			end

			
			local item = table.Random( Plants_Server )
				while item.Type ~= "Weed" do -- Tried making a new table, removing item.Type == "Weed"s, but didn't work, this is shorted anyway.
					item = table.Random( Plants_Server )
				end
				local name = item.Name
				local model = item.Model
			for i = 1, math.random( 3, 5 ) do
				local plant = ents.Create( "gmc_plant" )
				plant:SetPos( self.Entity:GetPos() + Vector( math.random( -30, 30 ), math.random( -30, 30 ), 0 ) )
				plant:SetAngles( Angle( math.random( -5, 5 ), math.random( -180, 180 ), math.random( -5, 5 ) ) )
				plant:SetModel( model )
				self.Entity:InitPlant( plant, name )
			end
			self.Entity:Remove()
		end
	end

	function ENT:InitPlant( plant, name )
		plant.Name = name
		plant.Owner = self.Owner
		plant:Spawn()
		if not Entity_OnGround( plant ) then -- Ensure plant is on the ground.
			print( "Not on ground! D:" )
			plant:SetPos( Entity_FindGround( plant ) )
		end
	end
end