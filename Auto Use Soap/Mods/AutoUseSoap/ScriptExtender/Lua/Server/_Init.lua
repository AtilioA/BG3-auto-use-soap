Ext.Require("Server/Utils.lua")
Ext.Require("Server/Config.lua")
Ext.Require("Server/Helpers/Inventory.lua")
Ext.Require("Server/Helpers/Soap.lua")
Ext.Require("Server/SoapUsage.lua")

MOD_UUID = "cabed99e-5db6-4f0d-a69f-d49e8a20e663"
local MODVERSION = Ext.Mod.GetMod(MOD_UUID).Info.ModVersion

if MODVERSION == nil then
    Utils.DebugPrint(0, "loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    Utils.DebugPrint(0, "version " .. versionNumber .. " loaded")
end

-- Ext.Vars.RegisterModVariable(MOD_UUID, "HasDeliveredInitialSoap", {
--     Server = true, Client = true, SyncToClient = true
-- })

-- AutoUseSoapVars = Ext.Vars.GetModVariables(MOD_UUID)

local EventSubscription = Ext.Require("Server/SubscribedEvents.lua")
EventSubscription.SubscribeToEvents()
