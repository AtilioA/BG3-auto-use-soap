setmetatable(Mods.AutoUseSoap, { __index = Mods.VolitionCabinet })

---Ext.Require files at the path
---@param path string
---@param files string[]
function RequireFiles(path, files)
    for _, file in pairs(files) do
        Ext.Require(string.format("%s%s.lua", path, file))
    end
end

RequireFiles("Shared/", {
    "Helpers/_Init",
    "SubscribedEvents",
    "EventHandlers",
})

Ext.Require("Shared/Helpers/Inventory.lua")
Ext.Require("Shared/Helpers/Soap.lua")

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion

if MODVERSION == nil then
    AUSWarn(0, "Volitio's Auto Use Soap loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    AUSPrinter(0, "Volitio's Auto Use Soap " .. versionNumber .. " loaded")
end

SoapHelperInstance = Helpers.Soap:New()

SubscribedEvents.SubscribeToEvents()
