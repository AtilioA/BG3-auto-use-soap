local function SubscribeToEvents()
  if JsonConfig.GENERAL.enabled == true then
    Utils.DebugPrint(2, "Subscribing to events with JSON config: " .. Ext.Json.Stringify(JsonConfig, { Beautify = true }))
    Ext.Osiris.RegisterListener("CombatEnded", 1, "after", function(combatGuid)
      Utils.DebugPrint(1, "Combat ended. Checking for soap to use.")
      SoapUsage.HygienizePartyMembers()
    end)

    Ext.Osiris.RegisterListener("RequestEndTheDaySuccess", 0, "after", function()
      Utils.DebugPrint(1, "End of the day. Checking for soap to use.")
      -- Iterate party members and use soap if they have any.
      SoapUsage.HygienizePartyMembers()
    end)

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(character)
      Utils.DebugPrint(1, "Teleported to camp. Checking for soap to use for " .. character)

      if Utils.GetGUID(character) == Osi.GetHostCharacter() then
        DeliverSoapToParty()
      end

      -- Use soap on the character if they have any.
      SoapUsage.HygienizePartyMembers()
    end)
  end
end

return {
  SubscribeToEvents = SubscribeToEvents
}
