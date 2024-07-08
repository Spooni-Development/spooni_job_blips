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
  ```
    ensure spooni_job_blips
  ```
- Now you can configure and translate the script as you like
  - `config.lua`
  - `translation.lua`
- At the end
  - Restart the server

If you have any problems, you can always open a ticket in the [Spooni Discord](https://discord.gg/spooni).

## 2. Usage
Go to a configured blip and interact with the prompt. The color of the blip then changes.

## 3. For developers

:::details Config.lua
```lua
Config = {}

Config.Locale = 'de' -- en, de, fr
Config.Key = 0x760A9C6F -- G

Config.Blips = {
     {
        name = 'Sheriff Valentine',
        coords = { x = -277.847, y = 807.4005, z = 119.38 },
        radius = 1.5,
        sprite = 1047294027,
        colors = {
            online = 'BLIP_MODIFIER_MP_COLOR_8', -- Green
            offline = 'BLIP_MODIFIER_MP_COLOR_32', -- White
        },
        jobs = {'police'}
    },

    {
        name = 'Sheriff Blackwater',
        coords = { x = -768.043, y = -1267.01, z = 44.053 },
        radius = 1.5,
        sprite = 1047294027,
        colors = {
            online = 'BLIP_MODIFIER_MP_COLOR_8', -- Green
            offline = 'BLIP_MODIFIER_MP_COLOR_32', -- White
        },
        jobs = {'police'}
    },
}
```
:::
