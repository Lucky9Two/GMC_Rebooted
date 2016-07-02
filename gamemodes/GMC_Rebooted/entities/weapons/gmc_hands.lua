
AddCSLuaFile()

if CLIENT then
	local	_SELFENTNAME	= "gmc_hands"
	local	_INFONAME		= "Hands"
	SWEP.Category			= "GMC: Rebooted"
	SWEP.PrintName			= _INFONAME
	SWEP.Author   			= "V92, Omen, Matt"
	SWEP.Contact        	= "V92"
	SWEP.Instructions 		= "Secondary to pick up or drop objects\nPrimary to throw the object you're holding\nReload to straighten the object you're holding"
	SWEP.Slot 				= 0
	SWEP.SlotPos 			= 3
	SWEP.ViewModelFOV		= 70
	SWEP.DrawCrosshair 		= true
	SWEP.DrawAmmo			= false
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/hud/" .. _SELFENTNAME )

	language.Add( _SELFENTNAME, _INFONAME )	
	killicon.Add( _SELFENTNAME, "vgui/entities/".. _SELFENTNAME , Color( 255, 255, 255 ) )
else
	SWEP.Weight				= 0
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false
	SWEP.Spawnable			= true
	SWEP.AdminOnly			= false
end

SWEP.HoldType				= "fists"
SWEP.ViewModel				= Model("")
SWEP.WorldModel				= Model("")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ""

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()

end

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end

