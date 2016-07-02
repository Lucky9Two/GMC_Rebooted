
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Gate"
ENT.Author = "Matt"
ENT.Spawnable = true
ENT.AdminOnly = true 

if CLIENT then
	function ENT:Draw()	self.Entity:DrawModel()	end

	function GateMenu( msg )
		local DFrame1 = vgui.Create( "DFrame" )
		DFrame1:SetSize( 110, 126 )
		DFrame1:Center()
		DFrame1:SetTitle( "Gate" )
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
		DButton1:SetText( "Lock" )
		DButton1.DoClick = function()
			DFrame1:SetVisible( false )

			LocalPlayer():ConCommand( "gmc_lockgate" )
		end

		local DButton2 = vgui.Create( "DButton" )
		DButton2:SetParent( DFrame1 )
		DButton2:SetSize( 70, 20 )
		DButton2:SetPos( 20, 66 )
		DButton2:SetText( "Unlock" )
		DButton2.DoClick = function()
			DFrame1:SetVisible( false )

			LocalPlayer():ConCommand( "gmc_unlockgate" )
		end

		local DButton3 = vgui.Create( "DButton" )
		DButton3:SetParent( DFrame1 )
		DButton3:SetSize( 70, 20 )
		DButton3:SetPos( 20, 96 )
		DButton3:SetText( "Cancel" )
		DButton3.DoClick = function()
			DFrame1:SetVisible( false )
		end
	end
	usermessage.Hook( "GateMenu", GateMenu )

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
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
			phys:EnableMotion( false )
		end

		self.Locked = false
		self.Open = false
	end

	function ENT:Think()
		local playerinrange
		for k, ply in pairs( ents.FindInSphere( self.Entity:GetPos(), 200 ) ) do
			if ply:IsPlayer() and ( not self.Owner or ply == self.Owner or HasPermission( ply, "Gates", self.Owner ) ) then
				playerinrange = true
			end
		end

		if not playerinrange or self.Locked then
			if self.Entity:GetModel() == "models/medieval/wall/small/gate.mdl" then
				self.Entity:SetModel( "models/medieval/wall/small/wall.mdl" )
				self.Entity:PhysicsInit( SOLID_VPHYSICS )
				self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
				self.Entity:SetSolid( SOLID_VPHYSICS )
				local phys = self.Entity:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:Wake()
					phys:SetMass( 1000 )
					phys:EnableMotion( false )
				end
			elseif self.Entity:GetModel() == "models/medieval/wall/medium/gate.mdl" then
				self.Entity:SetModel( "models/medieval/wall/medium/wall.mdl" )
				self.Entity:PhysicsInit( SOLID_VPHYSICS )
				self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
				self.Entity:SetSolid( SOLID_VPHYSICS )
				local phys = self.Entity:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:Wake()
					phys:SetMass( 1000 )
					phys:EnableMotion( false )
				end
			end
		else
			if self.Entity:GetModel() == "models/medieval/wall/small/wall.mdl" then
				self.Entity:SetModel( "models/medieval/wall/small/gate.mdl" )
				self.Entity:PhysicsInit( SOLID_VPHYSICS )
				self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
				self.Entity:SetSolid( SOLID_VPHYSICS )
				local phys = self.Entity:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:Wake()
					phys:SetMass( 1000 )
					phys:EnableMotion( false )
				end
			elseif self.Entity:GetModel() == "models/medieval/wall/medium/wall.mdl" then
				self.Entity:SetModel( "models/medieval/wall/medium/gate.mdl" )
				self.Entity:PhysicsInit( SOLID_VPHYSICS )
				self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
				self.Entity:SetSolid( SOLID_VPHYSICS )
				local phys = self.Entity:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:Wake()
					phys:SetMass( 1000 )
					phys:EnableMotion( false )
				end
			end
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

		if activator == self.Owner or HasPermission( activator, "Gates", self.Owner ) then
			if activator:KeyDown( IN_SPEED ) then
				umsg.Start( "BuildingOwnershipMenu", activator )
					umsg.Long( self.Entity:EntIndex() )
				umsg.End()
			else
				umsg.Start( "GateMenu", activator )
				umsg.End()
			end
		elseif not self.Owner:IsValid() then
			self.Owner = activator
		end
	end

	function LockGate( ply )
		local gate = ply:GetEyeTrace().Entity
		if gate.Owner == ply or HasPermission( ply, "Gates", gate.Owner ) then
			gate.Locked = true
		end
	end
	concommand.Add( "gmc_lockgate", LockGate )

	function UnlockGate( ply )
		local gate = ply:GetEyeTrace().Entity
		if gate.Owner == ply or HasPermission( ply, "Gates", gate.Owner ) then
			gate.Locked = false
		end
	end
	concommand.Add( "gmc_unlockgate", UnlockGate )

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