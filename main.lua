--simulate_ios = true

require 'engine'

--APPS = 'apps_archive'
APPS = 'apps'

--debugStart()

local __require
require = function (...)
    return __require(...)
end
