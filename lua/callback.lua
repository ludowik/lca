class 'Action'

function Action:init(description, f)
    self.description = description
    self.f = f
end

function Action:__call(...)
    return self.f(...)
end

function Action:__tostring(...)
    return self.description
end

function callback(...) -- description, object, f, ...)
    local args = args(...)

    local description, object, f = args:get(
        {'string', '???'},
        {'table', niltable},
        {'function', nilf})

    if object == niltable then
        object = nil
    end

    if not f then
        error('bad parameters')
    end

    return Action(description, function (...)
            local args2 = Table{...} + args
            if object then
                f(object, unpack(args2))
            else
                f(unpack(args2))
            end
        end)
end
