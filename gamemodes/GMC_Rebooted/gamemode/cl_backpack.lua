
MaxSpawnedItems = 25

function SendInventoryData( handler, id, encoded, decoded )
	LocalPlayer().Stored_Items = decoded
end
--datastream.Hook( "SendInventoryData", SendInventoryData )
--usermessage.Hook( "SendInventoryData", SendInventoryData )
net.Receive( "SendInventoryData", SendInventoryData )

function Backpack_Menu( msg ) -- Drag system? - GMC2/gamemode/modules/dragsystem.txt
	local DFrame1 = vgui.Create( "DFrame" )
	DFrame1:SetSize( 357, 165 )
	DFrame1:Center()
	DFrame1:SetTitle( "Backpack" )
	DFrame1:SetDraggable( true )
	DFrame1:ShowCloseButton( true )
	DFrame1:MakePopup()

	local function DrawInventory()
		local DList1 = vgui.Create( "DPanelList", DFrame1 )
		DList1:SetPos( 3, 25 )
		DList1:SetSize( DFrame1:GetWide() - 6, DFrame1:GetTall() - 28 )
		DList1:SetSpacing( 2 )
		DList1:SetPadding( 4 )
		DList1:EnableVerticalScrollbar( true )
		DList1:EnableHorizontal( true )
		if LocalPlayer().Stored_Items then
			for k, v in pairs( LocalPlayer().Stored_Items ) do
				local name = v.Name
				local model = v.Model
				local class = v.Class
				local amount = v.Amount

				local DIcon1 = vgui.Create( "SpawnIcon" )
				DIcon1:SetSize( 64, 64 )
				DIcon1:SetModel( model )
				DIcon1:SetToolTip( name.."\nAmount: "..amount )
				DIcon1.DoClick = function()
					local Options = {
										1, 
										5, 
										10, 
										15, 
										20, 
										50
									}
					local OptionsMenu = DermaMenu()
					-- Takes
						local shown
						for _, o in pairs( Options ) do
							if amount >= o and o < MaxSpawnedItems then
								OptionsMenu:AddOption( "Take "..o, function()
									LocalPlayer():ConCommand( "Backpack_Dropitem "..string.char( 34 )..k..string.char( 34 ).." "..string.char( 34 )..o..string.char( 34 ) )
									timer.Simple( 0.5, function()
										DList1:SetVisible( false )
										DrawInventory()
									end )
								end )
							else
								break
							end
							if amount == o then
								shown = true
							end
						end
						if not shown then
							if amount > MaxSpawnedItems then
								amount = MaxSpawnedItems
							end
							OptionsMenu:AddOption( "Take "..amount, function()
								LocalPlayer():ConCommand( "Backpack_Dropitem "..string.char( 34 )..k..string.char( 34 ).." "..string.char( 34 )..amount..string.char( 34 ) )
								timer.Simple( 0.5, function()
									DList1:SetVisible( false )
									DrawInventory()
								end )
							end )
						end
						OptionsMenu:AddOption( "Destroy item", function()
							LocalPlayer():ConCommand( "Backpack_Destroyitem "..string.char( 34 )..k..string.char( 34 ) )
							timer.Simple( 0.5, function()
								DList1:SetVisible( false )
								DrawInventory()
							end )
						end )
					OptionsMenu:Open()
				end
				DList1:AddItem( DIcon1 )
			end
		end
	end
	DrawInventory()
end
usermessage.Hook( "BackpackMenu", Backpack_Menu )

