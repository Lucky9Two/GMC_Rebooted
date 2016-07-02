ExpMultiplier = 25

function SendPermissionData( handler, id, encoded, decoded )
	LocalPlayer().Permissions = decoded
end
--datastream.Hook( "SendPermissionData", SendPermissionData )
net.Receive( "SendPermissionData", SendPermissionData )

function LoginScreen()
	local DFrame1 = vgui.Create( "DFrame" )
	DFrame1:SetSize( 238, 104 )
	DFrame1:Center()
	DFrame1:SetTitle( "Login" )
	DFrame1:SetSizable( true )
	DFrame1:SetDeleteOnClose( false )
	DFrame1:MakePopup()

	local DLabel1 = vgui.Create( "DLabel", DFrame1 )
	DLabel1:SetPos( 23, 29 )
	DLabel1:SetText( "Username" )
	DLabel1:SizeToContents()

	local DTextEntry1 = vgui.Create( "DTextEntry", DFrame1 )
	DTextEntry1:SetSize( 116, 22 )
	DTextEntry1:SetPos( 80, 25 )
	DTextEntry1:SetText( "" )

	local DLabel2 = vgui.Create( "DLabel", DFrame1 )
	DLabel2:SetPos( 23, 54 )
	DLabel2:SetText( "Password" )
	DLabel2:SizeToContents()

	local DTextEntry2 = vgui.Create( "DTextEntry", DFrame1 )
	DTextEntry2:SetSize( 116, 21 )
	DTextEntry2:SetPos( 80, 51 )
	DTextEntry2:SetText( "" )

	local DButton1 = vgui.Create( "DButton", DFrame1 )
	DButton1:SetSize( 104, 25 )
	DButton1:SetPos( 10, 75 )
	DButton1:SetText( "Create new account" )
	DButton1.DoClick = function()
		LocalPlayer():ConCommand( "gmc_createaccount "..DTextEntry1:GetValue().." "..DTextEntry2:GetValue().."" )
	end

	local DButton2 = vgui.Create( "DButton", DFrame1 )
	DButton2:SetSize( 104, 25 )
	DButton2:SetPos( 124, 75 )
	DButton2:SetText( "Login" )
	DButton2.DoClick = function()
		LocalPlayer():ConCommand( "gmc_login "..DTextEntry1:GetValue().." "..DTextEntry2:GetValue().."" )
	end
end
usermessage.Hook( "LoginScreen", LoginScreen )

