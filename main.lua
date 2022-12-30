--simulate_ios = true

require 'engine'

--APPS = 'apps_archive'
APPS = 'apps'

--debugStart()

config.appPath = 'apps'
config.appName = 'apps'



local url = 'https://raw.githubusercontent.com/ludowik/lca/main/lca.love'
http.request(url, function ()
        exit()
    end,
    function (result, code, headers)
        print(headers)
    end)

