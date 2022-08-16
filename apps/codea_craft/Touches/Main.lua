-----------------------------------------
-- Touches
-- Written by John Millard
-----------------------------------------
-- Description:
-- A simple library for handling touches.
--
-- Use touches.addHandler(handler, priority, multiTouch) to register a handler.
-- Handlers will be notified (by calling handler:touched(touch)) in order of priority (low to high)
-- Any that return true will capture the touch and recieve subsequent touch events.
-- The multi-touch option allows a single handler to capture more than one touch.
-- Use touched.removeHandler(handler) to remove existing handlers.
-----------------------------------------

-- Use this function to perform your initial setup
function setup()
    print("Hello Touches!")

    scene = craft.scene()
    scene.camera.z = -10
    scene.ambientColor = color(42, 42, 42, 255)
    scene.sun.active = false

    ground = scene:entity()
    ground.y = -2
    ground.model = craft.model.cube(vec3(10,0.1,10))
    ground.material = craft.material(asset.builtin.Materials.Standard)

    -- Example class that uses touches library
    Bulb = class()

    function Bulb:init(entity, x, y, z, c)
        self.entity = entity
        self.entity.position = vec3(x, y, z)
        self.color = c
        self.light = self.entity:add(craft.light, POINT)
        self.light.color = c
        self.light.intensity = 0.2
        self.light.distance = 3
        self.entity:add(craft.rigidbody, STATIC)
        self.entity:add(craft.shape.sphere, 0.5)
        self.entity.model = craft.model.icosphere(0.5, 3, false)
        self.entity.material = craft.material(asset.builtin.Materials.Basic)
        self.entity.material.diffuse = c * 0.2

        -- Add to list of touch handlers
        touches.addHandler(self)
    end

    -- The touches function is automatically called on handlers
    function Bulb:touched(touch)
        if touch.state == BEGAN then

            -- Returning true will capture this touch and prevent other handlers from getting it
            local origin, dir =
                scene.camera:get(craft.camera):screenToRay(vec2(touch.x, touch.y))

            -- Do a raycast to check if touch is hitting the bulb
            hit = scene.physics:raycast(origin, dir, 10)

            if hit and hit.entity == self.entity then
                -- Turn up light intensity
                self.light.intensity = 3
                self.entity.material.diffuse = self.color
                print("Touch Began (Captured - "..touch.id..")")
                return true
            end
        elseif touch.state == ENDED then
            -- Turn down intensity when touch ends
            self.light.intensity = 0.2
            self.entity.material.diffuse = self.color * 0.2
            print("Touch Ended (Captured - "..touch.id..")")
        end
    end

    scene:entity():add(Bulb,
        -1.5, 0, 0,
        color(182, 198, 71, 255))

    scene:entity():add(Bulb,
        0, 0, 0,
        color(199, 72, 132, 255))

    scene:entity():add(Bulb,
        1.5, 0, 0,
        color(72, 98, 198, 255))
end

function update(dt)
    scene:update(dt)
end

function draw()
    update(DeltaTime)
    scene:draw()
end
