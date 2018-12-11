
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Stove"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminOnly = false

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/medieval/items/cooker.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
			phys:EnableMotion( false )
		end
		self.BackpackDisallow = true

		-- local angles = self.Entity:GetAngles()
		-- self.Entity:SetAngles( Angle( 0, 0, 0 ) )
			-- -- Frying Pan
				-- local ent = ents.Create( "gmc_fryingpan" )
				-- ent:SetPos( self.Entity:GetPos() + Vector( 5, 27, 36 )  )
				-- ent:SetAngles( self.Entity:GetAngles() + Angle( 0, -20, 0 ) )
				-- ent:Spawn()
				-- ent:Activate()
				-- ent:SetParent( self.Entity )
		-- self.Entity:SetAngles( angles )
	end

	function ENT:Think()
		self.Entity:SetupLogs()

		if self.On then
			local pos = self.Entity:GetPos() + ( self.Entity:GetUp()*61 )
			local min, max = pos - Vector( 60/2, 90/2, 55/2 ), pos + Vector( 60/2, 90/2, 55/2 )
			for k, v in pairs( ents.FindInBox( min, max ) ) do
				if v:IsPlayer() then -- BURN >:D
					-- v:Ignite( 1 )
				elseif v.Pot then
					v.InStove = true
				end
			end
		end
	end

	function ENT:SetupLogs()
		if not self.Logs or not self.Logs:IsValid() then
			local angles = self.Entity:GetAngles()
			self.Entity:SetAngles( Angle( 0, 0, 0 ) )
				self.Logs = ents.Create( "prop_physics" )
				self.Logs:SetModel( "models/medieval/items/cooker_logs.mdl" )
				self.Logs:Spawn()
				self.Logs:Activate()
				self.Logs:SetPos( self.Entity:GetPos() + Vector( 0, -20, 0 )  )
				self.Logs:SetAngles( self.Entity:GetAngles() )
				self.Logs:SetParent( self.Entity )
				self.Logs:SetCollisionGroup( COLLISION_GROUP_WORLD )
			self.Entity:SetAngles( angles )
		end
		if not self.Logs2 or not self.Logs2:IsValid() then
			local angles = self.Entity:GetAngles()
			self.Entity:SetAngles( Angle( 0, 0, 0 ) )
				self.Logs2 = ents.Create( "prop_physics" )
				self.Logs2:SetModel( "models/medieval/items/cooker_logs.mdl" )
				self.Logs2:Spawn()
				self.Logs2:Activate()
				self.Logs2:SetPos( self.Entity:GetPos() + Vector( 0, 20, 0 )  )
				self.Logs2:SetAngles( self.Entity:GetAngles() )
				self.Logs2:SetParent( self.Entity )
				self.Logs2:SetCollisionGroup( COLLISION_GROUP_WORLD )
			self.Entity:SetAngles( angles )
		end

		if self.On then
			if not self.Logs:IsOnFire() then
				self.Logs:Ignite( 100000000, 0 )
			end
			if not self.Logs2:IsOnFire() then
				self.Logs2:Ignite( 100000000, 0 )
			end
			if not self.FireEnt or not self.FireEnt:IsValid() then
				self.FireEnt = ents.Create( "gmc_fire" )
				self.FireEnt:SetModel( "models/medieval/items/cooker_logs.mdl" )
				self.FireEnt:Spawn()
				self.FireEnt:SetPos( self.Entity:GetPos() )
			end
		elseif self.FireEnt and self.FireEnt:IsValid() then
			self.FireEnt:Remove()
		end
	end

	function ENT:OnRemove()
		if self.Logs and self.Logs:IsValid() then
			self.Logs:Remove()
		end
		if self.Logs2 and self.Logs2:IsValid() then
			self.Logs2:Remove()
		end
	end

	function ENT:Use( activator, caller )
		if not self.NextUse or self.NextUse < CurTime() then
			if not self.Owner or activator == self.Owner then
				if self.On then
					self.On = false
					self.Logs:Extinguish()
					self.Logs2:Extinguish()
				else
					self.On = true
				end
			end
			self.NextUse = CurTime() + 0.5
		end
	end
end