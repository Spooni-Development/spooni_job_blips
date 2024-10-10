local blipData = {}
local UIPrompt = {}
local promptGroup = GetRandomIntInRange(0, 0xffffff)
local VorpCore = exports.vorp_core:GetCore()

-- DevMode
local function Debug(...)
  if Config.DevMode then
      print(...)
  end
end

-- Prompt
UIPrompt.activate = function(title)
    local label = CreateVarString(10, 'LITERAL_STRING', title)
    UiPromptSetActiveGroupThisFrame(promptGroup, label)
end

UIPrompt.initialize = function()
    local str = Translation[Config.Locale]['changeStatus']
    ChangeStatus = UiPromptRegisterBegin()
    UiPromptSetControlAction(ChangeStatus, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    UiPromptSetText(ChangeStatus, str)
    UiPromptSetEnabled(ChangeStatus, 1)
    UiPromptSetVisible(ChangeStatus, 1)
    UiPromptSetStandardMode(ChangeStatus, 1)
    UiPromptSetGroup(ChangeStatus, promptGroup)
    UiPromptSetUrgentPulsingEnabled(ChangeStatus, true)
    UiPromptRegisterEnd(ChangeStatus)
end

-- Functions
local function showBlips(data)
  blipData = data
  for k,v in pairs(blipData) do
    local blip = N_0x554d9d53f696d002(1664425300, v.coords.x, v.coords.y, v.coords.z)
    SetBlipSprite(blip, v.sprite, true)
    SetBlipScale(blip, 0.2)
    SetBlipName(blip, v.name)
    BlipAddModifier(blip, GetHashKey(v.color))
    v.blip = blip
  end
end

local function destroyBlips()
  for k,v in pairs(blipData) do
    Debug(v.blip)
    RemoveBlip(v.blip)
  end
  blipData = {}
  return true
end

local function generateBlips()
  VorpCore.RpcCall("spooni_jobblips:getBlipData", function(data)
    if destroyBlips() == true then
      showBlips(data)
    end
  end)
end

AddEventHandler('onClientResourceStart', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then
    return
  end
  generateBlips()
end)

-- Events
RegisterNetEvent("vorp:initCharacter")
AddEventHandler("vorp:initCharacter", function()
  generateBlips()
end)

RegisterNetEvent("spooni_jobblips:updateBlipsClient")
AddEventHandler("spooni_jobblips:updateBlipsClient", function(newBlipsData)
  if destroyBlips() == true then
    showBlips(newBlipsData)
  end
end)

-- Thread
CreateThread(function()
    UIPrompt.initialize()
    while true do
      Wait(0)
      local sleep = true
      local pCoords = GetEntityCoords(PlayerPedId())

      for _, v in ipairs(blipData) do
        local dist = #(pCoords - v.coords)
        if dist <= v.radius then
            sleep = false
            UIPrompt.activate(v.name)
            if UiPromptHasStandardModeCompleted(ChangeStatus) then
              Debug("^2 Change the status from ^1"..v.name.."^2 Blip ^0")
              TriggerServerEvent("spooni_jobblips:changeBlipData", _)
            end
        end
      end

      if sleep then
        Wait(500)
      end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  destroyBlips()
  Debug("All blips have been removed.")
end)