require 'engine.engine'

loadApps()

if config.appName then
    loadApp(config.appName)
end
