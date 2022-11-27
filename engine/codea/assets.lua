class 'Documents'

function Documents:init()
    self.all = {}

    setmetatable(self, {
            __index = function(_, name, value)
                return Image()
            end,
        })

end

function Documents:__tostring()
    return ''
end

function Documents:_index()
    assert()
end

asset = {
    documents = Documents(),

    builtin = {
        Cargo_Bot = Documents(),
        Platformer_Art = Documents(),
        Planet_Cute = Documents(),
        Small_World = Documents(),
        Tyrian_Remastered = Documents(),
        Blocky_Characters = Documents(),
        Watercraft = Documents(),
        RacingKit = Documents(),
        SpaceKit = Documents(),
        CastleKit = Documents(),
        Primitives = Documents(),
        Nature = Documents(),
        
        Patterns = Documents(),
        
        Materials = {
            Basic = Craft and Craft.material()
        },

        UI = {
            Grey_Panel,
            Blue_Panel,
        },

        Blocks = {
            Blank_White,
        },

        Effects = {
            Ripple,
        },
    }
}
