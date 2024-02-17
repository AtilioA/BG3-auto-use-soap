local function SubscribeToEvents()
  if JsonConfig.GENERAL.enabled == true then
    Utils.DebugPrint(2, "Subscribing to events with JSON config: " .. Ext.Json.Stringify(JsonConfig, { Beautify = true }))
    Ext.Osiris.RegisterListener("CombatEnded", 1, "after", function(combatGuid)
      if JsonConfig.FEATURES.use_after_combat == true then
        Utils.DebugPrint(1, "Combat ended. Checking for soap to use.")
        SoapUsage.HygienizePartyMembers()
      end
    end)

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(character)
      if JsonConfig.FEATURES.use_when_entering_camp == true then
        Utils.DebugPrint(1, "Teleported to camp. Checking for soap to use for " .. character)

        if Utils.GetGUID(character) == Osi.GetHostCharacter() and JsonConfig.FEATURES.add_soap_items == true then
          DeliverSoapToParty()
        end

        SoapUsage.HygienizePartyMembers()
      end
    end)
  end
end

return {
  SubscribeToEvents = SubscribeToEvents
}
