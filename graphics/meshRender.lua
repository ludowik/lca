class 'MeshRender'

local function vec2(x, y, uvx, uvy)
    return {x, y, uvx, uvy}
end

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
                    clr.r,
                    clr.g,
                    clr.b,
                    clr.a})
        end
    else
        vertices = self.vertices
    end

    if #vertices < 3 then return end

--    love.graphics.setColor(colors.white:unpack())
    
    local m = love.graphics.newMesh(vertices)

    if type(self.texture) == 'string' then
        self.texture = Image.getImage(self.texture)
    end

    if self.texture then
        m:setTexture(self.texture.canvas)
    end

    GraphicsCore.createShader()
    assert(shaders['shader3D'])
    love.graphics.setShader(shaders['shader3D'])
    shaders['shader3D']:send('pvm', {
                    pvmMatrix():getMatrix()
                })
    love.graphics.draw(m)
    love.graphics.setShader()
end

function MeshRender:drawInstanced()
end
