
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "Furnace"
ENT.Author = "Matt"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if CLIENT then

	function ENT:Draw()	self.Entity:DrawModel()	end

	function FurnaceSENT()
		local DFrame1 = vgui.Create( "DFrame" )
		DFrame1:SetSize( 500, 500 )
		DFrame1:Center()
		DFrame1:SetTitle( "Smelt Bars" )
		DFrame1:SetDraggable( true )
		DFrame1:ShowCloseButton( true )
		DFrame1:SetSizable( false )
		DFrame1:SetDeleteOnClose( false )
		DFrame1:SetVisible( true )
		DFrame1:MakePopup()

		local DList1 = vgui.Create( "DPanelList", DFrame1 )
		DList1:SetPos( 5, 30 )
		DList1:SetSize( DFrame1:GetWide() - 10, DFrame1:GetTall() - 35 )
		DList1:SetSpacing( 5 )
		DList1:SetPadding( 5 )
		DList1:EnableHorizontal( true )

		if FurnaceItems_Client then
			for k, v in pairs( FurnaceItems_Client ) do
				local SpawnIcon = vgui.Create( "SpawnIcon" )
				SpawnIcon:SetIconSize( 64 )
				SpawnIcon:SetModel( v.Model )
				local tooltip = "Name: "..v.Name.."\n".."Level: "..v.Level.."\n".."Recipe: "
					if v.Resource1 ~= "" then
						tooltip = tooltip.."\n"..v.Resource1..": "..v.Resource1s
					end
					if v.Resource2 ~= "" then
						tooltip = tooltip.."\n"..v.Resource2..": "..v.Resource2s
					end
					if v.Resource3 ~= "" then
						tooltip = tooltip.."\n"..v.Resource3..": "..v.Resource3s
					end
					if v.Resource4 ~= "" then
						tooltip = tooltip.."\n"..v.Resource4..": "..v.Resource4s
					end
				SpawnIcon:SetToolTip( tooltip )
				SpawnIcon.DoClick = function()
					local Options = {
										1, 
										5, 
										10, 
										15, 
										20, 
										50,
										100
									}
					local OptionMenu = DermaMenu()
						for _, o in pairs( Options ) do
							OptionMenu:AddOption( "Smelt "..o, function()
								LocalPlayer():ConCommand( "gmc_smelt "..string.char( 34 )..v.Name..string.char( 34 ).." "..string.char( 34 )..o..string.char( 34 ) )
							end )
						end
					OptionMenu:Open()
				end
				DList1:AddItem( SpawnIcon )
			end
		end
	end
	usermessage.Hook( "FurnaceSENT", FurnaceSENT )