function Backpack_Menu_Trade( msg )
	local index = msg:ReadLong()
	local trader
		for k,v in pairs( player.GetAll() ) do
			if v:EntIndex() == index then
				trader = v
			end
		end
	if not trader then return end

	local DFrame1 = vgui.Create( "DFrame" )
	DFrame1:SetSize( 750, 200 )
	DFrame1:Center()
	DFrame1:SetTitle( "Trade" )
	DFrame1:SetDraggable( true )
	DFrame1:ShowCloseButton( true )
	DFrame1:MakePopup()

	local function DrawTraderInventory()
		local DList1 = vgui.Create( "DPanelList", DFrame1 )
		DList1:SetPos( ( DFrame1:GetWide()/2 ) + 3, 25 )
		DList1:SetSize( ( DFrame1:GetWide()/2 ) - 6, DFrame1:GetTall() - 28 )
		DList1:SetSpacing( 2 )
		DList1:SetPadding( 4 )
		DList1:EnableVerticalScrollbar( true )
		DList1:EnableHorizontal( true )
		if trader.Stored_Items then
			for k, v in pairs( trader.Stored_Items ) do
				local name = v.Name
				local model = v.Model
				local class = v.Class
				local amount = v.Amount

				local DIcon1 = vgui.Create( "SpawnIcon" )
				DIcon1:SetIconSize( 64 )
				DIcon1:SetModel( model )
				DIcon1:SetToolTip( name.."\nAmount: "..amount )
				DList1:AddItem( DIcon1 )
			end
		end
	end
	local function DrawInventory()
		local DList1 = vgui.Create( "DPanelList", DFrame1 )
		DList1:SetPos( 3, 25 )
		DList1:SetSize( ( DFrame1:GetWide()/2 ) - 6, DFrame1:GetTall() - 28 )
		DList1:SetSpacing( 2 )
		DList1:SetPadding( 4 )
		DList1:EnableVerticalScrollbar( true )
		DList1:EnableHorizontal( true )
		if LocalPlayer().Stored_Items then
			for k, v in pairs( LocalPlayer().Stored_Items ) do
				local name = v.Name
				local model = v.Model
				local class = v.Class
				local amount = v.Amount

				local DIcon1 = vgui.Create( "SpawnIcon" )
				DIcon1:SetIconSize( 64 )
				DIcon1:SetModel( model )
				DIcon1:SetToolTip( name.."\nAmount: "..amount )
				DIcon1.DoClick = function()
					local Options = {
										1, 
										5, 
										10, 
										15, 
										20, 
										50
									}
					local OptionsMenu = DermaMenu()
					-- Takes
						local shown
						for _, o in pairs( Options ) do
							if amount >= o and o < MaxSpawnedItems then
								OptionsMenu:AddOption( "Give "..o, function()
									LocalPlayer():ConCommand( "Backpack_Giveitem "..string.char( 34 )..trader:EntIndex()..string.char( 34 ).." "..string.char( 34 )..k..string.char( 34 ).." "..string.char( 34 )..o..string.char( 34 ) )
									timer.Simple( 0.5, function()
										DList1:SetVisible( false )
										DrawTraderInventory()
										DrawInventory()
									end )
								end )
							else
								break
							end
							if amount == o then
								shown = true
							end
						end
						if not shown then
							if amount > MaxSpawnedItems then
								amount = MaxSpawnedItems
							end
							OptionsMenu:AddOption( "Give "..amount, function()
								LocalPlayer():ConCommand( "Backpack_Giveitem "..string.char( 34 )..trader:EntIndex()..string.char( 34 ).." "..string.char( 34 )..k..string.char( 34 ).." "..string.char( 34 )..amount..string.char( 34 ) )
								timer.Simple( 0.5, function()
									DList1:SetVisible( false )
									DrawTraderInventory()
									DrawInventory()
								end )
							end )
						end
					OptionsMenu:Open()
				end
				DList1:AddItem( DIcon1 )
			end
		end
	end
	DrawTraderInventory()
	DrawInventory()
end
usermessage.Hook( "PlayerTrade", Backpack_Menu_Trade )

function Backpack_GetCount( name ) -- Used for buildings
	if not LocalPlayer().Stored_Items then return 0 end
	local count = 0
	for k, v in pairs( LocalPlayer().Stored_Items ) do
		if string.lower( tostring( v.Name ) ) == string.lower( tostring( name ) ) then
			count = v.Amount
		end
	end
	return count
end

function GMC_GetPrice( name )
	local atable = {}
		table.Add( atable, AnvilItems_Client )
		table.Add( atable, FurnaceItems_Client )
		table.Add( atable, FurnaceIngredients_Client )
		table.Add( atable, WorkbenchItems_Client )
		table.Add( atable, WorkbenchIngredients_Client )
	for k, v in pairs( atable ) do
		if name == v.Name then
			return v.Price
		end
	end

	return math.random( 1, 10 )
end

function GMC_GetModel( name )
	local model = "models/gmstranded/props/lumber.mdl" -- Default, just incase.
	local atable = {}
		table.Add( atable, AnvilItems_Client )
		table.Add( atable, FurnaceItems_Client )
		table.Add( atable, FurnaceIngredients_Client )
		table.Add( atable, WorkbenchItems_Client )
		table.Add( atable, WorkbenchIngredients_Client )
	for k, v in pairs( atable ) do
		if v.Name == name then
			model = v.Model
		end
	end
	return model
end