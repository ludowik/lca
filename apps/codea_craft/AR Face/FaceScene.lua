FaceScene = class()

function FaceScene:init()
    -- Create a new craft scene
    self.scene = craft.scene()

    -- Setup lighting
    self.scene.ambientColor = color(63, 63, 63, 255)
    self.sunLight = self.scene.sun:get(craft.light)
    self.sunLight.intensity = 0.7
    self.scene.sun.rotation = quat.eulerAngles(80, 0, 0)

    -- Setup bloom post processing effect
    self.cameraComponent = self.scene.camera:get(craft.camera)
    self.cameraComponent.hdr = true
    self.cameraComponent.colorTextureEnabled = true
    self.bloom = craft.bloomEffect()
    self.cameraComponent:addPostEffect(self.bloom)
    self.bloom.threshold = 1.5
    self.bloom.intensity = 1.2
    self.bloom.softThreshold = 0.4
    self.bloom.iterations = 8

    -- Keep a list of detected faces
    self.faces = {}


    -- The current tracking state
    self.trackingState =
    {
        [AR_NOT_AVAILABLE] = "Not Available",
        [AR_LIMITED] = "Limited",
        [AR_NORMAL] = "Normal"
    }

    -- Create some materials to apply to faces
    self:createMaterials()

    self:runAR()
end

function FaceScene:createMaterials()
    -- List of materials
    -- Each one contains it's name, the material object and a function to setup/apply it
    self.materials =
    {
        {
            name = "Bricks",
            material = craft.material(asset.Bricks),
            setup = function(face, material)
                face.entity.material = material
                face.leftEye.material = face.blankMaterial
                face.rightEye.material = face.blankMaterial
                material.brickGradient.repeats = false

                parameter.integer("BrickCountX", 5, 30, 10, function(value)
                    material.brickCount = vec2(BrickCountX, BrickCountY)
                end)

                parameter.integer("BrickCountY", 5, 60, 20, function(value)
                    material.brickCount = vec2(BrickCountX, BrickCountY)
                end)
            end
        },

        {
            name = "Glowing Eyes",
            material = craft.material(asset.builtin.Materials.Basic),
            setup = function(face, material)
                face.entity.material = face.blankMaterial
                face.leftEye.material = material
                face.rightEye.material = material

                -- Combine color and intensity for HDR effects
                Intensity = 5
                parameter.color("Color", color(255, 50, 0, 0), function(c)
                    local d = vec3(Color.r/255, Color.g/255, Color.b/255) * Intensity
                    material.diffuse = d
                end)

                parameter.number("Intensity", 0.0, 100, 5, function(i)
                    local d = vec3(Color.r/255, Color.g/255, Color.b/255) * Intensity
                    material.diffuse = d
                end)
            end
        },

        {
            name = "Fresnel",
            material = craft.material(asset.Fresnel),
            setup = function(face, material)
                face.entity.material = material
                face.leftEye.material = material
                face.rightEye.material = material

                parameter.color("Color", color(0, 168, 255, 255), function(c)
                    material.color = c
                end)

                parameter.number("Power", 0.5, 10, 2, function(p)
                    material.power = p
                end)

                parameter.number("Intensity", 0.0, 10, 1, function(i)
                    material.intensity = i
                end)
            end
        },

        {
            name = "Blank",
            material = craft.material(asset.builtin.Materials.Standard),
            setup = function(face, material)
                face.entity.material = material
                face.leftEye.material = material
                face.rightEye.material = material
            end
        }
    }
end

-- Set the currently active material
function FaceScene:setMaterial(face, m)
    parameter.clear()

    CurrentMaterial = m
    parameter.watch("scene.materials[CurrentMaterial].name")

    self.materials[m].setup(face, self.materials[m].material)

    -- Option to show blend shape data
    parameter.boolean("ShowBlendShapes", ShowBlendShapes or false)

    -- Buttons to change the currently active material
    parameter.action("Next", function()
        if CurrentMaterial < #self.materials then
            self:setMaterial(face, CurrentMaterial+1)
        end
    end)

    parameter.action("Previous", function()
        if CurrentMaterial > 1 then
            self:setMaterial(face, CurrentMaterial-1)
        end
    end)

    parameter.action("Pause/Resume", function()
        if self.scene.ar.isRunning then
            self.scene.ar:pause()
        else
            self.scene.ar:run(AR_FACE_TRACKING)
        end
    end)
end

function FaceScene:runAR()
    if craft.ar.isFaceTrackingSupported and not self.scene.ar.isRunning then
        -- Enable AR Face Tracking session (if supported)
        self.scene.ar:run(AR_FACE_TRACKING)

        -- Callback for when new faces are detected
        self.scene.ar.didAddAnchors = function(anchors)
            for _, anchor in pairs(anchors) do
                -- Create a new entity for the face and apply a Face lua component
                local face = self.scene:entity():add(Face, self.scene, anchor)
                self.faces[anchor.identifier] = face
                self:setMaterial(face, 1)
            end
        end

        -- Callback for when existing faces are updated
        self.scene.ar.didUpdateAnchors = function(anchors)
            for _, anchor in pairs(anchors) do
                -- Retrieve the face component based on the anchor identifier
                local face = self.faces[anchor.identifier]
                -- Update the face component based on changes to the anchor (i.e. position, rotation)
                face:updateWithAnchor(anchor)
            end
        end

        -- Callback for removing faces that no longer exist
        self.scene.ar.didRemoveAnchors = function(anchors)
            for _, anchor in pairs(anchors) do
                local face = self.faces[anchor.identifier]
                -- Destroy the face's entity
                face.entity:destroy()
                -- Clear the entry from our list of faces
                self.faces[anchor.identifier] = nil
            end
        end
    end
end

function FaceScene:update(dt)
    self.scene:update(dt)
end

function FaceScene:draw(width, height)
    -- Draw the scene
    self.scene:draw()

    -- Determine the status of tracking
    local status = nil
    if craft.ar.isFaceTrackingSupported then
        if self.scene.ar.isRunning then
            status = self.trackingState[self.scene.ar.trackingState]
        else
            status = "AR Session Paused"
        end
    else
        status = "Face Tracking Not Supported"
    end

    -- Print current tracking status
    fill(255, 255, 255, 255)
    text(status, width/2, height - 50)

    -- Draw all known blend shapes as a list with visual indicators
    -- 0.0 means no expression of that type, 1.0 means full expression
    if ShowBlendShapes then
        pushStyle()
        textAlign(LEFT)
        textMode(CORNER)
        fontSize(15)
        font("Inconsolata")

        local lineHeight = 15
        local gap = 2
        local tx, ty = 15, HEIGHT-15 - lineHeight

        for _, face in pairs(self.faces) do
            for key, value in pairs(face.blendShapes) do
                fill(89, 89, 89, 255)
                rect(tx, ty, 250, lineHeight)
                fill(79, 136, 69, 255)
                rect(tx, ty, 250 * value, lineHeight)
                fill(222, 222, 222, 255)
                text(string.format("%s: %1.1f", key, value), tx, ty)
                ty = ty - lineHeight - gap
            end
        end
        popStyle()
    end
end
