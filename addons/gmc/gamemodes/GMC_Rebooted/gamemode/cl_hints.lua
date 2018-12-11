function AddHint_Client( cat, bool, text )
	if not GMC_Hints then
		GMC_Hints = {}
	end
	table.insert( GMC_Hints, { Category = cat, Bool = bool, Text = text } )
end

function Hints_Think()
	if not LocalPlayer().NextHint or LocalPlayer().NextHint < CurTime() then
		if not LocalPlayer().HintTime then LocalPlayer().HintTime = 60 end
		if LocalPlayer().HintTime != 0 then
			local hint = table.Random( GMC_Hints )
			while not hint.Bool do
				hint = table.Random( GMC_Hints )
			end
			GAMEMODE:AddNotify( hint.Text, 3, 5 )
			LocalPlayer():PrintMessage( HUD_PRINTCONSOLE, hint.Text.."\n" )

			local min, max = LocalPlayer().HintTime - 1, LocalPlayer().HintTime + 1
				if min <= 0 then min = 0.5 end
			LocalPlayer().NextHint = CurTime() + math.random( min, max )
		end
	end
end
hook.Add( "Think", "Hints_Think", Hints_Think )