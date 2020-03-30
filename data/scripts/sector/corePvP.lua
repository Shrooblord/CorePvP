--Core PvP (C) 2019-2020 Shrooblord
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

local forcePvPState
local distToCentre = 9999

--config.PvPZoneDist
--config.PvPZoneDisableNeutralZone

function CorePvP.initialize()
    if onClient() then return end

    local fromFunc = "initialize"

    local sector = Sector()
    local x, y = sector:getCoordinates()
    prtDbg("Initialising Core PvP...", 0, config.modID, 2, fromScript, fromFunc, "SERVER")

    distToCentre = math.floor(length(vec2(x, y)))

    -- custom settings that override config file settings
    forcePvPState = sector:getValue("corePvP_forceEnabled_PvP")
    if forcePvPState == "true" then forcePvPState = 1 elseif forcePvPState == "false" then forcePvPState = 0 end

    sector:registerCallback("onRestoredFromDisk", "onRestoredFromDisk")
    sector:registerCallback("onPlayerEntered", "onPlayerEntered")
    sector:registerCallback("onPlayerLeft", "onPlayerLeft")

    prtDbg("Core PvP Initialised!", 0, config.modID, 1, fromScript, fromFunc, "SERVER")
end

function CorePvP.performDelayedInit()
    local fromFunc = "performDelayedInit"

    prtDbg("Performing Core PvP delayed Initiation...", 0, config.modID, 2, fromScript, fromFunc, "SERVER")

    local sector = Sector()

    if forcePvPState == 1 or (distToCentre <= config.PvPZoneDist and forcePvPState == nil) then -- PvP enabled
        sector.pvpDamage = true
        local message = ""

        -- Toggle Neutral Zone
        if forcePvPState or config.PvPZoneDisableNeutralZone then
            if sector:hasScript("data/scripts/sector/neutralzone.lua") then
                -- Remove 'neutralzone' script
                sector:setValue("corePvP_was_neutral_zone", 1)
                sector:setValue("neutral_zone")
                sector:removeScript("data/scripts/sector/neutralzone.lua")
                prtDbg("Removed neutralzone.lua", 0, config.modID, 4, fromScript, fromFunc, "SERVER")
            end
        else
            if sector:getValue("corePvP_was_neutral_zone") then
                -- Restore neutralzone
                sector:addScriptOnce("data/scripts/sector/neutralzone.lua")
                sector:setValue("corePvP_was_neutral_zone")
                sector:setValue("neutral_zone", 1)
                prtDbg("Restored neutralzone.lua", 0, config.modID, 4, fromScript, fromFunc, "SERVER")
            end

            if sector:hasScript("data/scripts/sector/neutralzone.lua") then
                sector.pvpDamage = false
                message = " (Neutral Zone)"
            end
        end

        if sector.pvpDamage then
            message = "Sector initialised as PvP zone"
            if forcePvPState then
                message = message .. "; FORCED BY USER"
            end
            message = message .. ". Distance to centre: " .. distToCentre

            prtDbg(message, 0, config.modID, 2, fromScript, fromFunc, "SERVER")
        else
            message = "Sector initialised as PvE" .. message
            prtDbg(message .. ". Distance to centre: " .. distToCentre, 0, config.modID, 3, fromScript, fromFunc, "SERVER")
        end

    else -- PvE (PvP disabled)
        local message = "Sector initialised as PvE zone"

        if sector:getValue("corePvP_was_neutral_zone") then
            -- Restore neutralzone
            sector:addScriptOnce("data/scripts/sector/neutralzone.lua")
            sector:setValue("corePvP_was_neutral_zone")
            sector:setValue("neutral_zone", 1)
            prtDbg("Restored neutralzone.lua", 0, config.modID, 4, fromScript, fromFunc, "SERVER")
            
            message = message .. " (Neutral Zone)"
        end

        if forcePvPState == 0 then
            message = message .. "; FORCED BY USER"
        end

        sector.pvpDamage = false
        prtDbg(message .. ". Distance to centre: " .. distToCentre, 0, config.modID, 3, fromScript, fromFunc, "SERVER")
    end

    prtDbg("Core PvP delayed Initiation completed!", 0, config.modID, 2, fromScript, fromFunc, "SERVER")
    terminate() --kill and remove the script (closing the lua VM)
end
callable(CorePvP, "performDelayedInit")

function CorePvP.onRestoredFromDisk(time)
    if not delayedInitPerformed then
        local fromFunc = "onRestoredFromDisk"
        prtDbg("restored", 0, config.modID, 4, fromScript, fromFunc, "SERVER")
        delayedInitPerformed = true
        CorePvP.performDelayedInit()
    end
end

function CorePvP.onPlayerEntered(playerIndex)
    if not delayedInitPerformed then
        local fromFunc = "onPlayerEntered"
        prtDbg("player entered", 0, config.modID, 4, fromScript, fromFunc, "SERVER")
        delayedInitPerformed = true
        CorePvP.performDelayedInit()
    end
    if Sector().pvpDamage then
        Player(playerIndex):sendChatMessage("Server", 2, "You have entered a PVP Sector. Be careful!"%_T)
    end
end

function CorePvP.onPlayerLeft(playerIndex)
    if not delayedInitPerformed then
        local fromFunc = "onPlayerLeft"
        prtDbg("player left", 0, config.modID, 4, fromScript, fromFunc, "SERVER")
        delayedInitPerformed = true
        CorePvP.performDelayedInit()
    end
end
