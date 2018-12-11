
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Building"
ENT.Author = "Matt"
ENT.Spawnable = true
ENT.AdminOnly = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end

	function ENT:Think()
		if self.Entity:GetModel() ~= "models/error.mdl" then
			if self.Entity:GetNWInt( "building" ) >= 10 then
				self.Entity:SetModelScale( Vector( 1, 1, 1 ) )
				if self.Scafolding and self.Scafolding:IsValid() then
					self.Scafolding:Remove()
					self.Scafolding = nil
				end
			elseif self.Entity:GetNWInt( "building" ) >= 0 then
				self.Entity:SetModelScale( Vector( 1, 1, math.Clamp( self.Entity:GetNWInt( "building" )/10, 0.1, 1 ) ) )
				if self.Scafolding and self.Scafolding:IsValid() then
					self.Scafolding:SetPos( self.Entity:GetPos() )
					self.Scafolding:SetAngles( self.Entity:GetAngles() )
				else
					self.Scafolding = ClientsideModel( self.Entity:GetModel(), RENDERGROUP_OPAQUE )
					self.Scafolding:Spawn()
					self.Scafolding:Activate()
					self.Scafolding:SetPos( self.Entity:GetPos() )
					self.Scafolding:SetAngles( self.Entity:GetAngles() )
					self.Scafolding:SetColor( 255, 255, 255, 100 )
				end
			end
		end
	end

	function ENT:OnRemove()
		if self.Scafolding and self.Scafolding:IsValid() then self.Scafolding:Remove() end
	end

	function MakeGateMenu( msg )
		local DFrame1 = vgui.Create( "DFrame" )
		DFrame1:SetSize( 110, 96 )
		DFrame1:Center()
		DFrame1:SetTitle( "Wall" )
		DFrame1:SetDraggable( true )
		DFrame1:SetSizable( false )
		DFrame1:SetDeleteOnClose( false )
		DFrame1:SetVisible( true )
		DFrame1:ShowCloseButton( true )
		DFrame1:MakePopup()

		local DButton1 = vgui.Create( "DButton" )
		DButton1:SetParent( DFrame1 )
		DButton1:SetSize( 70, 20 )
		DButton1:SetPos( 20, 36 )
		DButton1:SetText( "Create Gate" )
		DButton1.DoClick = function()
			DFrame1:SetVisible( false )

			local DFrame1 = vgui.Create( "DFrame" )
			DFrame1:SetSize( 200, 110 )
			DFrame1:Center()
			DFrame1:SetTitle( "Gate" )
			DFrame1:SetDraggable( true )
			DFrame1:ShowCloseButton( true )
			DFrame1:SetSizable( false )
			DFrame1:SetDeleteOnClose( false )
			DFrame1:SetVisible( true )
			DFrame1:MakePopup()

			local DLabel1 = vgui.Create( "DLabel", DFrame1 )
			DLabel1:SetPos( 20, 40 )
			DLabel1:SetText( "Are you sure?" )
			DLabel1:SizeToContents()

			local DButton1 = vgui.Create( "DButton", DFrame1 )
			DButton1:SetSize( 85, 25 )
			DButton1:SetPos( 10, 60 )
			DButton1:SetText( "Yes" )
			DButton1.DoClick = function()
				LocalPlayer():ConCommand( "gmc_makegate" )
				DFrame1:SetVisible( false )
			end

			local DButton2 = vgui.Create( "DButton", DFrame1 )
			DButton2:SetSize( 85, 25 )
			DButton2:SetPos( 105, 60 )
			DButton2:SetText( "Cancel" )
			DButton2.DoClick = function()
				DFrame1:SetVisible( false )
			end
		end

		local DButton2 = vgui.Create( "DButton" )
		DButton2:SetParent( DFrame1 )
		DButton2:SetSize( 70, 20 )
		DButton2:SetPos( 20, 66 )
		DButton2:SetText( "Cancel" )
		DButton2.DoClick = function()
			DFrame1:SetVisible( false )
		end
	end
	usermessage.Hook( "MakeGateMenu", MakeGateMenu )

	function BuildingOwnershipMenu( msg )
		local index = tonumber( msg:ReadLong() )

		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 250, 200 )
		DFrame:Center()
		DFrame:SetTitle( "Ownership" )
		DFrame:SetDraggable( true )
		DFrame:SetSizable( false )
		DFrame:SetDeleteOnClose( false )
		DFrame:SetVisible( true )
		DFrame:ShowCloseButton( true )
		DFrame:MakePopup()

		local DList = vgui.Create( "DPanelList", DFrame )
		DList:SetPos( 3, 25 )
		DList:SetSize( DFrame:GetWide() - 6, DFrame:GetTall() - 28 )
		DList:SetSpacing( 2 )
		DList:SetPadding( 4 )
		DList:EnableHorizontal( true )
		DList:EnableVerticalScrollbar( true )

		for k, v in pairs( player.GetAll() ) do
			if v ~= LocalPlayer() then
				local DIcon = vgui.Create( "SpawnIcon" )
				DIcon:SetIconSize( 64 )
				DIcon:SetModel( v:GetModel() )
				local info = "Name: "..v:Nick()
					if v:GetNWString( "name" ) and v:GetNWString( "name" ) ~= "" then
						info = info.."\nRoleplay Name: "..v:GetNWString( "name" )
					end
				DIcon:SetToolTip( info )
				DIcon.DoClick = function()
					local OptionsMenu = DermaMenu()
						OptionsMenu:AddOption( "Give building ownership", function()
							DFrame:SetVisible( false )

							LocalPlayer():ConCommand( "GMC_GiveOwnership "..string.char( 34 )..v:EntIndex()..string.char( 34 ).." "..string.char( 34 )..index..string.char( 34 ) )
						end )
					OptionsMenu:Open()
				end
				DList:AddItem( DIcon )
			end
		end
	end
	usermessage.Hook( "BuildingOwnershipMenu", BuildingOwnershipMenu )
