function table:tolua(level)
    if not self then return '' end
    
    level = level or 1
    local function tab(level)
        return string.rep('    ', level)
    end
    
    local t = ''
    for k,v in pairs(self) do
        local val
        local typeof = type(v)
        if typeof == 'string' then
            val = '"' .. v .. '"'
            
        elseif typeof == 'boolean' then
            val = v and 'true' or 'false'
            
        elseif typeof == 'table' then
            val = table.tolua(v, level+1)
            
        else
            val = tostring(v)
        end
        t = t .. tab(level) .. k .. ' = ' .. val .. ',\n'
    end
    return '{\n' .. t .. tab(level-1) .. '}'
end
