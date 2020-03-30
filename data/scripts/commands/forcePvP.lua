package.path = package.path .. ";data/scripts/lib/?.lua"

function execute(sender, commandName, state)
    if not state
        return 1, "", "You have to specify true or false!"
    end

    sector = Sector()
    if not sector then
        return 1, "", "Sector invalid!"
    end

    sector.setValue(corePvP_forceEnabled_PvP, state)
    sector:addScriptOnce("data/scripts/sector/corePvP.lua")

    return 0, "", ""
end

function getDescription()
    return "Forces the PvP state of the Sector, overriding automatic procedures."
end

function getHelp()
    return "Forces the PvP state of the Sector, overriding automatic procedures. Usage: /forcePvP <true|false>"
end
