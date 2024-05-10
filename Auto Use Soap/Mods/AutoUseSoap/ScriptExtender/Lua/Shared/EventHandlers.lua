EHandlers = {}

function EHandlers.OnCombatEnded(combatGuid)
    if Mods.BG3MCM.MCMAPI:GetSettingValue("use_after_combat", ModuleUUID) then
        AUSPrint(1, "Combat ended. Checking for soap to use for party.")
        SoapHelperInstance:HygienizePartyMembers()
    end
end

function EHandlers.OnTeleportedToCamp(character)
    if Mods.BG3MCM.MCMAPI:GetSettingValue("use_when_entering_camp", ModuleUUID) then
        AUSPrint(1, "Teleported to camp. Checking for soap to use for " .. character)

        if VCHelpers.Format:Guid(character) == Osi.GetHostCharacter() and Mods.BG3MCM.MCMAPI:GetSettingValue("add_soap_items", ModuleUUID) then
            SoapHelperInstance:DeliverSoapToParty()
        end

        SoapHelperInstance:HygienizePartyMembers()
    end
end

return EHandlers
