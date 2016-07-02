
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Spawner"
ENT.Author = "Matt"
ENT.Spawnable = true
ENT.AdminOnly = true 

if CLIENT then
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/props_c17/oildrum001.mdl" )
			self.Entity:PhysicsInit( SOLID_VPHYSICS )
			self.Entity:SetNotSolid( true )
			self.Entity:SetNoDraw( true )
			self.Entity:DrawShadow( false )
			self.Entity:SetCollisionGroup(  COLLISION_GROUP_WORLD  )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
		end
		self.Entity:GetPhysicsObject():EnableMotion( false )

		self.Ents = {}
		if self.Forest and self.Forest == "forest" then
			for i = 1, math.random( 5, 10 ) do
				self.Ents[ i ] = ents.Create( "gmc_tree" )
				self.Ents[ i ]:Spawn()
				self.Ents[ i ]:SetPos( self.Entity:GetPos() + Vector( math.random( -540, 540 ), math.random( -540, 540 ), -1 ) )
				self.Ents[ i ]:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
			end
		else
			if GMC_Mines then
				GMC_Mines = GMC_Mines + 1
			else
				GMC_Mines = 0
			end
			local random = math.random( 1, #FurnaceIngredients_Server )
			for i = 1, math.random( 3, 5 ) do
				self.Ents[ i ] = ents.Create( "gmc_mine" )
				self.Ents[ i ]:Spawn()
				self.Ents[ i ]:SetPos( self.Entity:GetPos() + Vector( math.random( -180, 180 ), math.random( -180, 180 ), math.random( -8, -1 ) ) )
				self.Ents[ i ]:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
				if GMC_Mines < #FurnaceIngredients_Server then
					item = FurnaceIngredients_Server[ GMC_Mines+1 ]
					self.Ents[ i ].Mine = item
					self.Ents[ i ]:SetColor( Color( item.R, item.G, item.B, item.A ) )
				else
					item = FurnaceIngredients_Server[ random ]
					self.Ents[ i ].Mine = item
					self.Ents[ i ]:SetColor( Color( item.R, item.G, item.B, item.A ) )
				end
			end
		end
	end

	function ENT:OnRemove()
		for k, v in pairs( self.Ents ) do
			if v:IsValid() then v:Remove() end
		end
	end
end