require 'engine.#'

local env = {}
_G.env = env

setmetatable(env, {__index=_G})
setfenv(0, env)

require 'apps.2048'


-- TODO : déplacement des fenêtres
-- TODO : sauvegarde du placement des fenêtres

-- TODO : gestion d'une base clé / valeur
