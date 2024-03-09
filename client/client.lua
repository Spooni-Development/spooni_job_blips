local blipData = {}
local Prompt = GetRandomIntInRange(0, 0xffffff)
local VorpCore = exports.vorp_core:GetCore()

AddEventHandler('onClientResourceStart', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then
    return
  end
  generateBlips()
end)

RegisterNetEvent("vorp:initCharacter")
AddEventHandler("vorp:initCharacter", function()
  generateBlips()
end)

-- DevMode

function Debug(...)
  if Config.DevMode then
      print(...)
  end
end

-- Prompt

function ChangeStatusPrompt()
    Citizen.CreateThread(function()
        local str = Translation[Config.Locale]['changeStatus']
        ChangeStatus = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(ChangeStatus, Config.Key)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(ChangeStatus, str)
        PromptSetEnabled(ChangeStatus, true)
        PromptSetVisible(ChangeStatus, true)
        PromptSetHoldMode(ChangeStatus, false)
        PromptSetGroup(ChangeStatus, Prompt)
        PromptRegisterEnd(ChangeStatus)
    end)
end

function DisplayPrompt(name)
    local PromptGroup = CreateVarString(10, 'LITERAL_STRING', name)
    PromptSetActiveGroupThisFrame(Prompt, PromptGroup)
end

-- BLip

function generateBlips()
  VorpCore.RpcCall("spooni_jobblips:getBlipData", function(data)
    if destroyBlips() == true then
      showBlips(data)
    end
  end)
end

function showBlips(data)
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

function destroyBlips()
  for k,v in pairs(blipData) do
    Debug(v.blip)
    RemoveBlip(v.blip)
  end
  blipData = {}
  return true
end

RegisterNetEvent("spooni_jobblips:updateBlipsClient")
AddEventHandler("spooni_jobblips:updateBlipsClient", function(newBlipsData)
  if destroyBlips() == true then
    showBlips(newBlipsData)
  end
end)

Citizen.CreateThread(function()
    ChangeStatusPrompt()
    while true do
        Citizen.Wait(5)
        local player = PlayerPedId()
        local pCoords = GetEntityCoords(player) 

        for _, v in pairs(blipData) do
            if GetDistanceBetweenCoords(pCoords, v.coords.x, v.coords.y, v.coords.z, true) < v.radius then
                DisplayPrompt(v.name)
                if Citizen.InvokeNative(0x305C8DCD79DA8B0F, 0, Config.Key) then
                  Debug("^2 Change the status from ^1"..v.name.."^2 Blip ^0")
                  TriggerServerEvent("spooni_jobblips:changeBlipData", _)
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  destroyBlips()
  Debug("All blips have been removed")
end)