function MainMenu()
	local function DrawMain()
		local DFrame1 = vgui.Create( "DFrame" )
		DFrame1:SetSize( 90, 175 )
		DFrame1:Center()
		DFrame1:SetTitle( "Main Menu" )
		DFrame1:SetDraggable( true )
		DFrame1:SetSizable( false )
		DFrame1:SetDeleteOnClose( false )
		DFrame1:SetVisible( true )
		DFrame1:ShowCloseButton( true )
		DFrame1:MakePopup()

		local DButton1 = vgui.Create( "DButton" )
		DButton1:SetParent( DFrame1 )
		DButton1:SetSize( 70, 20 )
		DButton1:SetPos( 10, 25 )
		DButton1:SetText( "Classes" )
		DButton1.DoClick = function()
			DFrame1:SetVisible( false )

			local DFrame3 = vgui.Create( "DFrame" )
			DFrame3:SetSize( 237, 115 )
			DFrame3:Center()
			DFrame3:SetTitle( "Classes" )
			DFrame3:SetDraggable( true )
			DFrame3:ShowCloseButton( true )
			DFrame3:SetSizable( false )
			DFrame3:SetDeleteOnClose( false )
			DFrame3:SetVisible( true )
			DFrame3:MakePopup()

			local DList2 = vgui.Create( "DPanelList", DFrame3 )
			DList2:SetPos( 5, 30 )
			DList2:SetSize( DFrame3:GetWide() - 10, DFrame3:GetTall() - 35 )
			DList2:SetSpacing( 5 )
			DList2:SetPadding( 5 )
			DList2:EnableHorizontal( true )
			DList2:EnableVerticalScrollbar( true )

			for k, v in pairs( Classes ) do
				local DImage = vgui.Create( "DImageButton" )
				DImage:SetImage( "models/medieval/vgui/"..v.Model..".vtf" )
				DImage:SetToolTip( "Name: "..v.Name )
				DImage:SetSize( 32, 32 )
				DImage.DoClick = function()
					LocalPlayer():ConCommand( "gmc_class "..v.Name.." "..v.Number.." "..v.Notice )
				end
				DList2:AddItem( DImage )
			end
		end

		local DButton2 = vgui.Create( "DButton" )
		DButton2:SetParent( DFrame1 )
		DButton2:SetSize( 70, 20 )
		DButton2:SetPos( 10, 50 )
		DButton2:SetText( "Options" )
		DButton2.DoClick = function()
			DFrame1:SetVisible( false )

			local function DrawOptions()
				local DFrame1 = vgui.Create( "DFrame" )
				DFrame1:SetSize( 100, 100 )
				DFrame1:Center()
				DFrame1:SetTitle( "Options" )
				DFrame1:SetDraggable( true )
				DFrame1:SetSizable( false )
				DFrame1:SetDeleteOnClose( false )
				DFrame1:SetVisible( true )
				DFrame1:ShowCloseButton( true )
				DFrame1:MakePopup()

				local DButton1 = vgui.Create( "DButton" )
				DButton1:SetParent( DFrame1 )
				DButton1:SetSize( 80, 20 )
				DButton1:SetPos( 10, 25 )
				DButton1:SetText( "Visuals" )
				DButton1.DoClick = function()
					DFrame1:SetVisible( false )

					local DFrame1 = vgui.Create( "DFrame" )
					DFrame1:SetSize( 100, 125 )
					DFrame1:Center()
					DFrame1:SetTitle( "Visual Options" )
					DFrame1:SetDraggable( true )
					DFrame1:SetSizable( false )
					DFrame1:SetDeleteOnClose( false )
					DFrame1:SetVisible( true )
					DFrame1:ShowCloseButton( true )
					DFrame1:MakePopup()

					local DButton1 = vgui.Create( "DButton" )
					DButton1:SetParent( DFrame1 )
					DButton1:SetSize( 80, 20 )
					DButton1:SetPos( 10, 25 )
					DButton1:SetText( "Team Colour" )
					DButton1.DoClick = function()
						if LocalPlayer().TeamColour then
							LocalPlayer().TeamColour = false
						else
							LocalPlayer().TeamColour = true
						end
					end

					local DButton2 = vgui.Create( "DButton" )
					DButton2:SetParent( DFrame1 )
					DButton2:SetSize( 80, 20 )
					DButton2:SetPos( 10, 50 )
					DButton2:SetText( "Building Owner" )
					DButton2.DoClick = function()
						if LocalPlayer().DontDrawOwner then
							LocalPlayer().DontDrawOwner = false
						else
							LocalPlayer().DontDrawOwner = true
						end
					end

					local DButton3 = vgui.Create( "DButton" )
					DButton3:SetParent( DFrame1 )
					DButton3:SetSize( 80, 20 )
					DButton3:SetPos( 10, 75 )
					DButton3:SetText( "Building Info" )
					DButton3.DoClick = function()
						if LocalPlayer().DontDrawResources then
							LocalPlayer().DontDrawResources = false
						else
							LocalPlayer().DontDrawResources = true
						end
					end

					local DButton4 = vgui.Create( "DButton" )
					DButton4:SetParent( DFrame1 )
					DButton4:SetSize( 80, 20 )
					DButton4:SetPos( 10, 100 )
					DButton4:SetText( "Back" )
					DButton4.DoClick = function()
						DFrame1:SetVisible( false )
						DrawOptions()
					end

					-- local DButton6 = vgui.Create( "DButton" )
					-- DButton6:SetParent( DFrame1 )
					-- DButton6:SetSize( 80, 20 )
					-- DButton6:SetPos( 10, 125 )
					-- DButton6:SetText( "" )
					-- DButton6.DoClick = function()
						-- DFrame1:SetVisible( false )
					-- end
				end

				local DButton2 = vgui.Create( "DButton" )
				DButton2:SetParent( DFrame1 )
				DButton2:SetSize( 80, 20 )
				DButton2:SetPos( 10, 50 )
				DButton2:SetText( "Permissions" )
				DButton2.DoClick = function()
					local DFrame = vgui.Create( "DFrame" )
					DFrame:SetSize( 250, 200 )
					DFrame:Center()
					DFrame:SetTitle( "Permission" )
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

					local MainPermissions = {}
						table.insert( MainPermissions, "Gates" )
						table.insert( MainPermissions, "Positioning" )
						table.insert( MainPermissions, "Building" )
						table.insert( MainPermissions, "Removing" )
					for k, v in pairs( player.GetAll() ) do
						if v ~= LocalPlayer() then
							local Permissions
								if LocalPlayer().Permissions then
									Permissions = {}
									for _, i in pairs( LocalPlayer().Permissions ) do
										if v == i.Player then
											table.insert( Permissions, i.Name )
										end
									end
								end
							local DIcon = vgui.Create( "SpawnIcon" )
							DIcon:SetIconSize( 64 )
							DIcon:SetModel( v:GetModel() )
							local info = "Name: "..v:Nick()
								if v:GetNWString( "name" ) and v:GetNWString( "name" ) ~= "" then
									info = info.."\nRoleplay Name: "..v:GetNWString( "name" )
								end
								if Permissions and #Permissions > 0 then
									info = info.."\nPermissions: "
									for u, i in pairs( Permissions ) do
										info = info.."\n"..i
									end
								end
							DIcon:SetToolTip( info )
							DIcon.DoClick = function()
								local OptionsMenu = DermaMenu()
									for _, i in pairs( MainPermissions ) do
										OptionsMenu:AddOption( i.." Permission", function()
											DFrame:SetVisible( false )

											LocalPlayer():ConCommand( "GMC_Permission "..string.char( 34 )..LocalPlayer():EntIndex()..string.char( 34 ).." "..string.char( 34 )..k..string.char( 34 ).." "..string.char( 34 )..i..string.char( 34 ) )
										end )
									end
								OptionsMenu:Open()
							end
							DList:AddItem( DIcon )
						end
					end
				end

				local DButton3 = vgui.Create( "DButton" )
				DButton3:SetParent( DFrame1 )
				DButton3:SetSize( 80, 20 )
				DButton3:SetPos( 10, 75 )
				DButton3:SetText( "Back" )
				DButton3.DoClick = function()
					DFrame1:SetVisible( false )
					DrawMain()
				end

				-- local DButton7 = vgui.Create( "DButton" )
				-- DButton7:SetParent( DFrame1 )
				-- DButton7:SetSize( 80, 20 )
				-- DButton7:SetPos( 10, 100 )
				-- DButton7:SetText( "" )
				-- DButton7.DoClick = function()
					-- DFrame1:SetVisible( false )
				-- end

				-- local DButton6 = vgui.Create( "DButton" )
				-- DButton6:SetParent( DFrame1 )
				-- DButton6:SetSize( 80, 20 )
				-- DButton6:SetPos( 10, 125 )
				-- DButton6:SetText( "" )
				-- DButton6.DoClick = function()
					-- DFrame1:SetVisible( false )
				-- end
			end
			DrawOptions()
		end

		local DButton3 = vgui.Create( "DButton" )
		DButton3:SetParent( DFrame1 )
		DButton3:SetSize( 70, 20 )
		DButton3:SetPos( 10, 75 )
		DButton3:SetText( "Buildings" )
		DButton3.DoClick = function()
			DFrame1:SetVisible( false )
			BuildingMenu()
		end

		local DButton7 = vgui.Create( "DButton" )
		DButton7:SetParent( DFrame1 )
		DButton7:SetSize( 70, 20 )
		DButton7:SetPos( 10, 100 )
		DButton7:SetText( "Skills" )
		DButton7.DoClick = function()
			DFrame1:SetVisible( false )

			local DFrame2 = vgui.Create( "DFrame" )
			DFrame2:SetSize( 237, 115 )
			DFrame2:Center()
			DFrame2:SetTitle( "Skills" )
			DFrame2:SetDraggable( true )
			DFrame2:ShowCloseButton( true )
			DFrame2:SetSizable( false )
			DFrame2:SetDeleteOnClose( false )
			DFrame2:SetVisible( true )
			DFrame2:MakePopup()

			local DList1 = vgui.Create( "DPanelList", DFrame2 )
			DList1:SetPos( 5, 30 )
			DList1:SetSize( DFrame2:GetWide() - 10, DFrame2:GetTall() - 35 )
			DList1:SetSpacing( 5 )
			DList1:SetPadding( 5 )
			DList1:EnableHorizontal( true )
			DList1:EnableVerticalScrollbar( true )

			for k, v in pairs( Skills_Client ) do
				local DImage = vgui.Create( "DImageButton" )
				DImage:SetImage( "models/medieval/vgui/"..v.Icon..".vtf" )
				local lvl = LocalPlayer():GetNWInt( v.Name.."lvl" )
				local exp = LocalPlayer():GetNWInt( v.Name.."exp" )
				DImage:SetToolTip( "Name: "..v.Name.."\n".."Level: "..lvl.."\n".."Experience: "..exp.."/"..( ExpMultiplier*lvl ) )
				DImage:SetSize( 32, 32 )
				DList1:AddItem( DImage )
			end
		end

		local DButton6 = vgui.Create( "DButton" )
		DButton6:SetParent( DFrame1 )
		DButton6:SetSize( 70, 20 )
		DButton6:SetPos( 10, 125 )
		DButton6:SetText( "Hints" )
		DButton6.DoClick = function()
			if not GMC_Hints then return end
			DFrame1:SetVisible( false )

			local function DrawHints()
				local DFrame1 = vgui.Create( "DFrame" )
				DFrame1:SetSize( 165, 110 )
				DFrame1:Center()
				DFrame1:SetTitle( "Hints" )
				DFrame1:SetDraggable( true )
				DFrame1:ShowCloseButton( true )
				DFrame1:SetSizable( false )
				DFrame1:SetDeleteOnClose( false )
				DFrame1:SetVisible( true )
				DFrame1:MakePopup()

				local DList1 = vgui.Create( "DPanelList", DFrame1 )
				DList1:SetSize( 155, 80 )
				DList1:SetPos( 5, 25 )
				DList1:SetSpacing( 1 )
				DList1:EnableHorizontal( false )
				DList1:EnableVerticalScrollbar( true )

				local Shown = { GMC_Hints[ 1 ] }
				for k, v in pairs( GMC_Hints ) do
					local shown
					for _, i in pairs( Shown ) do
						if v.Category == i.Category then
							if not i.Amount then i.Amount = 0 end
							i.Amount = i.Amount + 1
							shown = true
						end
					end
					if not shown then
						table.insert( Shown, v )
					end
				end

				for k, v in pairs( Shown ) do
					local amount = v.Amount
						if not amount then amount = 1 end
					local DButton1 = vgui.Create( "DButton" )
					DButton1:SetText( v.Category )
					DButton1:SetSize( 147.5, 18 )
					DButton1.DoClick = function()
						DList1:SetVisible( false )

						local DList1 = vgui.Create( "DPanelList", DFrame1 )
						DList1:SetSize( 155, 80 )
						DList1:SetPos( 5, 25 )
						DList1:SetSpacing( 1 )
						DList1:EnableHorizontal( false )
						DList1:EnableVerticalScrollbar( true )
						for _, i in pairs( GMC_Hints ) do
							if v.Category == i.Category then
								local DButton1 = vgui.Create( "DButton" )
								DButton1:SetSize( 147.5, 18 )
								local text = i.Text
									text = string.Left( text, 25 )
									if string.Right( text, 1 ) == " " then -- It it ends in a space, clip it off.
										text = string.Left( text, string.len( text )-1 )
									end
									text = text.."..."
								DButton1:SetText( text )
								DButton1:SetToolTip( i.Text )
								DList1:AddItem( DButton1 )
							end
						end
						local DButton2 = vgui.Create( "DButton" )
						DButton2:SetSize( 147.5, 18 )
						DButton2:SetText( "Back" )
						DButton2:SetToolTip( "Go back" )
						DButton2.DoClick = function()
							DFrame1:SetVisible( false )
							DrawHints()
						end
						DList1:AddItem( DButton2 )
					end
					DList1:AddItem( DButton1 )
				end
				local DButton2 = vgui.Create( "DButton" )
				DButton2:SetSize( 147.5, 18 )
				DButton2:SetText( "Back" )
				DButton2:SetToolTip( "Go back" )
				DButton2.DoClick = function()
					DFrame1:SetVisible( false )
					DrawMain()
				end
				DList1:AddItem( DButton2 )
			end
			DrawHints()
		end

		local DButton7 = vgui.Create( "DButton" )
		DButton7:SetParent( DFrame1 )
		DButton7:SetSize( 70, 20 )
		DButton7:SetPos( 10, 150 )
		DButton7:SetText( "Logout" )
		DButton7.DoClick = function()
			DFrame1:SetVisible( false )

			local DFrame1 = vgui.Create( "DFrame" )
			DFrame1:SetSize( 115, 50 )
			DFrame1:Center()
			DFrame1:SetTitle( "Logout?" )
			DFrame1:SetDraggable( true )
			DFrame1:ShowCloseButton( true )
			DFrame1:SetSizable( false )
			DFrame1:SetDeleteOnClose( false )
			DFrame1:SetVisible( true )
			DFrame1:MakePopup()

			local DButton1 = vgui.Create( "DButton", DFrame1 )
			DButton1:SetSize( 50, 20 )
			DButton1:SetPos( 5, 25 )
			DButton1:SetText( "Yes" )
			DButton1.DoClick = function()
				LocalPlayer():ConCommand( "gmc_logout" )
				DFrame1:SetVisible( false )
			end

			local DButton2 = vgui.Create( "DButton", DFrame1 )
			DButton2:SetSize( 50, 20 )
			DButton2:SetPos( 60, 25 )
			DButton2:SetText( "Cancel" )
			DButton2.DoClick = function()
				DFrame1:SetVisible( false )
			end
		end
	end
	DrawMain()
