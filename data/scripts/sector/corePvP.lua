--Core PvP (C) 2019 Shrooblord
--Main functionality of the Core PvP mod. Takes the distances set in config and applies them globally across the Galaxy as a setting to enable / disable PvP in that Sector.

package.path = package.path .. ";data/scripts/lib/?.lua"
package.path = package.path .. ";data/scripts/config/?.lua"

include ("sMPrint")
include ("callable")

local config = include ("corePvPConfig")

-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace CorePvP
CorePvP = {}

local fromScript = "sector/corePvP"

local delayedInitPerformed = false

local forcePVPState
local distToCentre = -1

--config.PvPZoneDist
--config.PvPZoneDisableNeutralZone

function CorePvP.initialize()
    if onClient() then return end

    local fromFunc = "initialize"

    local sector = Sector()
    x, y = sector:getCoordinates()
    prtDbg("Initialising Core PvP...", 0, config.modID, 1, fromScript, fromFunc, "SERVER")

    distToCentre = math.floor(length(vec2(x, y)))

    -- custom settings that override config file settings
    forcePVPState = sector:getValue("corePvP_forceEnabled_PvP")

    sector:registerCallback("onRestoredFromDisk", "onRestoredFromDisk")
    sector:registerCallback("onPlayerEntered", "onPlayerEntered")
    sector:registerCallback("onPlayerLeft", "onPlayerLeft")

    prtDbg("Core PvP Initialised!", 0, config.modID, 1, fromScript, fromFunc, "SERVER")
end


function CorePvP.performDelayedInit()
    local fromFunc = "performDelayedInit"

    prtDbg("Performing Core PvP delayed Initiation...", 0, config.modID, 1, fromScript, fromFunc, "SERVER")

    local faction, isOnline
    local server = Server()
    local sector = Sector()

    if (distToCentre <= config.PvPZoneDist and forcePVPState == nil) or forcePVPState then -- PvP enabled
        sector.pvpDamage = 1

        -- Toggle PVP/PVE
        if config.PvPZoneDisableNeutralZone then
            if sector:hasScript("neutralzone.lua") then
                -- Remove 'neutralzone' script
                sector:setValue("corePvP_was_neutral_zone", 1)
                sector:setValue("neutral_zone")
                sector:removeScript("data/scripts/sector/neutralzone.lua")
                prtDbg("Removed neutralzone.lua", 0, config.modID, 3, fromScript, fromFunc, "SERVER")
            end
        elseif sector:getValue("was_neutral_zone") then
            sector.pvpDamage = 0
            -- Restore neutralzone
            sector:addScriptOnce("data/scripts/sector/neutralzone.lua")
            sector:setValue("corePvP_was_neutral_zone")
            sector:setValue("neutral_zone", 1)
            prtDbg("Restored neutralzone.lua", 0, config.modID, 3, fromScript, fromFunc, "SERVER")
        end

        if sector.pvpDamage then
            local message = "Sector initialised as PvP zone. Distance to centre: " .. distToCentre
            if forcePVPState then
                message = message .. "; FORCE ENABLED BY USER"
            end

            prtDbg(message, 0, config.modID, 2, fromScript, fromFunc, "SERVER")
        else
            prtDbg("Sector initialised as PvE (Neutral Zone). Distance to centre: " .. distToCentre, 0, config.modID, 2, fromScript, fromFunc, "SERVER")
        end
    else -- PvE (PvP disabled)
        if sector:getValue("was_neutral_zone") then
            -- Restore neutralzone
            sector:addScriptOnce("data/scripts/sector/neutralzone.lua")
            sector:setValue("corePvP_was_neutral_zone")
            sector:setValue("neutral_zone", 1)
            prtDbg("Restored neutralzone.lua", 0, config.modID, 3, fromScript, fromFunc, "SERVER")
        end
        sector.pvpDamage = 0
        prtDbg("Sector initialised as PvE (Neutral Zone). Distance to centre: " .. distToCentre, 0, config.modID, 2, fromScript, fromFunc, "SERVER")
    end

    prtDbg("Core PvP delayed Initiation completed!", 0, config.modID, 1, fromScript, fromFunc, "SERVER")
end


function CorePvP.onRestoredFromDisk(time)
    if not delayedInitPerformed then
        delayedInitPerformed = true
        CorePvP.performDelayedInit()
    end
end

function CorePvP.onPlayerEntered(playerIndex)
    if not delayedInitPerformed then
        delayedInitPerformed = true
        CorePvP.performDelayedInit()
    end
    if Sector().pvpDamage then
        Player(playerIndex):sendChatMessage("Server", 2, "You have entered a PVP Sector. Be careful!"%_T)
    end
end

function CorePvP.onPlayerLeft(playerIndex)
    if not delayedInitPerformed then
        delayedInitPerformed = true
        CorePvP.performDelayedInit()
    end
end
