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

function EHandlers.OnAddBlood()
    AUSPrint(1, "Adding blood for debugging purposes")
    Osi.ApplyStatus(Osi.GetHostCharacter(), "DEBUG_BLOOD", 10, 100)
end

function EHandlers.OnAddDirt()
    AUSPrint(1, "Adding dirt for debugging purposes")
    Osi.ApplyStatus(Osi.GetHostCharacter(), "DEBUG_DIRT", 10, 100)
end

return EHandlers
