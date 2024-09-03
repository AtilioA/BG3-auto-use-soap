AUSPrinter = VolitionCabinetPrinter:New { Prefix = "Auto Use Soap", ApplyColor = true, DebugLevel = MCMGet("debug_level") }

-- Update the Printer debug level when the setting is changed, since the value is only used during the object's creation
Ext.ModEvents.BG3MCM['MCM_Setting_Saved']:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end

    if payload.settingId == "debug_level" then
        AUSDebug(0, "Setting debug level to " .. payload.value)
        AUSPrinter.DebugLevel = payload.value
    end
end)

function AUSPrint(debugLevel, ...)
    AUSPrinter:SetFontColor(0, 255, 255)
    AUSPrinter:Print(debugLevel, ...)
end

function AUSTest(debugLevel, ...)
    AUSPrinter:SetFontColor(100, 200, 150)
    AUSPrinter:PrintTest(debugLevel, ...)
end

function AUSDebug(debugLevel, ...)
    AUSPrinter:SetFontColor(200, 200, 0)
    AUSPrinter:PrintDebug(debugLevel, ...)
end

function AUSWarn(debugLevel, ...)
    AUSPrinter:SetFontColor(255, 100, 50)
    AUSPrinter:PrintWarning(debugLevel, ...)
end

function AUSDump(debugLevel, ...)
    AUSPrinter:SetFontColor(190, 150, 225)
    AUSPrinter:Dump(debugLevel, ...)
end

function AUSDumpArray(debugLevel, ...)
    AUSPrinter:DumpArray(debugLevel, ...)
end
