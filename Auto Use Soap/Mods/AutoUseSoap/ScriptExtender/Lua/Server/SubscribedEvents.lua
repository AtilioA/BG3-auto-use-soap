SubscribedEvents = {}

function SubscribedEvents:SubscribeToEvents()
    local function conditionalWrapper(handler)
        return function(...)
            if MCM.Get("mod_enabled") then
                handler(...)
            else
                AUSPrint(1, "Event handling is disabled.")
            end
        end
    end

    Ext.Osiris.RegisterListener("CombatEnded", 1, "after", conditionalWrapper(EHandlers.OnCombatEnded))
    Ext.Osiris.RegisterListener("TeleportedToCamp", 1, "after", conditionalWrapper(EHandlers.OnTeleportedToCamp))
    Ext.Net.CreateChannel(ModuleUUID, "AddBlood"):SetHandler(conditionalWrapper(EHandlers.OnAddBlood))
    Ext.Net.CreateChannel(ModuleUUID, "AddDirt"):SetHandler(conditionalWrapper(EHandlers.OnAddDirt))
end

return SubscribedEvents
