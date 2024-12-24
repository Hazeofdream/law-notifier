local Laws = {}
local FixedLaws = {}

util.AddNetworkString("notify_law_added")       
util.AddNetworkString("notify_law_removed")
util.AddNetworkString("notify_law_reset")

-- darkrp is retarded istg
-- without this, the file wont even be considered loaded for this code to take effect
timer.Simple(0, function()

    Laws = table.Copy(GAMEMODE.Config.DefaultLaws)
    FixedLaws = table.Copy(Laws)

    local hookCanEditLaws = {canEditLaws = function(_, ply, action, args)
        if IsValid(ply) and (not RPExtraTeams[ply:Team()] or not RPExtraTeams[ply:Team()].mayor) then
            return false, DarkRP.getPhrase("incorrect_job", GAMEMODE.Config.chatCommandPrefix .. action)
        end
        return true
    end}
    
    function addLaw(ply, args)
        local canEdit, message = hook.Call("canEditLaws", hookCanEditLaws, ply, "addLaw", args)
    
        if not canEdit then
            DarkRP.notify(ply, 1, 4, message ~= nil and message or DarkRP.getPhrase("unable", GAMEMODE.Config.chatCommandPrefix .. "addLaw", ""))
            return ""
        end
    
        if not args or args == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end
    
        if string.len(args) < 3 then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("law_too_short"))
            return ""
        end
    
        if #Laws >= 12 then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("laws_full"))
            return ""
        end
    
        local num = table.insert(Laws, args)
    
        umsg.Start("DRP_AddLaw")
            umsg.String(args)
        umsg.End()
    
        hook.Run("addLaw", num, args, ply)
    
        DarkRP.notify(ply, 0, 2, DarkRP.getPhrase("law_added"))
    
        -- Notify all players
        net.Start("notify_law_added")
            net.WriteString(team.GetName(ply:Team()))
            net.WriteString(args)
        net.Broadcast()

        return ""
    end
    DarkRP.defineChatCommand("addLaw", addLaw)
    
    local function removeLaw(ply, args)
        local canEdit, message = hook.Call("canEditLaws", hookCanEditLaws, ply, "removeLaw", args)

        if not canEdit then
            DarkRP.notify(ply, 1, 4, message ~= nil and message or DarkRP.getPhrase("unable", GAMEMODE.Config.chatCommandPrefix .. "removeLaw", ""))
            return ""
        end

        local i = DarkRP.toInt(args)

        if not i or not Laws[i] then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end

        if FixedLaws[i] then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("default_law_change_denied"))
            return ""
        end

        local law = Laws[i]

        net.Start("notify_law_removed")
            net.WriteString(team.GetName(ply:Team()))
            net.WriteString(law)
        net.Broadcast()

        table.remove(Laws, i)

        umsg.Start("DRP_RemoveLaw")
            umsg.Short(i)
        umsg.End()

        hook.Run("removeLaw", i, law, ply)

        DarkRP.notify(ply, 0, 2, DarkRP.getPhrase("law_removed"))

        return ""
    end
    DarkRP.defineChatCommand("removeLaw", removeLaw)

    function DarkRP.resetLaws()
        Laws = table.Copy(FixedLaws)
    
        umsg.Start("DRP_ResetLaws")
        umsg.End()
    end
    
    local function resetLaws(ply, args)
        local canEdit, message = hook.Call("canEditLaws", hookCanEditLaws, ply, "resetLaws", args)
    
        if not canEdit then
            DarkRP.notify(ply, 1, 4, message ~= nil and message or DarkRP.getPhrase("unable", GAMEMODE.Config.chatCommandPrefix .. "resetLaws", ""))
            return ""
        end

        if #Laws > #FixedLaws then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("default_law_change_denied"))
            return ""
        end
    
        hook.Run("resetLaws", ply)

        -- prevent notification spam if nothing was actually reset
        -- this will also account for default laws that were modified
        
        net.Start("notify_law_reset")
            net.WriteString(team.GetName(ply:Team()))
        net.Broadcast()

        DarkRP.resetLaws()
    
        DarkRP.notify(ply, 0, 2, DarkRP.getPhrase("law_reset"))

        return ""
    end
    DarkRP.defineChatCommand("resetLaws", resetLaws)
end)