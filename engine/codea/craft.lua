-- craft
NORTH = 'NORTH'
EAST  = 'EAST'
SOUTH = 'SOUTH'
WEST  = 'WEST'
UP    = 'UP'
DOWN  = 'DOWN'

MODELS = 'models'

AR_NOT_AVAILABLE = 'AR_NOT_AVAILABLE'
AR_LIMITED = 'AR_LIMITED'
AR_NORMAL = 'AR_NORMAL'

craft = class 'Craft'

function Craft.setup()
    Craft.ar = {
        isSupported = false,
    }

    Craft.block = {
        static = class(),
    }

    Craft.shape = {
        capsule = Craft.shape,
        sphere = Craft.shape,
    }
end

class 'Craft.Scene' : extends(Node)

function Craft.Scene:init()
    Scene.init(self)

    self.sun = Craft.Node()
    self.sun[craft.light] = craft.light()

    self.sky = Craft.Node()
    self.sky.material = table()

    self.camera = Craft.Node()
    self.camera[craft.camera] = craft.camera()

    self.voxels = Craft.Voxels()

    self.physics = Physics.instance()
end

function Craft.Scene:entity(...)
    return Craft.Node()
end

class 'Craft.State' : extends(Node)

function Craft.State:addFlag(...)
end

function Craft.State:addRange(...)
end

class 'Craft.Node' : extends(Node)

function Craft.Node:init()
    Node.init(self)

    self.static = class()
    self.state = Craft.State()

    self.x, self.y, self.z = 0, 0, 0
    self.worldPosition = vec3()

    self.up = vec3()
    self.forward = vec3()
end

function Craft.Node:destroy()
end

function Craft.Node:all()
    return {}
end

function Craft.Node:get(entity)
    return self[entity]
end

function Craft.Node:add(entity, ...)
    self[entity] = entity(self, ...)
    self[entity].entity = self
    return self[entity]
end

function Craft.Node:remove(entity)
end

function Craft.Node:addAssetPack(...)
end

function Craft.Node:setTexture(...)
end

function Craft.Node:setColor(...)
end

function Craft.Node:resize(...)
end

function Craft.Node:new(...)
    return Craft.Node()
end

class 'Craft.Voxels' : extends(Node)

function Craft.Voxels:init()
    self.blocks = Craft.Node()
    self.blocks.Empty = {
        static = class()
    }

    self.blocks.Solid = {
        static = class(),
        name = '',
    }
end

function Craft.Voxels:all()
    return {}
end

function Craft.Voxels:generate(generationCode, generationFunction)
    enableGlobal()
    do
        load(generationCode)()
        _G.env[generationFunction](Craft.volume())
    end
    disableGlobal()
end

function Craft.Voxels:raycast()
end

function Craft.Voxels:deleteStorage(...)
end

function Craft.Voxels:fill(...)
end

function Craft.Voxels:box(...)
end

class 'Craft.Camera' : extends(Camera)

function Craft.Camera:init(...)
    self.postEffects = table()
    self.entity = Craft.Node()
end

function Craft.Camera:viewport(...)
end

function Craft.Camera:restart(...)
end

function Craft.Camera:draw()
end

function Craft.Camera:lookAt()
end

function Craft.Camera:addPostEffect(effect)
    self.postEffects:add(effect)
end

function Craft.Camera:screenToRay()
    return vec3(), vec3(0, 0, -1)
end

class 'Craft.light'
class 'Craft.effect'
class 'Craft.material'
class 'Craft.renderer'
class 'Craft.cubeTexture'

class 'Craft.model'
class 'Craft.shape'
class 'Craft.volume'
class 'Craft.model'
class 'Craft.rigidbody'

function Craft.scene(...)
    return Craft.Scene(...)
end

function Craft.camera(...)
    return Craft.Camera(...)
end

function Craft.bloomEffect(...)
    return Craft.effect(...)
end

function Craft.model:init(...)
    self.bounds = bounds(...)
    self.vertexCount = 0
    self.material = Craft.material()
end

function Craft.model.cube(...)
    return Craft.model(...)
end

function Craft.model.icosphere(...)
    return Craft.model(...)
end

function Craft.model:getMaterial()
    return self.material
end

function Craft.volume:init(name)
    if name then
        Craft.volume:load(name)
    end    
end

function Craft.volume:setWithNoise()
end

function Craft.volume:blockID()
    return 1
end

function Craft.volume:set()
end

function Craft.volume:get()
end

function Craft.volume:load(name)
    self.model = Craft.model()
end

function Craft.volume:save(name)
end

function Craft.volume:loadSnapshot(img)
end

function Craft.volume:saveSnapshot()
    return Image()
end

function Craft.volume:size()
    return 1, 1, 1
end

function Craft.volume:resize()
end

function Craft.volume:raycast()
end

class 'craft.noise'

function craft.noise.perlin()
    return craft.noise()
end

function craft.noise.rigidMulti()
    return craft.noise()
end

function craft.noise.turbulence()
    return craft.noise()
end

function craft.noise.const()
    return craft.noise()
end

function craft.noise.select()
    return craft.noise()
end

function craft.noise.scale()
    return craft.noise()
end

function craft.noise.scaleOffset()
    return craft.noise()
end

function craft.noise.gradient()
    return craft.noise()
end

function craft.noise.displace()
    return craft.noise()
end

function craft.noise.chunkCache2D()
    return craft.noise()
end

function craft.noise:init()
end

function craft.noise:setSource()
    return self
end

function craft.noise:setBounds()
    return self
end

function craft.noise:getValue(...)
    return noise(...)
end

Craft.setup()
