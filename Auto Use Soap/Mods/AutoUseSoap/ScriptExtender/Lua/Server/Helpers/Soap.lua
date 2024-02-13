Soap = {}

Soap.regular_soap_items = {
  "LOOT_Bathroom_Bucket_Sponges_A",
  "LOOT_Bathroom_Sponge_A",
  "LOOT_Bathroom_Soap_A",
}

Soap.unique_soap_items = {
  "UNI_WYR_Thiefling_HolyHandSoap",
}


function IsSoap(object)
  if IsItem(object) then
    for _, soapItem in ipairs(Soap.regular_soap_items) do
      if string.match(object, soapItem) then
        Utils.DebugPrint(2, "Found regular soap item: " .. object)
        return true
      end
    end
    for _, soapItem in ipairs(Soap.unique_soap_items) do
      if string.match(object, soapItem) then
        return true
      end
    end
  end

  return false
end

function GetRandomRegularSoap()
  return Soap.regular_soap_items[math.random(1, #Soap.regular_soap_items)]
end

-- Refactored to include all party members and check for soap in their inventories and camp chest.
function GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  local inventoriesSoap = {}
  local totalSoapItems = 0

  for _, character in pairs(party) do
    local soapItems = GetSoapInInventory(character[1], false)
    -- Include characters even if they have no soap, indicating an empty table for them.
    inventoriesSoap[character[1]] = soapItems or {}
    totalSoapItems = totalSoapItems + (#soapItems or 0)
  end

  local campChestSoap = GetSoapInCampChest() or {}
  totalSoapItems = totalSoapItems + #campChestSoap

  -- (return total soap count for easy access)
  return inventoriesSoap, campChestSoap, totalSoapItems
end

-- Adjusted to use the refactored GetPartySoap, checking total soap count including camp chest.
function PartyHasEnoughSoap()
  local _, _, totalSoapItems = GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  local partySize = #party

  return totalSoapItems >= partySize
end

function DeliverSoapToParty()
  local inventoriesSoap, campChestSoap, totalSoapItems = GetPartySoap()
  local party = Osi.DB_Players:Get(nil)

  -- Soap has not been delivered yet, so give each character a random soap item.
  if false then
    for _, character in pairs(party) do
      if inventoriesSoap[character[1]] == {} then
        Osi.TemplateAddTo(GetRandomRegularSoap(), character[1], 1, 1)
      end
    end
  else
    -- Send random soap items to camp chest until totalSoapItems matches party size.
    for i = 1, partySize - totalSoapItems do
      Osi.TemplateAddTo(GetRandomRegularSoap(), Utils.GetChestUUID(), 1, 1)
    end
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
    local itemObject = item.TemplateName .. item.Guid
    if IsSoap(itemObject) then
      table.insert(matchedItems, itemObject)
    end
  end

  if #matchedItems > 0 then
    return matchedItems
  else
    return {}
  end
end

function GetSoapInCampChest()
  local chestGUID = Utils.GetChestUUID()
  if chestGUID ~= nil then
    local matchedItems = {}
    local items = GetInventory(chestGUID, false, false)

    for _, item in ipairs(items) do
      local itemObject = item[1]
      if IsSoap(itemObject) then
        table.insert(matchedItems, itemObject)
      end
    end

    if #matchedItems > 0 then
      return matchedItems
    else
      return {}
    end
  end
end

return Soap
