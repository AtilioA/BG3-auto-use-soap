SubscribedEvents = {}

function SubscribedEvents.SubscribeToEvents()
  if Config:getCfg().GENERAL.enabled == true then
    AUSPrint(2, "Subscribing to events with JSON config: " .. Ext.Json.Stringify(Config:getCfg(), { Beautify = true }))

    Ext.Osiris.RegisterListener("CombatEnded", 1, "after", function(combatGuid)
      if Config:getCfg().FEATURES.use_after_combat == true then
        AUSPrint(1, "Combat ended. Checking for soap to use for party.")
        SoapHelperInstance:HygienizePartyMembers()
      end
    end)

    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", function(character)
      if Config:getCfg().FEATURES.use_when_entering_camp == true then
        AUSPrint(1, "Teleported to camp. Checking for soap to use for " .. character)

        if Helpers.Format:Guid(character) == Osi.GetHostCharacter() and Config:getCfg().FEATURES.add_soap_items == true then
          SoapHelperInstance:DeliverSoapToParty()
        end

        SoapHelperInstance:HygienizePartyMembers()
      end
    end)
  end
end

return SubscribedEvents
