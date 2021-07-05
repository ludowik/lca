require 'engine.#'

local env = {}
_G.env = env

setmetatable(env, {__index=_G})
setfenv(0, env)

require 'apps.2048'
