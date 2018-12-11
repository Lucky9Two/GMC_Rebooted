
AddCSLuaFile()

ENT.Type				= "anim"
ENT.Base				= "base_ai"

if CLIENT then
	ENT.PrintName		= "Fire"
	ENT.Author			= "Matt"
end

ENT.Spawnable			= true
ENT.AdminOnly			= true 

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetColor( 0, 0, 0, 0 )
end