---@class HelperSoap: Helper
VCHelpers.Soap = _Class:Create("HelperSoap", Helper)

VCHelpers.Soap.regular_soap_items = {
  ["LOOT_Bathroom_Bucket_Sponges_A"] = "8e11fada-192f-4042-8c84-dc7b78f32541",
  ["LOOT_Bathroom_Sponge_A"] = "90aad18c-a1ae-44c9-903f-f9c9433c9362",
  ["LOOT_Bathroom_Soap_A"] = "d32a68ff-3b6a-4d83-b0c4-0a2c44b93ea9",
}

VCHelpers.Soap.unique_soap_items = {
  ["UNI_WYR_Thiefling_HolyHandSoap"] = "42d56907-aa68-4f77-a024-3789c3232142"
}

--- Checks if the given object is a soap item.
---@param object GameObjectTemplate|Guid The object to check.
---@return boolean - true if the object is a soap item, false otherwise.
function VCHelpers.Soap:IsSoap(object)
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
function VCHelpers.Soap:GetRandomRegularSoap()
  local soapItemsArray = {}
  for _, value in pairs(self.regular_soap_items) do
    table.insert(soapItemsArray, value)
  end

  local randomIndex = math.random(1, #soapItemsArray)
  return soapItemsArray[randomIndex]
end

--- Gets all soap items in the camp chest.
---@return table matchedItems Returns a table of soap items in the camp chest; nil if none found.
function VCHelpers.Soap:GetSoapInCampChest(shallow)
  local chestGUID = VCHelpers.Camp:GetChestTemplateUUID()
  if chestGUID then
    local inventory = VCHelpers.Inventory:GetInventory(chestGUID, true, shallow)
    return self:GetSoapInInventory(inventory)
  end
end

--- Gets all soap items in a character's inventory, considering stack sizes.
---@param character Guid character to check.
---@param shallow boolean If true, recursively checks inside bags and containers.
---@return table - table of soap items in the character's inventory, or nil if none found.
function VCHelpers.Soap:GetSoapInCharacterInventory(character, shallow)
  local inventory = VCHelpers.Inventory:GetInventory(character, true, shallow)
  return self:GetSoapInInventory(inventory)
end

--- Gets all soap items in a inventory, considering stack sizes.
---@param inventory {Entity:EntityHandle, Guid:Guid, Name:string, TemplateId:string, TemplateName:string}[]
---@param shallow boolean If true, recursively checks inside bags and containers.
---@return table - table of soap items in the character's inventory, or nil if none found.
function VCHelpers.Soap:GetSoapInInventory(inventory)
  local matchedItems = {}

  for _, item in ipairs(inventory) do
    if self:IsSoap(item.TemplateId) then
      local itemUUID = VCHelpers.Object:GetItemUUID(item)
      local exactamount, totalamount = Osi.GetStackAmount(itemUUID) -- Account for the stack amount

      -- If the item already exists in the matchedItems, increment the quantity by the stack amount.
      if matchedItems[itemUUID] then
        -- This is necessary because there are no unique item UUIDs when having a stacks of items.
        matchedItems[itemUUID].amount = matchedItems[itemUUID].amount + totalamount
      else
        -- Insert the item with its stack amount into matchedItems if it doesn't exist yet.
        matchedItems[itemUUID] = { templateId = item.TemplateId, amount = totalamount }
      end
    end
  end

  return matchedItems
end

function VCHelpers.Soap:CountSoapItems(soapItems)
  if not soapItems then
    return 0
  end

  local count = 0
  for _, item in pairs(soapItems) do
    count = count + item.amount
  end
  return count
end

--- Gets all soap items in the party's inventories and the camp chest.
---@return table|nil, table|nil, number - a table of soap items in each character's inventory, a table of soap items in the camp chest, and the total number of soap items in the party's possession.
function VCHelpers.Soap:GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  local inventoriesSoap = {}                                          -- Placeholder for inventory soap gathering logic
  local campChestSoap = self:GetSoapInCampChest(false)
  local totalSoapItems = VCHelpers.Soap:CountSoapItems(campChestSoap) -- Initialize with count of soap items in camp chest
  AUSPrint(2, "Total soap items in camp chest: " .. totalSoapItems)

  for _, character in pairs(party) do
    local soapItems = self:GetSoapInCharacterInventory(character[1], false)
    -- Include characters even if they have no soap
    inventoriesSoap[character[1]] = soapItems
    totalSoapItems = totalSoapItems + VCHelpers.Soap:CountSoapItems(soapItems)
  end

  AUSPrint(2, "Total soap items in party: " .. totalSoapItems)

  return inventoriesSoap, campChestSoap, totalSoapItems
end

--- Checks if the party has enough soap items. Enough is defined by the number of party members (atm will not include idle members at camp).
---@return boolean Returns true if the party has enough soap items, false otherwise.
function VCHelpers.Soap:PartyHasEnoughSoap()
  local _, _, totalSoapItems = self:GetPartySoap()
  local partySize = #Osi.DB_Players:Get(nil) -- This will not get party members idle at camp
  AUSPrint(2, "Party size: " .. partySize)
  return totalSoapItems >= partySize
end

--- Delivers soap items to the party members based on the number of soap items in the party's possession.
function VCHelpers.Soap:DeliverSoapToParty()
  AUSPrint(1, "Delivering soap for party members.")
  local inventoriesSoap, campChestSoap, totalSoapItems = self:GetPartySoap()
  local party = Osi.DB_Players:Get(nil)
  AUSDebug(3, "Party members: " .. Ext.Json.Stringify(party, { Beautify = true }))
  AUSDebug(2, "Inventories soap: " .. Ext.Json.Stringify(inventoriesSoap, { Beautify = true }))
  AUSDebug(2, "Camp chest soap: " .. Ext.Json.Stringify(campChestSoap, { Beautify = true }))

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
    AUSPrint(2, "Adding random soap item to camp chest: " .. randomSoapItem)
    Osi.TemplateAddTo(randomSoapItem, VCHelpers.Camp:GetChestTemplateUUID(), 1)
    -- end
  end
end

--- Uses soap items on all party members that have any.
function VCHelpers.Soap:HygienizePartyMembers()
  for _, character in pairs(Osi.DB_Players:Get(nil)) do
    -- Use soap with the character if they have any.
    character = character[1]
    local soapItems = self:GetSoapInCharacterInventory(character, false)
    if soapItems then
      for _, soapItem in pairs(soapItems) do
        AUSPrint(1, "Using soap on " .. character .. " with item " .. soapItem.templateId)
        Osi.Use(character, soapItem.templateId, "AutoUseSoapAutomaticUsage")
      end
    end
  end
end
