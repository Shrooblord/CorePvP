package.path = package.path .. ";data/scripts/lib/?.lua"

function execute(sender, commandName, state)
    local player = Player()
    if not player then
        return 1, "", "Player invalid!"
    end
    
    if not state then
        return 1, "", "You have to specify true, false, or clear!"
    end

    local cx, cy = player:getSectorCoordinates()

    local code = [[
        function forceEnablePvP(state)
            local sector = Sector()
            if not sector then
                eprint("Sector invalid!")
                return
            end

            if state == "clear" then
                state = nil
            end

            sector:setValue("corePvP_forceEnabled_PvP", state)

            sector:addScriptOnce("data/scripts/sector/corePvP.lua")
            sector:invokeFunction("data/scripts/sector/corePvP.lua", "performDelayedInit")
        end
    ]]

    local success = runSectorCode(cx, cy, true, code, "forceEnablePvP", state)

    if success == 0 then
        return 0, "", ""
    else
        return 1, "", "Sector not loaded into memory!"
    end
end

function getDescription()
    return "Forces the PvP state of the Sector, overriding automatic procedures."
end

function getHelp()
    return "Forces the PvP state of the Sector, overriding automatic procedures. If run with 'clear' as the argument, clears any previous forcing and returns to automatic procedure. Usage: /forcePvP <true|false|clear>"
end