if SERVER then -- Not made by me... Original author unknown :/ -- TODO: Remake it?
	local pullRange		 = 128
	local holdRange		 = 64
	local throwStrength	 = 10
	local pullStrength	 = 50

	function agagaDrop( ply )
		if ply.GrabbedEnt then
			ply.GrabbedPhys:EnableGravity( true )
			ply.GrabbedPhys:SetVelocity( ply.GrabbedPhys:GetVelocity()*throwStrength-ply:GetVelocity()*( throwStrength-1 ) )
			if ply:KeyDown( IN_ATTACK ) then
				ply.GrabbedPhys:SetVelocity( ply:GetAimVector()*throwStrength*40 + ply:GetVelocity() )
			end
			ply.GrabbedEnt = nil
		end
	end

	local function agagaThink()
		for _, ply in pairs( player.GetAll() ) do
			if ply:Alive() then
				if ply.GrabChange and not ply:KeyDown( IN_ATTACK2 ) then
					ply.GrabChange = false
				end
				if ply:GetActiveWeapon() and ply:GetWeapon( "gmc_hands" ) == ply:GetActiveWeapon() then
					ply:DrawViewModel( false )
					-- If I am grabbing something
					if ply.GrabbedEnt then
						ply:GetActiveWeapon():SetNextPrimaryFire( CurTime()+1 )
						ply:GetActiveWeapon():SetNextSecondaryFire( CurTime()+1 )
						ent = ply.GrabbedEnt
						if ent:IsValid() then
							if string.find( ent:GetClass(), "gmc_" ) then -- Unparent on pickup
								ent:SetParent()
							end

							phys = ply.GrabbedPhys
							if ent:GetMoveType() == MOVETYPE_VPHYSICS then
								if ( ( ply:KeyDown( IN_ATTACK2 ) or ply:KeyDown( IN_ATTACK ) or ply:KeyDown( IN_ATTACK2 ) or ply:KeyDown( IN_ALT1 ) or ply:KeyDown( IN_ALT2 ) ) and not ply.GrabChange ) or ply:InVehicle() then
									agagaDrop( ply )
									ply.GrabChange = true
								else
									local tracedata = {}
									tracedata.start = ply:EyePos()
									tracedata.endpos = ply:EyePos()+( ply:GetAimVector()*( holdRange+ply.GrabbedEnt:BoundingRadius() ) )
									tracedata.filter = {ply, ply.GrabbedEnt}
									local trace = util.TraceLine( tracedata )
									dist = trace.HitPos:Distance( ply:EyePos() )
									dist = dist-ply.GrabbedEnt:BoundingRadius()
									if dist>holdRange then dist = holdRange end
									pos = ply:EyePos()+ply:GetAimVector()*dist-phys:GetMassCenter()
									vel = ply:GetVelocity()+( ply:EyePos()+ply:GetAimVector()*dist-phys:GetPos()-phys:GetMassCenter() )*4
									ang = ply:GetAimVector():Angle()
									ang.x = 0
									phys:SetPos( pos )
									phys:SetVelocity( vel )
								end
								if ply:KeyDown( IN_RELOAD ) and ply.GrabbedEnt ~= nil then
									local tracedata = {}
									tracedata.start = ply:EyePos()
									tracedata.endpos = ply:EyePos()+( ply:GetAimVector()*( holdRange+ply.GrabbedEnt:BoundingRadius() ) )
									tracedata.filter = {ply, ply.GrabbedEnt}
									local trace = util.TraceLine( tracedata )
									dist = trace.HitPos:Distance( ply:EyePos() )
									dist = dist-ply.GrabbedEnt:BoundingRadius()
									if dist>holdRange then dist = holdRange end
									pos = ply:EyePos()+ply:GetAimVector()*dist-phys:GetMassCenter()
									vel = ply:GetVelocity()+( ply:EyePos()+ply:GetAimVector()*dist-phys:GetPos()-phys:GetMassCenter() )*4
									ang = ply:GetAimVector():Angle()
									ang.x = 0
									phys:SetPos( pos )
									ang = ply:GetAimVector():Angle()
									ang.x = 0
									phys:SetAngle( ang )
								end
							else
								ply.GrabbedEnt = nil
							end
						else
							ply.GrabbedEnt = nil
						end
					else
						ply:DrawViewModel( false )
						ent = nil -- Find an entity
							local trace = ply:GetEyeTrace()
							if trace.HitNonWorld and not trace.Entity.DisableHands then
								local phys = trace.Entity:GetPhysicsObject()
								if phys and phys:IsValid() then
									if phys:GetMass() < 9 then
										local dist = ply:GetPos():Distance( trace.Entity:GetPos() )
										if dist <= pullRange then
											ent = trace.Entity
										end
									end
								end
							end
							if not ent then
								local distance
								local trace = ply:GetEyeTrace( 150 )
								for k, v in pairs( ents.FindInSphere( trace.HitPos, pullRange ) ) do
									if v ~= ply and v:IsValid() and v:GetPhysicsObject():IsValid() and v:GetMoveType() == MOVETYPE_VPHYSICS then
										if not v.DisableHands and v:GetPhysicsObject():GetMass() < 9 then
											local dist = ply:GetPos():Distance( v:GetPos() ) -- Find closest ent.
											if not distance or dist < distance then
												ent = v
												distance = dist
											end
										end
									end
								end
							end
						-- found something suitable.
						if ent then
							local v = {}
							v.start = ply:GetShootPos()
							v.endpos = v.start + ply:GetAimVector() * pullRange
							v.filter = ply
							v = util.TraceLine( v )
							if v.Entity == ent then
								phys = ent:GetPhysicsObjectNum( v.PhysicsBone )
							else
								phys = ent:GetPhysicsObject()
							end
							if ply:KeyDown( IN_ATTACK2 ) and not ply.GrabChange then
								if phys then
									if ( phys:GetPos() + phys:GetMassCenter() ):Distance( ply:EyePos() ) <= holdRange then
										ply.GrabbedEnt = ent
										ply.GrabbedPhys = phys
										phys:EnableGravity( false )
										ply.GrabChange = true
									elseif v.HitPos:Distance( ply:EyePos() ) <= pullRange then
										pulldir = ( ( ply:EyePos()+ply:GetAimVector():Normalize()*64 )-( phys:GetPos()+phys:GetMassCenter() ) ):Normalize()
										phys:ApplyForceCenter( ( pulldir * pullStrength ) * phys:GetMass() )
									end
								end
							end
						end
					end
				else
					agagaDrop( ply )
				end
			end
		end
	end
	hook.Add( "Think", "agagaThink", agagaThink )
end