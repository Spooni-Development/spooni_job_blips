# 📍 Job Blips
Documentation relating to the [spooni_job_blips](https://github.com/Spooni-Development/spooni_job_blips).

## 1. Installation
spooni_job_blips works only with VORP. 

To install spooni_job_blips:
- Download the resource
  - On [Github](https://github.com/Spooni-Development/spooni_job_blips)
- Drag and drop the resource into your resources folder
  - `spooni_job_blips`
- Add this ensure in your server.cfg
  - `ensure spooni_job_blips`
- Now you can configure and translate the script as you like
  - `config.lua`
  - `translation.lua`
- At the end
  - Restart the server

If you have any problems, you can always open a ticket in the [Spooni Discord](https://discord.gg/spooni).

## 2. Usage
Go to a configured blip and interact with the prompt. The color of the blip then changes.

## 3. For developers

```lua
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

```