else
	function ENT:Initialize()
		self.Entity:SetModel( "models/medieval/items/furnace.mdl" )
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
		local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetMass( 1000 )
		end
	end

	function ENT:Think()
		if not self.Logs then
			self.Logs = ents.Create( "prop_physics" )
			self.Logs:SetModel( "models/medieval/items/furnace_logs.mdl" )
			self.Logs:Spawn()
			self.Logs:Activate()
			self.Logs:SetPos( self.Entity:GetPos() )
			self.Logs:SetAngles( self.Entity:GetAngles() )
			self.Logs:Ignite( 100000000, 0 )
			self.Logs:SetParent( self.Entity )
			self.Logs:SetCollisionGroup( COLLISION_GROUP_WORLD )
		end

		if not self.Logs:IsOnFire() then
			self.Logs:Ignite( 100000000, 0 )
		end
		if not self.FireEnt or not self.FireEnt:IsValid() then
			self.FireEnt = ents.Create( "gmc_fire" )
			self.FireEnt:SetModel( "models/medieval/items/furnace_logs.mdl" )
			self.FireEnt:Spawn()
			self.FireEnt:SetPos( self.Entity:GetPos() )
		end
	end

	function ENT:OnRemove()
		if self.Logs and self.Logs:IsValid() then
			self.Logs:Remove()
		end
		if self.FireEnt and self.FireEnt:IsValid() then
			self.FireEnt:Remove()
		end
	end

	function ENT:Create( ply, name, amount )
		if ply:Team() ~= 8 then
			ply:PrintMessage( HUD_PRINTTALK, "You must be a Smith to use this." )
			return
		end

		if amount then -- Set default amount.
			amount = tonumber( amount )
			if amount < 1 then amount = 1 end
		else
			amount = 1
		end


		for k, v in pairs( FurnaceItems_Server ) do
			if v.Name == name then
				self.Resource1s = 0
				self.Resource2s = 0
				self.Resource3s = 0
				self.Resource4s = 0

				local item, res1 = Backpack_HasItem( ply, v.Resource1 )
				if v.Resource1 and res1 then
					self.Resource1s = self.Resource1s + res1
				end

				local item, res2 = Backpack_HasItem( ply, v.Resource2 )
				if v.Resource2 and res2 then
					self.Resource2s = self.Resource2s + res2
				end

				local item, res3 = Backpack_HasItem( ply, v.Resource3 )
				if v.Resource3 and res3 then
					self.Resource3s = self.Resource3s + res3
				end

				local item, res4 = Backpack_HasItem( ply, v.Resource4 )
				if v.Resource4 and res4 then
					self.Resource4s = self.Resource4s + res4
				end

				v.Level = v.Level or 0
				local atable = { { self.Resource1s, v.Resource1s },
								{ self.Resource2s, v.Resource2s },
								{ self.Resource3s, v.Resource3s },
								{ self.Resource4s, v.Resource4s }
							}
				if self.Entity:HasResources( ply, amount, atable ) then
					if tonumber( GetSkill( ply, "Smithing" ) ) >= tonumber( v.Level ) then
						self.Resource1s = v.Resource1s*amount
						self.Resource2s = v.Resource2s*amount
						self.Resource3s = v.Resource3s*amount
						self.Resource4s = v.Resource4s*amount

						Backpack_Give( ply, v.Name, v.Model, "gmc_bar", amount )
						local min = v.Level
							if min <= 0 then min = 1 end
						local max = v.Level+10
						SetSkill( ply, "Smithing", math.random( min, max ) )

						local item, res1 = Backpack_HasItem( ply, v.Resource1 )
						if v.Resource1 and res1 then
							Backpack_Take( ply, item, self.Resource1s )
						end

						local item, res2 = Backpack_HasItem( ply, v.Resource2 )
						if v.Resource2 and res2 then
							Backpack_Take( ply, item, self.Resource2s )
						end

						local item, res3 = Backpack_HasItem( ply, v.Resource3 )
						if v.Resource3 and res3 then
							Backpack_Take( ply, item, self.Resource3s )
						end

						local item, res4 = Backpack_HasItem( ply, v.Resource4 )
						if v.Resource4 and res4 then
							Backpack_Take( ply, item, self.Resource4s )
						end
					else
						ply:PrintMessage( HUD_PRINTTALK, "You must be level "..v.Level.." to create this." )
					end
				else
					ply:PrintMessage( HUD_PRINTTALK, "You do not have the required resources in your backpack." )
				end
			end
		end
	end

	function ENT:HasResources( ply, amount, res )
		if not ply or not amount or not res then return end

		for k, v in pairs( res ) do -- If not enough of current res, return false
			local plyamount = v[1]
			local reqamount = v[2]
				reqamount = reqamount*amount
			print( plyamount.." "..reqamount.." "..amount )
			if tonumber( plyamount ) < tonumber( reqamount ) then -- v1 is player's backpack, v2 is required resources
				return false
			end
		end
		return true
	end

	function SmeltCommand( ply, cmd, args )
		for k, v in pairs( ents.FindInSphere( ply:GetPos(), 150 ) ) do
			if v:GetClass() == "gmc_furnace" then
				v:Create( ply, args[ 1 ], args[ 2 ] )
				break
			end
		end
	end
	concommand.Add( "gmc_smelt", SmeltCommand )

	function ENT:Use( activator, caller )
		self.NextUse = self.NextUse or 0
		if CurTime() > self.NextUse then else return end
		self.NextUse = CurTime() + 1

		if activator:Team() ~= 8 then
			activator:PrintMessage( HUD_PRINTTALK, "You must be a Smith to use this." )
			return
		end

		umsg.Start( "FurnaceSENT", activator )
		umsg.End()
	end
end