Soap = {}

Soap.regular_soap_items = {
  ["LOOT_Bathroom_Bucket_Sponges_A"] = "8e11fada-192f-4042-8c84-dc7b78f32541",
  ["LOOT_Bathroom_Sponge_A"] = "90aad18c-a1ae-44c9-903f-f9c9433c9362",
  ["LOOT_Bathroom_Soap_A"] = "d32a68ff-3b6a-4d83-b0c4-0a2c44b93ea9",
}

Soap.unique_soap_items = {
  ["UNI_WYR_Thiefling_HolyHandSoap"] = "42d56907-aa68-4f77-a024-3789c323214d"
}

function IsSoap(object)
  -- Check against regular and unique soap items by their values (template IDs)
  for _, soapItem in pairs(Soap.regular_soap_items) do
    if soapItem == object then
      return true
    end
  end
  for _, soapItem in pairs(Soap.unique_soap_items) do
    if soapItem == object then
      return true
    end
  end
  return false
end

function GetRandomRegularSoap()
  local soapItemsArray = {}
  for _, value in pairs(Soap.regular_soap_items) do
    table.insert(soapItemsArray, value)
  end

  local randomIndex = math.random(1, #soapItemsArray)
  return soapItemsArray[randomIndex]
end

function GetSoapInCampChest()
  local chestGUID = Utils.GetChestUUID()
  if chestGUID then
    local matchedItems = {}
    local items = GetInventory(chestGUID, false, false) -- Assuming GetInventory returns a list of item objects with TemplateId properties

    for _, item in ipairs(items) do
      if IsSoap(item.TemplateId) then
        table.insert(matchedItems, item.TemplateName .. "_" .. item.Guid)
      end
    end
    return matchedItems
  else
    return {}
  end
end

--- Gets all soap items in a character's inventory.
---@param character any character to check.
---@param shallow boolean If true, recursively checks inside bags and containers.
---@return table | nil - table of soap items in the character's inventory, or nil if none found.
function GetSoapInInventory(character, shallow)
  local inventory = GetInventory(character, false, shallow)
  local matchedItems = {}

  for _, item in ipairs(inventory) do
    if IsSoap(item.TemplateId) then
      table.insert(matchedItems, item.TemplateId)
    end
  end

  if #matchedItems > 0 then
    return matchedItems
  else
    return {}
  end
end

function GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  local inventoriesSoap = {}            -- Placeholder for inventory soap gathering logic
  local campChestSoap = GetSoapInCampChest() or {}
  local totalSoapItems = #campChestSoap -- Initialize with count of soap items in camp chest
  Utils.DebugPrint(2, "Total soap items in camp chest: " .. totalSoapItems)

  for _, character in pairs(party) do
    local soapItems = GetSoapInInventory(character[1], false)
    -- Include characters even if they have no soap
    inventoriesSoap[character[1]] = soapItems or {}
    totalSoapItems = totalSoapItems + (#soapItems or 0)
  end

  Utils.DebugPrint(2, "Total soap items in party: " .. totalSoapItems)

  return inventoriesSoap, campChestSoap, totalSoapItems
end

function PartyHasEnoughSoap()
  local _, _, totalSoapItems = GetPartySoap()
  local partySize = #Osi.DB_Players:Get(nil) -- This will not get party members idle at camp
  Utils.DebugPrint(2, "Party size: " .. partySize)
  return totalSoapItems >= partySize
end

function DeliverSoapToParty()
  Utils.DebugPrint(1, "Delivering soap to party members.")
  local inventoriesSoap, campChestSoap, totalSoapItems = GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  Utils.DebugPrint(2, "Party members: " .. Ext.Json.Stringify(party, { Beautify = true }))
  Utils.DebugPrint(2, "Inventories soap: " .. Ext.Json.Stringify(inventoriesSoap, { Beautify = true }))
  Utils.DebugPrint(2, "Camp chest soap: " .. Ext.Json.Stringify(campChestSoap, { Beautify = true }))

  -- -- Soap has not been delivered yet, so give each character a random soap item.
  -- if false then
  --   for _, character in pairs(party) do
  --     if inventoriesSoap[character[1]] == {} then
  --       Osi.TemplateAddTo(GetRandomRegularSoap(), character[1], 1, 1)
  --     end
  --   end
  -- else
    
  -- Send random soap items to camp chest until totalSoapItems matches party size.
  for i = 1, #party - totalSoapItems do
    local randomSoapItem = GetRandomRegularSoap()
    Utils.DebugPrint(2, "Adding random soap item to camp chest: " .. randomSoapItem)
    Osi.TemplateAddTo(randomSoapItem, Utils.GetChestUUID(), 1)
    -- end
  end
end

return Soap