end
usermessage.Hook( "MainMenu", MainMenu )

function BuildingMenu()
	local DFrame2 = vgui.Create( "DFrame" )
	DFrame2:SetSize( 500, 500 )
	DFrame2:Center()
	DFrame2:SetTitle( "Buildings" )
	DFrame2:SetDraggable( true )
	DFrame2:ShowCloseButton( true )
	DFrame2:SetSizable( false )
	DFrame2:SetDeleteOnClose( false )
	DFrame2:SetVisible( true )
	DFrame2:MakePopup()

	local DList1 = vgui.Create( "DPanelList", DFrame2 )
	DList1:SetPos( 5, 30 )
	DList1:SetSize( DFrame2:GetWide() - 10, DFrame2:GetTall() - 35 )
	DList1:SetSpacing( 5 )
	DList1:SetPadding( 5 )
	DList1:EnableHorizontal( true )

	if CBuildings then
		for k, v in pairs( CBuildings ) do
			local tooltip = "Name: "..v.Name.."\n".."Resources Required:"
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
				tooltip = tooltip.."\nExtras:"
				for _, ent in pairs( CBuildingExtras ) do
					if v.Name == ent.Building then
						tooltip = tooltip.."\n"..ent.Name
					end
				end
			local SpawnIcon = vgui.Create( "SpawnIcon" )
			SpawnIcon:SetSize( 64 )
			SpawnIcon:SetModel( v.Model )
			SpawnIcon:SetToolTip( tooltip )
			SpawnIcon.DoClick = function()
				local OptionMenu = DermaMenu()
					OptionMenu:AddOption( "Spawn", function() LocalPlayer():ConCommand( "gmc_blueprint "..string.char( 34 )..v.Name..string.char( 34 ) ) end )
				OptionMenu:Open()
			end
			DList1:AddItem( SpawnIcon )
		end
	end
end
usermessage.Hook( "BuildingMenu", BuildingMenu )