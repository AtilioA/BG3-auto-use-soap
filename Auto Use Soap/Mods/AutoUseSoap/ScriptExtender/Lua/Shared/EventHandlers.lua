EHandlers = {}

function EHandlers.OnCombatEnded(combatGuid)
    if MCMGet("use_after_combat") then
        AUSPrint(1, "Combat ended. Checking for soap to use for party.")
        SoapHelperInstance:HygienizePartyMembers()
    end
end

function EHandlers.OnTeleportedToCamp(character)
    if MCMGet("use_when_entering_camp") then
        AUSPrint(1, "Teleported to camp. Checking for soap to use for " .. character)

        if VCHelpers.Format:Guid(character) == Osi.GetHostCharacter() and MCMGet("add_soap_items") then
            SoapHelperInstance:DeliverSoapToParty()
        end

        SoapHelperInstance:HygienizePartyMembers()
    end
end

return EHandlers
