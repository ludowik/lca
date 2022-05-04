function evalExpression(expression)
    local src = (
        "_G.__temp__ = "..tostring(expression)..NL..
        "return _G.__temp__")
    return evalCode(src)
end

function evalCode(source)
    assert(source)

    local f, err = loadstring(source)
    if f then
        local status, res = pcall(f)
        if status then
            return res
        end
    else
        print(err)
    end
end

function value(value, default)
    if value == nil then
        return default
    end
    return value
end

function setValue(expression, val)
    if val then
        local res = expression..' = '..val
        return load(res)()
    end
end

class('Eval').test = function ()
    assert(value(5) == 5)
    assert(value(6, 5) == 6)
    assert(value(nil, 5) == 5)
    assert(value() == nil)
    
    assert(evalExpression(12) == 12)
    assert(evalExpression('12') == 12)
    
    assert(setValue('__test__', 12) == nil and evalExpression('__test__') == 12)
end
