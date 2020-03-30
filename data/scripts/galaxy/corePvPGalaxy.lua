--Core PvP (C) 2019-2020 Shrooblord
--Galaxy initialisation file for the Core PvP mod.

function initialize()
    --blanket-disable PvP damage for the entire Galaxy. We will later re-enable PvP damage for all Sectors close enough to the Core as defined by config
    Server().playerToPlayerDamage = false
end
