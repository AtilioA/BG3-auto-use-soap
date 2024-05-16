SubscribedEvents = {}

function SubscribedEvents:SubscribeToEvents()
    local function conditionalWrapper(handler)
        return function(...)
            if MCMGet("mod_enabled") then
                handler(...)
            else
                AUSPrint(1, "Event handling is disabled.")
            end
        end
    end

    AUSPrint(2,
        "Subscribing to events with JSON config: " ..
        Ext.Json.Stringify(Mods.BG3MCM.MCMAPI:GetAllModSettings(ModuleUUID), { Beautify = true }))

    Ext.Osiris.RegisterListener("CombatEnded", 1, "after", conditionalWrapper(EHandlers.OnCombatEnded))
    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", conditionalWrapper(EHandlers.OnTeleportedToCamp))
    Ext.RegisterNetListener("AUS_AddBlood", conditionalWrapper(EHandlers.OnAddBlood))
    Ext.RegisterNetListener("AUS_AddDirt", conditionalWrapper(EHandlers.OnAddDirt))
end

return SubscribedEvents
