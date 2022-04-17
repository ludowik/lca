


function class()
    local k = {}
    k.__index = k

    setmetatable(k, { 
            __call = function(_, ...)
                local instance = setmetatable({}, k)
                k.init(instance, ...)
                return instance
            end
        })

    return k
end



Color = class 'Color'

function Color:init(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a or 1
end

function Color:unpack()
    return self.r, self.g, self.b, self.a
end

colors = {
    white= Color(1, 1, 1),
    red = Color(1, 0, 0),
}
