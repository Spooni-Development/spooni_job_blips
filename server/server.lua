local blipData = {}
local VorpCore = exports.vorp_core:GetCore()

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  for k,v in pairs(Config.Blips) do
    local blip = {blip = nil, coords = v.coords, name = v.name, sprite = v.sprite, color = v.colors.offline, status = 0, radius = v.radius}
    table.insert(blipData,blip)
  end
end)

VorpCore.addRpcCallback("spooni_jobblips:getBlipData", function(source, cb, arrayIndex)
  cb(blipData)
end)

RegisterServerEvent('spooni_jobblips:changeBlipData')
AddEventHandler('spooni_jobblips:changeBlipData', function(blipArrayIndex)
  local src = source
  local Character = VorpCore.getUser(src).getUsedCharacter
  local job = Character.job
  local found = false

  for k, v in pairs(Config.Blips[blipArrayIndex].jobs) do
    if job == v then
      found = true
      break
    end
  end

  if found == true then
    if blipData[blipArrayIndex].status == 0 then
      blipData[blipArrayIndex].status = 1
      blipData[blipArrayIndex].color = Config.Blips[blipArrayIndex].colors.online
    else
      blipData[blipArrayIndex].status = 0
      blipData[blipArrayIndex].color = Config.Blips[blipArrayIndex].colors.offline
    end
    TriggerClientEvent('spooni_jobblips:updateBlipsClient', -1, blipData)
  else
    VorpCore.NotifyAvanced(src, Translation[Config.Locale]['noPerms'], "menu_textures", "cross", "COLOR_ENEMY", 5000)
  end
end)


