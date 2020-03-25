--Core PvP (C) 2019-2020 Shrooblord
--Initialisation file for the Core PvP mod.
package.path = package.path .. ";data/scripts/lib/?.lua"
package.path = package.path .. ";data/scripts/config/?.lua"

if onClient() then return end

include ("sMPrint")
local config = include ("corePvPConfig")

function initCorePvP()
    local fromScript = "sector/init"
    local fromFunc = "initCorePvP"

    local sector = Sector()
    local x, y = sector:getCoordinates()
    prtDbg("Checking Sector eligibility...", 0, config.modID, 1, fromScript, fromFunc, "SERVER")

    local distToCentre = math.floor(length(vec2(x, y)))

    -- custom settings that override config file settings
    local forcePVPState = sector:getValue("corePvP_forceEnabled_PvP")

    if (distToCentre <= config.PvPZoneDist and forcePVPState == nil) or forcePVPState then
        prtDbg("Sector is eligible!", 0, config.modID, 1, fromScript, fromFunc, "SERVER")
        Sector():addScriptOnce("sector/corePvP.lua")
    else
        prtDbg("Skipping Sector.", 0, config.modID, 1, fromScript, fromFunc, "SERVER")
    end
end

initCorePvP()
