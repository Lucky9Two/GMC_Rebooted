
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Frying Pan"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminOnly = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/props_c17/metalPot002a.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 7 )
		end
		self.Pot = true
		self.Name = "Frying Pan"
			self.Entity:SetNWString( "name", self.Name )
	end

	function ENT:Think()
		if self.NextThinks and self.NextThinks > CurTime() then return end

		if self.InStove then
			--if self.Entity:CheckOnStove() then
				self.Entity:Cook()
			--end
			self.InStove = false
		end

		if not self.Food or not self.Food:IsValid() then
			self.Entity.DisableBackpackable = false
		elseif self.Food:GetParent() ~= self.Entity then
			self.Food = nil
		end

		self.NextThinks = CurTime() + 1 -- Once a second.
	end

	function ENT:CheckOnStove()
		local tr
			local pos = self.Entity:GetPos()
			local ang = Angle( 0, 0, -90 )
			local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos+( ang*10 )
				if self.Food and self.Food:IsValid() then
					tracedata.filter = { self.Entity, self.Food }
				else
					tracedata.filter = self.Entity
				end
			tr = util.TraceLine( tracedata )
		if tr.HitNonWorld and tr.Entity:GetClass() == "gmc_stove" and tr.HitPos:Distance( self.Entity:GetPos() ) <= 10 then
			return true
		else
			return false
		end
	end

	function ENT:Cook()
		if self.Food and self.Food:IsValid() then
			if not self.Food.CurTime then self.Food.CurTime = 0 end
			self.Food.CurTime = self.Food.CurTime + 1
			if self.Food.CurTime >= self.Food.CookTime and not self.Food.Cooked and not self.Food.Burnt then -- Cooked! :D
				self.Food.Cooked = true
				self.Food.Name = "Fried "..self.Food.Name
					self.Food:SetNWString( "name", self.Food.Name )
				if self.Food.DoCook then self.Food.DoCook( self.Food ) end
			end
			if self.Food.Cooked and not self.Food.Burnt and self.Food.CurTime >= math.floor( self.Food.CookTime + self.Food.BurnTime ) then -- Burnt! D:
				self.Food.Burnt = true
				self.Food.Cooked = false
				self.Food.Name = string.gsub( self.Food.Name, "Fried ", "" )
					self.Food.Name = "Burnt "..self.Food.Name
					self.Food:SetNWString( "name", self.Food.Name )
				if self.Food.DoBurn then self.Food.DoBurn( self.Food ) end
			end
		end
	end

	function ENT:StartTouch( ent )
		if ( not self.Food or not self.Food:IsValid() ) and ( ent.Food and not ent.Cooked ) then
			for k, v in pairs( StoveRecipes_Server ) do
				if v.Name == ent.Name then
					ent.CookTime = v.CookTime
					ent.DoCook = v.DoCook
					ent.BurnTime = v.BurnTime
					ent.DoBurn = v.DoBurn

					for _, i in pairs( v.Types ) do
						if string.lower( i ) == "fry" or string.lower( i ) == "all" then -- Is it fryable?
							local angles = self.Entity:GetAngles()
							self.Entity:SetAngles( Angle( 0, 0, 180 ) )
								ent:SetPos( self.Entity:GetPos() + Vector( 5, 0, 0.5 ) )
								ent:SetAngles( Angle( 0, 0, 0 ) )
								ent:SetParent( self.Entity )
								ent.Pan = self.Entity
								ent.DisableHands = true
								self.Food = ent
								self.Entity.DisableBackpackable = true
								if v.DoPot then v.DoPot( ent ) end -- Function when food placed in pot
							self.Entity:SetAngles( angles )
							break
						end
					end
					break
				end
			end
		end
	end
end