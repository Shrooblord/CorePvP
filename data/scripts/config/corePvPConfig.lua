--Core PvP (C) 2019-2020 Shrooblord
--Configuration file for the Core PvP mod.

package.path = package.path .. ";data/scripts/config/?.lua"

include("sMConf")

local CorePvPConf = {
    modID = "CPvP",                     --identifier for the mod used in print strings, in this case, "Core PvP"
    PvPZoneDist = 120,                  --distance to Core (0:0) in Sectors at which PvP is engaged. Beyond this distance, PvP is disabled entirely (PvE only). Set to -1 to disable PvP everywhere; or 1000 to make the entire Galaxy PvP.
    PvPZoneDisableNeutralZone = false,  --whether or not Neutral Zones should also be force-disabled in the Core PvP area (defined by PvPZoneDist). Neutral Zones outside the Core PvP area are left untouched.
    develop = false,                    --development/debug mode
    dbgLevel = 4                        --0 = off; 1 = info; 2 = verbose; 3 = extremely verbose; 4 = I WANT TO KNOW EVERYTHING
}

table.insert(sMConf, CorePvPConf)

return CorePvPConf

--[[    *** UNINSTALLATION NOTE ***
    If you ever had PvPZoneDisableNeutralZone set to true, you must first run your Server with this mod
    enabled again, but now with PvPZoneDisableNeutralZone set to false. If you don't, the Neutral Zones
    that once existed in the PvP Core will not be restored.

    If at a later date you reinstall this mod, you can always perform this uninstallation step after the
    fact. Your old Neutral Zones will be restored.
]]
