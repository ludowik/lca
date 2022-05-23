class 'MeshRender'

local function vec2(x, y, uvx, uvy)
    return {x, y, uvx, uvy}
end

function MeshRender:draw()
    local vertices
    if self.vertices[1].x then
        vertices = table()
        for i,v in ipairs(self.vertices) do
            vertices:add(vec2(v.x, v.y))
        end
    else
        vertices = self.vertices
    end
    
    if #vertices < 3 then return end

    local m = love.graphics.newMesh(vertices)

    if type(self.texture) == 'string' then
        self.texture = Image.getImage(self.texture)
    end

    if self.texture then
        m:setTexture(self.texture.canvas)
    end

    love.graphics.draw(m)
end

function MeshRender:drawInstanced()
end
