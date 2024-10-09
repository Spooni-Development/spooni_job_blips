Config = {}

Config.DevMode = true
Config.Locale = 'en' -- en, de
Config.Key = 0x760A9C6F -- G

Config.Blips = {
    {
        name = 'Sheriff Valentine',
        coords = vector3(-277.847, 807.4005, 119.38),
        radius = 1.5,
        sprite = 1047294027, -- blip
        colors = { online = 'BLIP_MODIFIER_MP_COLOR_8', --[[Green]] offline = 'BLIP_MODIFIER_MP_COLOR_32', --[[White]] },
        jobs = { 'sheriff','marshal' },
        notify = true, -- global notify when the status changes

    },
    {
        name = 'Sheriff Blackwater',
        coords = vector3(-768.043, -1267.01, 44.053),
        radius = 1.5,
        sprite = 1047294027,
        colors = { online = 'BLIP_MODIFIER_MP_COLOR_8', --[[Green]] offline = 'BLIP_MODIFIER_MP_COLOR_32', --[[White]] },
        jobs = { 'police','marshal' },
        notify = true,
        needJob = false,
    },
}
