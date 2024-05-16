AUSPrinter = VolitionCabinetPrinter:New { Prefix = "Auto Use Soap", ApplyColor = true, DebugLevel = MCMGet("debug_level") }

-- Update the Printer debug level when the setting is changed, since the value is only used during the object's creation
Ext.RegisterNetListener("MCM_Saved_Setting", function(call, payload)
    local data = Ext.Json.Parse(payload)
    if not data or data.modGUID ~= ModuleUUID or not data.settingId then
        return
    end

    if data.settingId == "debug_level" then
        AUSDebug(0, "Setting debug level to " .. data.value)
        AUSPrinter.DebugLevel = data.value
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
