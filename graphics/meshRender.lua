class 'MeshRender'

local function vec2(x, y, uvx, uvy)
    return {x, y, uvx, uvy}
end

local format = {
    {"VertexPosition", "float", 3}, -- The x,y,z position of each vertex.
    {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
    {"VertexColor", "byte", 4},     -- The r,g,b,a color of each vertex.
    {"VertexNormal", "float", 3}    -- The x,y,z direction of each normal.
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
                    #self.normals > 0 and self.normals[i].z or 0,
                })
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

function MeshRender:getShader()
    if __light() then
        return shaders.light
    end
    if self.shader then return self.shader end
    return shaders.default
end


function MeshRender:drawModel(x, y, z, w, h, d)
    local shader = self:getShader()

    local previousShader = love.graphics.getShader()
    love.graphics.setShader(shader.shader)

    pushMatrix()
    do
        if x then
            translate(x, y, z)
        end

        if w then
            scale(w, h, d)
        end

        if __fill() then
            self:sendUniforms(shader)
            love.graphics.setColor(__fill():unpack())
            love.graphics.draw(self.mesh)            
        end
    end
    popMatrix()

    love.graphics.setShader(previousShader)
end

function MeshRender:drawInstanced(n)
    self:draw()
end

function MeshRender:sendUniforms(shader)    
    local uniforms = shader.uniforms or self.uniforms or {}
    uniforms.pvm = {pvmMatrix():getMatrix()}
    uniforms.model = {modelMatrix():getMatrix()}

    shader = shader.shader
    
    if uniforms then        
        for k,u in pairs(uniforms) do
            if shader:hasUniform(k) then                
                local className = classnameof(u)
                if className == 'Color' then
                    shader:send(k, {u:unpack()})

                elseif className == 'vec2' then
                    shader:send(k, {u:unpack()})

                elseif className == 'vec3' then                
                    shader:send(k, {u:unpack()})

                elseif className == 'vec4' then
                    shader:send(k, {u:unpack()})

                elseif className == 'Image' then
                    shader:send(k, u.data)

                else
                    shader:send(k, u)
                end
            end
        end
    end 
end
