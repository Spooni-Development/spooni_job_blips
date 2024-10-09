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
    PromptSetActiveGroupThisFrame(promptGroup, label)
end

UIPrompt.initialize = function()
    local str = Translation[Config.Locale]['changeStatus']
    ChangeStatus = PromptRegisterBegin()
    PromptSetControlAction(ChangeStatus, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(ChangeStatus, str)
    PromptSetEnabled(ChangeStatus, 1)
    PromptSetVisible(ChangeStatus, 1)
    PromptSetStandardMode(ChangeStatus, 1)
    PromptSetGroup(ChangeStatus, promptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, ChangeStatus, true)
    PromptRegisterEnd(ChangeStatus)
end

-- Functions
local function showBlips(data)
  blipData = data
  for k,v in pairs(blipData) do
    local blip = N_0x554d9d53f696d002(1664425300, v.coords.x, v.coords.y, v.coords.z)
    SetBlipSprite(blip, v.sprite, true)
    SetBlipScale(blip, 0.2)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, GetHashKey(v.color))
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.name)
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
Citizen.CreateThread(function()
    UIPrompt.initialize()
    while true do
      Citizen.Wait(0)
      local sleep = true
      local pCoords = GetEntityCoords(PlayerPedId())

      for _, v in ipairs(blipData) do
          if GetDistanceBetweenCoords(pCoords, v.coords.x, v.coords.y, v.coords.z, true) < v.radius then
              sleep = false
              UIPrompt.activate(v.name)
              if UiPromptHasStandardModeCompleted(ChangeStatus) then
                Debug("^2 Change the status from ^1"..v.name.."^2 Blip ^0")
                TriggerServerEvent("spooni_jobblips:changeBlipData", _)
              end
          end
      end

      if sleep then
        Citizen.Wait(500)
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