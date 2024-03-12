---@class HelperSoap: Helper
Helpers.Soap = _Class:Create("HelperSoap", Helper)

Helpers.Soap.regular_soap_items = {
  ["LOOT_Bathroom_Bucket_Sponges_A"] = "8e11fada-192f-4042-8c84-dc7b78f32541",
  ["LOOT_Bathroom_Sponge_A"] = "90aad18c-a1ae-44c9-903f-f9c9433c9362",
  ["LOOT_Bathroom_Soap_A"] = "d32a68ff-3b6a-4d83-b0c4-0a2c44b93ea9",
}

Helpers.Soap.unique_soap_items = {
  ["UNI_WYR_Thiefling_HolyHandSoap"] = "42d56907-aa68-4f77-a024-3789c3232142"
}

--- Checks if the given object is a soap item.
---@param object GameObjectTemplate|Guid The object to check.
---@return boolean - true if the object is a soap item, false otherwise.
function Helpers.Soap:IsSoap(object)
  -- Check against regular and unique soap items by their values (template IDs)
  for _, soapItem in pairs(self.regular_soap_items) do
    if soapItem == object then
      return true
    end
  end
  for _, soapItem in pairs(self.unique_soap_items) do
    if soapItem == object then
      return true
    end
  end
  return false
end

--- Gets a random regular soap item.
---@return Guid soapItemsArrayItemID Returns the ID of a random regular soap item.
function Helpers.Soap:GetRandomRegularSoap()
  local soapItemsArray = {}
  for _, value in pairs(Soap.regular_soap_items) do
    table.insert(soapItemsArray, value)
  end

  local randomIndex = math.random(1, #soapItemsArray)
  return soapItemsArray[randomIndex]
end

--- Gets all soap items in the camp chest.
---@return table matchedItems Returns a table of soap items in the camp chest; empty table if none found.
function Helpers.Soap:GetSoapInCampChest()
  local chestGUID = Helpers.Camp:GetChestTemplateUUID()
  if chestGUID then
    local matchedItems = {}
    local items = Helpers.Inventory:GetInventory(chestGUID, false, false)

    for _, item in ipairs(items) do
      if self:IsSoap(item.TemplateId) then
        table.insert(matchedItems, item.TemplateName .. "_" .. item.Guid)
      end
    end
    return matchedItems
  else
    return {}
  end
end

--- Gets all soap items in a character's inventory.
---@param character Guid character to check.
---@param shallow boolean If true, recursively checks inside bags and containers.
---@return table | nil - table of soap items in the character's inventory, or nil if none found.
function Helpers.Soap:GetSoapInInventory(character, shallow)
  local inventory = Helpers.Inventory:GetInventory(character, false, shallow)
  local matchedItems = {}

  for _, item in ipairs(inventory) do
    if self:IsSoap(item.TemplateId) then
      table.insert(matchedItems, Helpers.Object:GetItemUUID(item))
    end
  end

  if #matchedItems > 0 then
    return matchedItems
  else
    return {}
  end
end

--- Gets all soap items in the party's inventories and the camp chest.
---@return table, table, number - a table of soap items in each character's inventory, a table of soap items in the camp chest, and the total number of soap items in the party's possession.
function Helpers.Soap:GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  local inventoriesSoap = {}            -- Placeholder for inventory soap gathering logic
  local campChestSoap = self:GetSoapInCampChest() or {}
  local totalSoapItems = #campChestSoap -- Initialize with count of soap items in camp chest
  AUSPrinter(2, "Total soap items in camp chest: " .. totalSoapItems)

  for _, character in pairs(party) do
    local soapItems = self:GetSoapInInventory(character[1], false)
    -- Include characters even if they have no soap
    inventoriesSoap[character[1]] = soapItems or {}
    totalSoapItems = totalSoapItems + (#soapItems or 0)
  end

  AUSPrinter(2, "Total soap items in party: " .. totalSoapItems)

  return inventoriesSoap, campChestSoap, totalSoapItems
end

--- Checks if the party has enough soap items. Enough is defined by the number of party members (atm will not include idle members at camp).
---@return boolean Returns true if the party has enough soap items, false otherwise.
function Helpers.Soap:PartyHasEnoughSoap()
  local _, _, totalSoapItems = self:GetPartySoap()
  local partySize = #Osi.DB_Players:Get(nil) -- This will not get party members idle at camp
  AUSPrinter(2, "Party size: " .. partySize)
  return totalSoapItems >= partySize
end

--- Delivers soap items to the party members based on the number of soap items in the party's possession.
function Helpers.Soap:DeliverSoapToParty()
  AUSPrinter(1, "Delivering soap to party members.")
  local inventoriesSoap, campChestSoap, totalSoapItems = self:GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  AUSPrinter(2, "Party members: " .. Ext.Json.Stringify(party, { Beautify = true }))
  AUSPrinter(2, "Inventories soap: " .. Ext.Json.Stringify(inventoriesSoap, { Beautify = true }))
  AUSPrinter(2, "Camp chest soap: " .. Ext.Json.Stringify(campChestSoap, { Beautify = true }))

  -- -- Soap has not been delivered yet, so give each character a random soap item.
  -- if false then
  --   for _, character in pairs(party) do
  --     if inventoriesSoap[character[1]] == {} then
  --       Osi.TemplateAddTo(self:GetRandomRegularSoap(), character[1], 1, 1)
  --     end
  --   end
  -- else

  -- Send random soap items to camp chest until totalSoapItems matches party size.
  for i = 1, #party - totalSoapItems do
    local randomSoapItem = self:GetRandomRegularSoap()
    AUSPrinter(2, "Adding random soap item to camp chest: " .. randomSoapItem)
    Osi.TemplateAddTo(randomSoapItem, Helpers.Camp:GetChestTemplateUUID(), 1)
    -- end
  end
end

--- Uses soap items on all party members that have any.
function Helpers.Soap:HygienizePartyMembers()
  for _, character in pairs(Osi.DB_Players:Get(nil)) do
    -- Use soap with the character if they have any.
    character = character[1]
    local soapItems = self:GetSoapInInventory(character, false)
    if soapItems then
      for _, soapItem in pairs(soapItems) do
        AUSPrinter(1, "Using soap on " .. character .. " with item " .. soapItem)
        Osi.Use(character, soapItem, "AutoUseSoapAutomaticUsage")
      end
    end
  end
end
