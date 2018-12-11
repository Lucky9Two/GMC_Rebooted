
function EFFECT:Init( data )
	local targ 		= data:GetEntity()
	
	if (!ValidEntity(targ)) then return end
	
	self.pos 		= targ:GetPos()
	self.ent 		= targ
	self.Emitter 	= ParticleEmitter( self.pos , true )
	self.LifeTime	= CurTime() + 1
end

function EFFECT:Think()
	for i = 1 , 10 do
		local Vec = Vector(1,1,0)
		Vec:Rotate(Angle(0,math.random(-180,180),0))
		Vec.z = 0
	
		local particle2 = self.Emitter:Add( "effects/blueflare1" , self.pos + Vec * 20 )
		
		particle2:SetVelocity( Vector(0,0,20) )
		
		particle2:SetDieTime( 1 )
		
		particle2:SetStartAlpha( 250 )
		particle2:SetEndAlpha( 0 )
		
		particle2:SetStartSize( 70 )
		particle2:SetEndSize( 0 )
		
		particle2:SetAngles( Vec:Angle() )
		
		particle2:SetColor( 170 , 120 , 20 )
	end
	
	local dlight 			= DynamicLight( self.ent:EntIndex() )
	dlight.Pos 				= self.pos
	dlight.r 				= 170
	dlight.g 				= 170
	dlight.b 				= 20
	dlight.Brightness 		= 1
	dlight.Size 			= 512
	dlight.Decay 			= 2048
	dlight.DieTime 			= CurTime() + 0.1

	return (CurTime() < self.LifeTime)
end

function EFFECT:Render()
end




