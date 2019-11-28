--Core PvP (C) 2019 Shrooblord
meta =
{
    id = "CorePvP",
    name = "CorePvP",
    title = "Core PvP",
    description = "[Server Admins] Designate a section of the Galaxy as PvP zone; in the rest of the Galaxy, PvP is disabled.",
    authors = {"Shrooblord"},
    version = "0.1.0",

    dependencies = {
        {id = "Avorion", min = "0.29", max = "0.29.2"},

        --[[Shrooblord]]
        --{id = "1847767864", min = "1.0.0"},              --ShrooblordMothership (library mod)
        {id = "ShrooblordMothership", min = "1.1.0"},              --ShrooblordMothership (library mod)
    },

    serverSideOnly = true,
    clientSideOnly = false,
    saveGameAltering = true,

    contact = "avorion@shrooblord.com",
}