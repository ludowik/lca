class 'MeshRender'

local function vec2(x, y, uvx, uvy)
    return {x, y, uvx, uvy}
end

local format = {
    {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
    {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
    {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
}

function MeshRender:draw()
    local vertices
    if self.vertices[1].x then
        vertices = table()
        local clr = colors.red
        for i,v in ipairs(self.vertices) do
            vertices:add({
                    v.x,
                    v.y,
                    v.z,
                    #self.texCoords > 0 and self.texCoords[i].x or 0,
                    #self.texCoords > 0 and self.texCoords[i].y or 0,
                    clr.r,
                    clr.g,
                    clr.b,
                    clr.a})
        end
    else
        vertices = self.vertices
    end

    if #vertices < 3 then return end

    love.graphics.setColor(colors.white:unpack())

    local m = love.graphics.newMesh(format, vertices)

    if type(self.texture) == 'string' then
        self.texture = Image.getImage(self.texture)
    end

    if self.texture then
        m:setTexture(self.texture.canvas)
    end

    GraphicsCore.createShader()
    assert(shaders['shader3D'])
    
    local shader = love.graphics.getShader()
    love.graphics.setShader(shaders['shader3D'])
    shaders['shader3D']:send('pvm', {
            pvmMatrix():getMatrix()
        })

    love.graphics.draw(m)

    love.graphics.setShader(shader)
end

function MeshRender:drawInstanced(n)
    self:draw()
end
