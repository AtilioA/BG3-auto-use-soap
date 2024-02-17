SoapUsage = {}

function SoapUsage.HygienizePartyMembers()
  for _, character in pairs(Osi.DB_Players:Get(nil)) do
    -- Use soap with the character if they have any.
    character = character[1]
    local soapItems = GetSoapInInventory(character, false)
    if soapItems then
      for _, soapItem in pairs(soapItems) do
        Utils.DebugPrint(1, "Using soap on " .. character .. " with item " .. soapItem)
        Osi.Use(character, soapItem, "AutoUseSoap")
      end
    end
  end
end

return SoapUsage