else
	function ENT:Initialize()
		if GMC_Buildings then
			for k, v in pairs( GMC_Buildings ) do
				if self.Building == v.Name then
					self.Entity:SetModel( v.Model )
					self.Entity:PhysicsInit( SOLID_VPHYSICS )
					self.Entity:SetMoveType( MOVETYPE_NONE )
					self.Entity:SetSolid( SOLID_VPHYSICS )

					local phys = self.Entity:GetPhysicsObject()
						if phys and phys:IsValid() then
							phys:Wake()
							phys:SetMass( 1000 )
							phys:EnableMotion( false )
						end
					self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
				end
			end
		end

		self.Entity:SetNWInt( "building", 1 )
		self.Resource1s = 0
		self.Resource2s = 0
		self.Resource3s = 0
		self.Resource4s = 0
	end

	function ENT:Think()
		self.LastResource = self.LastResource or 0
		if self.LastResource ~= total2 then
			if GMC_Buildings then
				for k, v in pairs( GMC_Buildings ) do
					local total1 = v.Resource1s + v.Resource2s + v.Resource3s + v.Resource4s
					local total2 = self.LastResource
					if self.Building == v.Name then
						local building = math.Clamp( math.floor( ( ( 100/total1 )*total2 )/10 ), 0, 10 )
						self.Entity:SetNWInt( "building", building )
						self.LastResource = self.Resource1s + self.Resource2s + self.Resource3s + self.Resource4s
						self.Entity:SetNWInt( "res1", self.Resource1s )
						self.Entity:SetNWInt( "res2", self.Resource2s )
						self.Entity:SetNWInt( "res3", self.Resource3s )
						self.Entity:SetNWInt( "res4", self.Resource4s )
					end
				end
			end
		end

		if self.Entity:GetNWInt( "building" ) == 10 and not self.Extras then
			local oldangle = self.Entity:GetAngles()
			self.Entity:SetAngles( Angle( 0, 0, 0 ) )
				if self.Building then
					if !GMC_BuildingExtras then GMC_BuildingExtras = {} end
					for k, v in pairs( GMC_BuildingExtras ) do
						if v.Building == self.Building then
							local ent = ents.Create( v.ENT )
							ent:SetModel( v.Model )
							ent:Spawn()
							ent:SetPos( self.Entity:GetPos() + Vector( v.X, v.Y, v.Z ) )
							ent:SetAngles( self.Entity:GetAngles() + Angle( v.AP, v.AY, v.AR ) )
							ent:SetParent( self.Entity )
							ent:SetCollisionGroup( COLLISION_GROUP_NONE )
							ent.Name = v.Name
							ent.Owner = self.Entity.Owner
						end
					end
				end
			self.Entity:SetAngles( oldangle )
			self.Extras = true
			self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
		end

		if self.Owner and self.Owner:IsValid() then
			local name = self.Owner:Nick().." ("..self.Owner:GetNWString( "name" )..")"
			if self.Entity:GetNWString( "name" ) ~= name then
				self.Entity:SetNWString( "name", name )
			end
			if timer.IsTimer( self.Entity:EntIndex().."TimedRemoval" ) then
				timer.Remove( self.Entity:EntIndex().."TimedRemoval" )
			end
		else
			self.Entity:SetNWString( "name", "Nobody" )
			if not timer.IsTimer( self.Entity:EntIndex().."TimedRemoval" ) then
				timer.Create( self.Entity:EntIndex().."TimedRemoval", 300, 1, function()
					if self.Entity and self.Entity:IsValid() then
						self.Entity:Remove()
					end
				end )
			end
		end
	end

	function ENT:Use( activator, caller )
		self.NextUse = self.NextUse or 0
		if CurTime() > self.NextUse then else return end

		self.NextUse = CurTime() + 1

		if activator == self.Owner or HasPermission( activator, "Building", self.Owner ) then
			if activator:KeyDown( IN_SPEED ) then
				umsg.Start( "BuildingOwnershipMenu", activator )
					umsg.Long( self.Entity:EntIndex() )
				umsg.End()
			else
				if ( self.Entity:GetModel() == "models/medieval/wall/small/wall.mdl" or self.Entity:GetModel() == "models/medieval/wall/medium/wall.mdl" ) and self.Entity:GetNWInt( "building" ) == 10 then
					umsg.Start( "MakeGateMenu", activator )
					umsg.End()
				end
			end
		elseif not self.Owner or not self.Owner:IsValid() then
			self.Owner = activator
		end
	end

	function MakeGate( ply )
		local bulent = ply:GetEyeTrace().Entity
		if bulent and ( bulent.Owner == ply or HasPermission( ply, "Building", bulent.Owner ) ) then
			local gent = ents.Create( "gmc_building_gate" )

			if gent and string.find( bulent:GetModel(), "wall.mdl" ) then
				if bulent:GetModel() == "models/medieval/wall/small/wall.mdl" then
					gent:SetModel( "models/medieval/wall/small/gate.mdl" )
				elseif bulent:GetModel() == "models/medieval/wall/medium/wall.mdl" then
					gent:SetModel( "models/medieval/wall/medium/gate.mdl" )
				end

				gent:Spawn()
				gent:Activate()
				gent:SetPos( bulent:GetPos() )
				gent:SetAngles( bulent:GetAngles() )
				gent.Building = bulent.Building
				gent.Owner = bulent.Owner
				bulent:Remove()
			end
		end
	end
	concommand.Add( "gmc_makegate", MakeGate )

	function Building_GiveOwnership( ply, cmd, args ) -- In both gmc_building and gmc_building_gate
		local index1 = tonumber( args[ 1 ] )
		local index2 = tonumber( args[ 2 ] )
		if not index1 or not index2 then return end

		local entity
		local ply2
			for k, v in pairs( ents.GetAll() ) do
				if v:EntIndex() == index2 then
					entity = v
				end
			end
			for k, v in pairs( player.GetAll() ) do
				if v:EntIndex() == index1 then
					ply2 = v
				end
			end
		if not entity or not ply2 then return end

		entity.Owner = ply2 -- All that ^ for one line..?
	end
	concommand.Add( "GMC_GiveOwnership", Building_GiveOwnership )
end