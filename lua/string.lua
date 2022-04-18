function string:random()
    local i = random(1, #self)
    return self:sub(i, i)
end
