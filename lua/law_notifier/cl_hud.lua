net.Receive("notify_law_added", function()
	local JobName = net.ReadString()
	local Msg = net.ReadString()

    surface.PlaySound("buttons/lightswitch2.wav")
    chat.AddText(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), string.format("The %s has added a new Law: %s", JobName, Msg))
end)

net.Receive("notify_law_removed", function()
	local JobName = net.ReadString()
	local Msg = net.ReadString()

    surface.PlaySound("buttons/lightswitch2.wav")
    chat.AddText(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), string.format("The %s has removed an existing Law: %s", JobName, Msg))
end)

net.Receive("notify_law_reset", function()
	local JobName = net.ReadString()
	local Msg = net.ReadString()

    surface.PlaySound("buttons/lightswitch2.wav")
    chat.AddText(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), "The Mayor has reset all laws back to their defaults.")
end)

-- Developer Information

local LawNotifierVersion = "1.0"

concommand.Add("lawnotifier_info", function()
	local InfoTable = {
		"https://steamcommunity.com/sharedfiles/filedetails/?id=3292250208 created by Haze_of_dream",
		"",
		"Contact at: ",
		"STEAM_0:1:75838598",
		"https:/steamcommunity.com/id/Haze_of_dream",
		"",
		string.format("Law Notifier Version: %s", LawNotifierVersion)
	}
	
	for _, msg in pairs(InfoTable) do
		print(msg)
	end
end)

--#NoSimplerr#