--[[
Face class for displaying detected AR faces
This is added to an entity as a lua component then updated periodically by the AR system

AR objects are presented via anchors
The AR Face Anchor object contains the following information:

* anchor.faceModel (model)
  The face model (can be added to an entity to render)

* anchor.position (vec3)
  The position of the face in world coordinates

* anchor.rotation (quat)
  The rotation of the face in world coordinates

* anchor.blendShapes (table)
  A table containing key value pairs for all face blend shapes

* anchor.leftEyePosition (vec3)
  The position of the left eye in local face coordinates

* anchor.leftEyeRotation (quat)
  The rotation of the left eye in local face coordinates

* anchor.rightEyePosition (vec3)
  The position of the right eye in local face coordinates

* anchor.rightEyeRotation (quat)
  The rotation of the right eye in local face coordinates

* anchor.lookAtPoint (vec3)
  The point in space that the eyes are looking at in local face coordinates
--]]

Face = class()

function Face:init(entity, scene, anchor)
    self.entity = entity

    -- Apply the anchor's face model to our entity
    -- This model will update automatically for the lifetime of the face anchor
    self.entity.model = anchor.faceModel

    -- Blank material is used to occlude other objects (using depth) without overwriting colors
    self.blankMaterial = craft.material(asset.builtin.Materials.Basic)
    self.blankMaterial.colorMask = COLOR_MASK_NONE
    self.blankMaterial.order = -1

    -- Create models for the eyes and parent them to the face
    -- This can be used for eye-based effects

    -- Keep in mind that the eye scale is approximate and varies per individual
    local eyeScale = vec3(1,1,1) * 0.016

    self.leftEye = scene:entity()
    self.leftEye.parent = self.entity
    self.leftEye.model = craft.model(asset.builtin.Primitives.Sphere)
    self.leftEye.material = self.blankMaterial
    self.leftEye.scale = eyeScale

    self.rightEye = scene:entity()
    self.rightEye.parent = self.entity
    self.rightEye.model = craft.model(asset.builtin.Primitives.Sphere)
    self.rightEye.material = self.blankMaterial
    self.rightEye.scale = eyeScale

    self:updateWithAnchor(anchor)
end

function Face:updateWithAnchor(anchor)
    self.entity.position = anchor.position
    self.entity.rotation = anchor.rotation
    self.blendShapes = anchor.blendShapes

    -- Adjustment for eye positions to avoid clipping with face. May vary per individual.
    local eyeAdjust = 0.003

    self.leftEye.rotation = anchor.leftEyeRotation
    self.rightEye.rotation = anchor.rightEyeRotation
    self.leftEye.position = anchor.leftEyePosition - self.leftEye.forward * eyeAdjust
    self.rightEye.position = anchor.rightEyePosition - self.rightEye.forward * eyeAdjust
end
