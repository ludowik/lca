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
    self.__buffers = table()
end

function MeshRender:bufferHasChanged(name, b)
    assert(b)
    if (not self.__buffers[name] or
        self.__buffers[name].buffer ~= b or
        self.__buffers[name].size ~= #b)
    then
        self.__buffers[name] = {
            buffer = b,
            size = #b
        }
        return true
    end

    return false
end

function MeshRender:update()
    if not self.vertices or #self.vertices == 0 then return end

    if self.needUpdate or self:bufferHasChanged('vertices', self.vertices) then
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

        self.mesh = love.graphics.newMesh(format, vertices, self.drawMode or 'triangles', 'static')

        if self.indices and #self.indices > 0 then
            self.mesh:setVertexMap(self.indices)
        end
    end

    if self.instancePosition then
        if self.needUpdate or self:bufferHasChanged('instancePosition', self.instancePosition) then
            self.instancePosition = self.instancePosition or {{1, 1, 1}}
            self.instanceScale = self.instanceScale or {{.5, .5, .5}}

            self.instanceMeshPosition = love.graphics.newMesh({
                    {"InstancePosition", "float", 3}
                },
                self.instancePosition, nil, "static")
            self.mesh:attachAttribute("InstancePosition", self.instanceMeshPosition, "perinstance")

            self.instanceMeshScale = love.graphics.newMesh({
                    {"InstanceScale", "float", 3},
                },
                self.instanceScale, nil, "static")
            self.mesh:attachAttribute("InstanceScale", self.instanceMeshScale, "perinstance")
        end
    end

    self.needUpdate = false
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

function MeshRender:drawModel(x, y, z, w, h, d, n)
    assert(not n)
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
        
        local clr = __fill() or __stroke()

        if clr then
            self:sendUniforms(shader)
            love.graphics.setColor(clr:unpack())

            if self.instancePosition and #self.instancePosition > 1 then
                love.graphics.drawInstanced(self.mesh, #self.instancePosition)
            
            elseif n and n > 1 then
                love.graphics.drawInstanced(self.mesh, n)
            
            else
                love.graphics.draw(self.mesh)
            end
        end
    end
    popMatrix()

    love.graphics.setShader(previousShader)
end

function MeshRender:drawInstanced(...)
    self:draw(...)
end

function MeshRender:sendUniforms(shader)
    local uniforms = self.uniforms or shader.uniforms or {}
    uniforms.pvm = {pvmMatrix():getMatrix()}

    -- TODO : compute the reverse matrix before and send it to the shader    
    uniforms.model = {modelMatrix():getMatrix()}

    uniforms.matrixModel = {modelMatrix():getMatrix()}
    uniforms.matrixPV = {pvMatrix():getMatrix()}

    if getCamera() then
        uniforms.cameraPos = getCamera().vEye
    end

    uniforms.light = lights
    uniforms.material = currentMaterial

    self:_sendUniforms(shader, uniforms)
end

function MeshRender:_sendUniforms(_shader, uniforms, baseName)
    assert(uniforms)

    -- TODO : enhance naming
    local shader = _shader.shader

    if uniforms then        
        for uniformName,uniform in pairs(uniforms) do
            local className = typeof(uniform)

            if className == 'table' and #uniform > 0 and classnameof(uniform[1]) == 'Light' then
                for i,light in ipairs(uniform) do
                    self:_sendUniforms(_shader, uniform[i], 'light['..(i-1)..'].')
                end

            elseif className == 'Material' then
                self:_sendUniforms(_shader, uniform, 'material.')

            else
                uniformName = (baseName or '')..uniformName

                if shader:hasUniform(uniformName) then
                    if className == 'Color' then
                        shader:send(uniformName, {uniform:unpack()})

                    elseif className == 'vec2' then
                        shader:send(uniformName, {uniform:unpack()})

                    elseif className == 'vec3' then                
                        shader:send(uniformName, {uniform:unpack()})

                    elseif className == 'vec4' then
                        shader:send(uniformName, {uniform:unpack()})

                    elseif className == 'Image' then
                        shader:send(uniformName, uniform.data)

                    else
                        shader:send(uniformName, uniform)
                    end
                end
            end
        end
    end
end
