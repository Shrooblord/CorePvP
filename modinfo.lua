--Core PvP (C) 2019 Shrooblord
meta =
{
    id = "1923214209", --1923214209 on WS
    name = "CorePvP",
    title = "Core PvP",
    description = "Designate a section of the Galaxy as PvP zone; in the rest of the Galaxy, PvP is disabled.",
    authors = {"Shrooblord"},
    version = "1.0.0",

    dependencies = {
        {id = "Avorion", min = "0.29", max = "0.29.2"},

        --[[Shrooblord]]
        {id = "1847767864", min = "1.1.0"},              --ShrooblordMothership (library mod)
        --{id = "ShrooblordMothership", min = "1.1.0"},              --ShrooblordMothership (library mod)
    },

    serverSideOnly = false,
    clientSideOnly = false,
    saveGameAltering = true,

    contact = "avorion@shrooblord.com",
}