
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Chest"
ENT.Author = "Matt"
ENT.Spawnable = true
ENT.AdminOnly = true

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end
	function ChestSENT( msg )	end
	usermessage.Hook( "ChestSENT", ChestSENT )
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/medieval/items/chest.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
		end

		self.Entity:GetPhysicsObject():EnableMotion( false )
	end

	function ENT:Use( activator, caller )
		self.NextUse = self.NextUse or 0
		if CurTime() > self.NextUse then else return end
		self.NextUse = CurTime() + 1

		umsg.Start( "ChestSENT", activator )
		umsg.End()
	end
end
