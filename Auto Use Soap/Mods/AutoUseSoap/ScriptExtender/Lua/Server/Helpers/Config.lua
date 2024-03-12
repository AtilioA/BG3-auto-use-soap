Config = Helpers.Config:New({
  folderName = "AutoUseSoap",
  configFilePath = "auto_use_soap_config.json",
  defaultConfig = {
    GENERAL = {
      enabled = true, -- Toggle the mod on/off
    },
    FEATURES = {
      add_soap_items = true,         -- Ensure party has enough soap items for each member by adding to the camp chest
      use_when_entering_camp = true, -- Use soap when entering camp
      use_after_combat = true,       -- Use soap after combat ends
    },
    DEBUG = {
      level = 0 -- 0 = no debug, 1 = minimal, 2 = verbose logs
    }
  },
  onConfigReloaded = {}
})

Config:UpdateCurrentConfig()

Config:AddConfigReloadedCallback(function(configInstance)
  AUSPrinter.DebugLevel = configInstance:GetCurrentDebugLevel()
  AUSPrint(0, "Config reloaded: " .. Ext.Json.Stringify(configInstance:getCfg(), { Beautify = true }))
end)
Config:RegisterReloadConfigCommand("aus")
