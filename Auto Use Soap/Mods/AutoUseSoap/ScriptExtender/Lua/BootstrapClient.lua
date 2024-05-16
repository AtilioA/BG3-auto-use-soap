-- Insert a new tab now that the MCM is ready (JUST A DEMONSTRATION)
if Mods.BG3MCM.MCMAPI:GetSettingValue('debug_level', ModuleUUID) > 1 then
    Mods.BG3MCM.IMGUIAPI:InsertModMenuTab(ModuleUUID, "Debug", function(tabHeader)
        local addBlood = tabHeader:AddButton("Add blood")
        local addDirt = tabHeader:AddButton("Add dirt")
        addBlood.OnClick = function()
            _P("Adding blood for debugging purposes")
            Ext.Net.PostMessageToServer("AUS_AddBlood", Ext.Json.Stringify({}))
        end
        addDirt.OnClick = function()
            _P("Adding dirt for debugging purposes")
            Ext.Net.PostMessageToServer("AUS_AddBlood", Ext.Json.Stringify({}))
        end
    end)
end
