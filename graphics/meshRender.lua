class 'MeshRender'

local function vec2(x, y, uvx, uvy)
    return {x, y, uvx, uvy}
end

local format = {
    {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
    {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
    {"VertexColor", "byte", 4},     -- The r,g,b,a color of each vertex.
    {"VertexNormal", "float", 3},    -- The x,y position of each vertex.
}

function MeshRender:init()
end

function MeshRender:clear()
    self.__vertices = nil
end

function MeshRender:update()
    if not self.vertices or #self.vertices == 0 then return end

    if (not self.needUpdate and
        self.__vertices and
        #self.__vertices == #self.vertices and
        self.__verticesSave == self.vertices)
    then
        return
    end

    if not self.__vertices then
        print('updateMesh ', self.needUpdate)
    else
        print('updateMesh ', self.needUpdate, self.__vertices, #self.__vertices == #self.vertices, self.__verticesSave == self.vertices)
    end

    self.needUpdate = false

    local vertices
    if self.vertices[1].x then
        vertices = table()
        for i,v in ipairs(self.vertices) do
            local clr = self.colors[i] or colors.white
            vertices:insert({
                    v.x,
                    v.y,
                    v.z,
                    #self.texCoords > 0 and self.texCoords[i].x or 0,
                    #self.texCoords > 0 and self.texCoords[i].y or 0,
                    clr.r,
                    clr.g,
                    clr.b,
                    clr.a,
                    #self.normals > 0 and self.normals[i].x or 0,
                    #self.normals > 0 and self.normals[i].y or 0,
                    #self.normals > 0 and self.normals[i].y or 0,})
        end
    else
        vertices = self.vertices
    end
    self.__vertices = vertices
    self.__verticesSave = self.vertices

    self.mesh = love.graphics.newMesh(format, vertices, self.drawMode or 'triangles', 'static')
end

function MeshRender:draw(...)
    if not self.vertices or #self.vertices == 0 then return end

    self:update()

    local vertices = self.__vertices
    if #vertices < 3 then return end

    love.graphics.setColor(colors.white:unpack())

    if type(self.texture) == 'string' then
        self.texture = Image.getImage(self.texture)
    end

    if self.texture then
        self.mesh:setTexture(self.texture.data)
    end

    MeshRender.drawModel(self, ...)
end

function MeshRender.drawModel(mesh, x, y, z, w, h, d)
    GraphicsCore.createShader()
    local shader = shaders.default or mesh.shader or GraphicsCore.shader3D
    local shaderLove = shader.shader or shader

    local previousShader = love.graphics.getShader()
    love.graphics.setShader(shaderLove)

    pushMatrix()
    do
        if x then
            translate(x, y, z)
        end

        if w then
            scale(w, h, d)
        end

        if __fill() then
            if mesh.uniforms then
                for k,u in pairs(mesh.uniforms) do
                    if shaderLove:hasUniform(k) then
                        shaderLove:send(k, u)
                    end
                end
            end            

            shaderLove:send('pvm', {
                    pvmMatrix():getMatrix()
                })

            love.graphics.setColor(__fill():unpack())

--            Graphics.drawMesh(mesh)
            love.graphics.draw(mesh.mesh)            
        end
    end
    popMatrix()

    love.graphics.setShader(previousShader)
end

function MeshRender:drawInstanced(n)
    self:draw()
end
