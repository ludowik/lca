class('Bind')

function Bind:init(...)
    self:bind(...)
end

function Bind:bind(object, attrib, default, callback)
    if object and type(object) == 'table' and attrib and type(attrib) == 'string' then
        self.binding = {
            object = object,
            attrib = attrib,
            default = value(default, 0),
            callback = callback
        }

    elseif object and type(object) == 'string' then
        local i = object:findLast('%.')
        if i then
            local obj = object:left(i-1)
            local attrib = object:mid(i+1)
            self.binding = {
                object = evalExpression(obj),
                attrib = attrib,
                default = value(attrib, 0),
                callback = default
            }

        else
            self.binding = {
                object = _G.env or _G,
                attrib = object,
                default = value(attrib, 0),
                callback = default
            }
        end
    end

    if self:getValue() == nil and self.binding then
        self:setValue(self.binding.default)
    end

    return self
end

function Bind:getValue()
    if self.binding then
        return self.binding.object[self.binding.attrib]
    end
    return self.__value
end

function Bind:setValue(value)
    self.__value = value
    
    if self.binding then
        self.binding.object[self.binding.attrib] = value
        if self.binding.callback then
            self.binding.callback(self, value)
        end
    end
end
