local addBloodChannel = Ext.Net.CreateChannel(ModuleUUID, "AddBlood")

-- Insert a new tab now that the MCM is ready (JUST A DEMONSTRATION)
if MCM.Get("debug_level") > 1 then
    MCM.InsertModMenuTab("Debug", function(tabHeader)
        local addBlood = tabHeader:AddButton("Add blood")
        local addDirt = tabHeader:AddButton("Add dirt")
        addBlood.OnClick = function()
            _P("Adding blood for debugging purposes")
            addBloodChannel:SendToServer({})
        end
        addDirt.OnClick = function()
            _P("Adding dirt for debugging purposes")
            addBloodChannel:SendToServer({})
        end
    end)
end
